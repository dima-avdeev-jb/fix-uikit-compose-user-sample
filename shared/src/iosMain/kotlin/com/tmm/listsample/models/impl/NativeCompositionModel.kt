package com.tmm.listsample.models.impl

import cocoapods.TMMChannel.TMMCompositionItem
import cocoapods.TMMChannel.TMMCompositionViewModel
import com.tmm.listsample.models.ICompositionItem
import com.tmm.listsample.models.ICompositionModel

private value class NativeCompositionItem(private val nativeModel: TMMCompositionItem) :
    ICompositionItem {
    override val bgColor: String? get() = nativeModel.bgColor
    override val radius: String? get() = nativeModel.radius
    override val alpha: String? get() = nativeModel.alpha
    override val shadowColor: String? get() = nativeModel.shadowColor
    override val textColor: String? get() = nativeModel.textColor
    override val text: String? get() = nativeModel.text
}

internal value class NativeCompositionModel(private val nativeModel: TMMCompositionViewModel) :
    ICompositionModel {

    override val blockId: String get() = nativeModel.blockId
    override val title: String get() = nativeModel.title
    override val subtitle: String get() = nativeModel.title

    override val overlyTopLeft: ICompositionItem get() = NativeCompositionItem(nativeModel.overlyTopleft)
    override val overlyView1: ICompositionItem get() = NativeCompositionItem(nativeModel.overlyView1)
    override val overlyView2: ICompositionItem get() = NativeCompositionItem(nativeModel.overlyView2)
    override val overlyView3: ICompositionItem get() = NativeCompositionItem(nativeModel.overlyView3)
    override val overlyTopRight: ICompositionItem get() = NativeCompositionItem(nativeModel.overlyTopRight)
    override val label: ICompositionItem get() = NativeCompositionItem(nativeModel.label)

    override val reportInfo: Map<String, Any>? get() = nativeModel.reportInfo as? Map<String, Any>
    override val operations: Map<String, Any>? get() = nativeModel.operations as? Map<String, Any>
    override val flipInfos: Map<String, Any>? get() = nativeModel.flipInfos as? Map<String, Any>
    override val extraData: Map<String, Any>? get() = nativeModel.extraData as? Map<String, Any>
    override val data: Map<String, Any>? get() = nativeModel.data as? Map<String, Any>
}