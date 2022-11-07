package com.tmm.listsample.skiaview

import androidx.compose.runtime.Composable
import androidx.compose.ui.ComposeScene
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.pointer.PointerType
import androidx.compose.ui.input.pointer.toCompose
import androidx.compose.ui.unit.Constraints
import cocoapods.TMMUIKit.TMMUIView
import kotlinx.cinterop.CValue
import kotlinx.cinterop.useContents
import kotlinx.coroutines.Dispatchers
import org.jetbrains.skia.Rect
import org.jetbrains.skiko.SkikoTouchEvent
import org.jetbrains.skiko.SkikoTouchEventKind.CANCELLED
import org.jetbrains.skiko.SkikoTouchEventKind.ENDED
import org.jetbrains.skiko.SkikoTouchEventKind.MOVED
import org.jetbrains.skiko.SkikoTouchEventKind.STARTED
import platform.CoreGraphics.CGPointMake
import platform.CoreGraphics.CGRect
import platform.CoreGraphics.CGRectMake
import platform.Foundation.NSData
import platform.UIKit.UIEvent
import platform.UIKit.UIScreen
import platform.UIKit.UITouch
import platform.darwin.dispatch_async


internal val TMMViewContentScaleFactor by lazy {
    TMMUIView.contentScale().toFloat()
}

/**
 * use CADisplayLink to process
 */
class SkiaDrawView : TMMUIView {
    @OverrideInit
    constructor(frame: CValue<CGRect>) : super(frame)

    private var isDisposed = false

    private val scene = ComposeScene(
        coroutineContext = Dispatchers.Main,
        invalidate = ::drawIfNeed
    ).apply {
        constraints = Constraints(maxWidth = 0, maxHeight = 0)
    }

    private val drawer = SkiaDrawer(this, scene)

    internal var renderRect : Rect = Rect.makeWH(0.0f, 0.0f)

    init {
        setHooksForLayoutSubviews {
            val viewWidth = width()
            val viewHeight = height()
            dispatch_async(renderQueue()) {
                renderRect = Rect.makeWH((viewWidth * TMMViewContentScaleFactor).toFloat(), (viewHeight * TMMViewContentScaleFactor).toFloat())
            }

            scene.constraints = Constraints(
                maxWidth = viewWidth.toInt(),
                maxHeight = viewHeight.toInt()
            )
            drawer.requestRedraw()
        }
    }

    internal fun setContent(content: @Composable () -> Unit) = scene.setContent(content)

    override fun dispose() {
        super.dispose()
        if (!isDisposed) {
            scene.close()
            drawer.dispose()
            isDisposed = true
        }
    }

    private fun drawIfNeed() {
        drawer.requestRedraw()
    }

    override fun touchesBegan(touches: Set<*>, withEvent: UIEvent?) {
        super.touchesBegan(touches, withEvent)
        val events: MutableList<SkikoTouchEvent> = mutableListOf()
        for (touch in touches) {
            val event = touch as UITouch
            val (x, y) = event.locationInView(null).useContents { x to y }
            val timestamp = (event.timestamp * 1_000).toLong()
            events.add(
                SkikoTouchEvent(x, y, STARTED, timestamp, event)
            )
        }
        onTouchEvent(events.toTypedArray())
    }

    override fun touchesEnded(touches: Set<*>, withEvent: UIEvent?) {
        super.touchesEnded(touches, withEvent)
        val events: MutableList<SkikoTouchEvent> = mutableListOf()
        for (touch in touches) {
            val event = touch as UITouch
            val (x, y) = event.locationInView(null).useContents { x to y }
            val timestamp = (event.timestamp * 1_000).toLong()
            events.add(
                SkikoTouchEvent(x, y, ENDED, timestamp, event)
            )
        }
        onTouchEvent(events.toTypedArray())
    }

    override fun touchesMoved(touches: Set<*>, withEvent: UIEvent?) {
        super.touchesMoved(touches, withEvent)
        val events: MutableList<SkikoTouchEvent> = mutableListOf()
        for (touch in touches) {
            val event = touch as UITouch
            val (x, y) = event.locationInView(null).useContents { x to y }
            val timestamp = (event.timestamp * 1_000).toLong()
            events.add(
                SkikoTouchEvent(x, y, MOVED, timestamp, event)
            )
        }
        onTouchEvent(events.toTypedArray())
    }

    override fun touchesCancelled(touches: Set<*>, withEvent: UIEvent?) {
        super.touchesCancelled(touches, withEvent)
        val events: MutableList<SkikoTouchEvent> = mutableListOf()
        for (touch in touches) {
            val event = touch as UITouch
            val (x, y) = event.locationInView(null).useContents { x to y }
            val timestamp = (event.timestamp * 1_000).toLong()
            events.add(
                SkikoTouchEvent(x, y, CANCELLED, timestamp, event)
            )
        }
        onTouchEvent(events.toTypedArray())
    }

    private fun onTouchEvent(events: Array<SkikoTouchEvent>) {
        val event = events.first()
        when (event.kind) {
            STARTED,
            MOVED,
            ENDED -> {
                scene.sendPointerEvent(
                    eventType = event.kind.toCompose(),
                    // TODO: account for the proper density.
                    position = Offset(
                        event.x.toFloat(),
                        event.y.toFloat()
                    ) - getTopLeftOffset(), // * density,
                    type = PointerType.Touch,
                    nativeEvent = event
                )
            }
            else -> {}
        }
    }

    private fun getTopLeftOffset(): Offset {
        val topLeftPoint =
            coordinateSpace().convertPoint(
                point = CGPointMake(0.0, 0.0),
                toCoordinateSpace = UIScreen.mainScreen.coordinateSpace()
            )
        return topLeftPoint.useContents { Offset(x.toFloat(), y.toFloat()) }
    }

    companion object {
        internal fun create(content: @Composable () -> Unit) =
            SkiaDrawView(CGRectMake(0.0, 0.0, 0.0, 0.0)).apply {
                setContent(content)
            }
    }
}
