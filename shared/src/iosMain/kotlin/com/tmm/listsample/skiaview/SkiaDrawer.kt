package com.tmm.listsample.skiaview

import androidx.compose.ui.ComposeScene
import cocoapods.TMMUIKit.TMMUIView
import kotlinx.cinterop.autoreleasepool
import kotlinx.cinterop.objcPtr
import org.jetbrains.skia.BackendRenderTarget
import org.jetbrains.skia.ColorSpace
import org.jetbrains.skia.DirectContext
import org.jetbrains.skia.Picture
import org.jetbrains.skia.PictureRecorder
import org.jetbrains.skia.Rect
import org.jetbrains.skia.Surface
import org.jetbrains.skia.SurfaceColorFormat
import org.jetbrains.skia.SurfaceOrigin
import platform.Metal.MTLCommandBufferProtocol
import platform.Metal.MTLCreateSystemDefaultDevice
import platform.QuartzCore.CAMetalLayer
import platform.darwin.dispatch_async
import platform.darwin.dispatch_barrier_sync
import kotlin.system.getTimeNanos

private const val SkiaCanvasClearColor = -1

internal class SkiaDrawer(private val view: SkiaDrawView, private val scene: ComposeScene) {

    private var redrawRequestCounter: Int = 0

    private val device = MTLCreateSystemDefaultDevice()!!

    private val commandQueue = device.newCommandQueue()!!

    private val directContext = DirectContext.makeMetal(device.objcPtr(), commandQueue.objcPtr())

    private var renderTarget: BackendRenderTarget? = null

    private var surface: Surface? = null

    /**
     * Frame id
     */
    private var frameId: UInt = 0U

    private var isDisposed: Boolean = false

    init {
        view.setRunLoopTask {
            drawIfNeed()
        }
    }

    /*
    *  invalidate from ComposeScene
    */
    fun requestRedraw() {
        redrawRequestCounter++
    }

    fun dispose() {
        if (isDisposed) return
        isDisposed = true
        redrawRequestCounter = 0
        view.setRunLoopTask(null)
        dispatch_barrier_sync(TMMUIView.renderQueue()) {
            disposeCanvas()
            directContext.close()
        }
    }

    private fun drawIfNeed() {
        if (redrawRequestCounter > 0) {
            redrawRequestCounter = 0
            draw()
        }
    }

    private fun draw() {
        view.run {
            val picture = performComposeRendering(renderRect, scene)
            runOnRenderQueue(renderRect, picture, drawableLayer() as CAMetalLayer)
        }
    }

    private fun runOnRenderQueue(
        renderRect: Rect,
        picture: Picture,
        layer: CAMetalLayer
    ) {
        val commandBuffer = commandQueue.commandBuffer() ?: return disposeCanvas()
        cancelDrawToCanvas()
        val guard = frameId
        dispatch_async(TMMUIView.renderQueue()) {
            autoreleasepool {
                if (guard == frameId) renderPictureToCanvas(
                    renderRect,
                    layer,
                    picture,
                    commandBuffer
                )
            }
        }
    }

    private fun cancelDrawToCanvas() = frameId++

    private fun disposeCanvas() {
        surface?.close()
        renderTarget?.close()
    }

    private fun performComposeRendering(renderRect: Rect, scene: ComposeScene): Picture {
        val recorder = PictureRecorder()
        val canvas = recorder.beginRecording(renderRect)
        scene.render(canvas, getTimeNanos())
        return recorder.finishRecordingAsPicture()
    }

    private fun renderPictureToCanvas(
        renderRect: Rect,
        layer: CAMetalLayer,
        picture: Picture,
        commandBuffer: MTLCommandBufferProtocol
    ) {
        disposeCanvas()
        val drawable = layer.nextDrawable() ?: return
        val backendRenderTarget =
            BackendRenderTarget.makeMetal(
                renderRect.width.toInt(),
                renderRect.height.toInt(),
                drawable.texture.objcPtr()
            )
        renderTarget = backendRenderTarget

        // make surface
        surface = Surface.makeFromBackendRenderTarget(
            directContext,
            backendRenderTarget,
            SurfaceOrigin.TOP_LEFT,
            SurfaceColorFormat.BGRA_8888,
            ColorSpace.sRGB
        )

        surface?.run {
            canvas.run {
                scale(TMMViewContentScaleFactor, TMMViewContentScaleFactor)
                clear(SkiaCanvasClearColor)
                drawPicture(picture)
            }

            flushAndSubmit()

            commandBuffer.run {
                label = "com.tmm.skia.present"
                presentDrawable(drawable)
                commit()
            }
        }
    }
}