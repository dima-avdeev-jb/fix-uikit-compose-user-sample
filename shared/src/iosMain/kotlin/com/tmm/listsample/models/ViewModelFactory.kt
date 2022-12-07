package com.tmm.listsample.models

import cocoapods.TMMChannel.*
import com.tmm.listsample.models.impl.JSONCompositionModel
import com.tmm.listsample.models.impl.NativeCompositionModel
import kotlinx.cinterop.CPointer
import kotlinx.cinterop.CValue
import kotlinx.cinterop.useContents
import platform.CoreGraphics.CGSizeMake
import platform.UIKit.UIScreen

private const val TMMFloatMax: platform.CoreGraphics.CGFloat = 10000.0

private fun List<TMMBaseViewModel>.asBaseViewModel() : List<IBaseViewModel> {
    val result = mutableListOf<ICompositionModel>()
    for (item in this) {
        if (item is TMMCompositionViewModel) {
            result.add(NativeCompositionModel(item))
        }
    }
    return result
}


private fun createModelsFromJSON(json: Map<*, *>?): List<IBaseViewModel> {
    if (json == null) {
        return listOf()
    }

    val result = mutableListOf<IBaseViewModel>()
    val sections = json["json"] as? List<Map<*, *>>;
    sections?.forEach { section ->
        val blocks = section["blocks"] as? List<Map<*, *>>;
        blocks?.forEach {
            val typedBlock = it as? Map<*, *>
            val model = createModelWithBlock(typedBlock as Map<String, Any>)
            if (model != null) {
                result.add(model)
            }
        }
    }
    return result
}

private fun createModelWithBlock(block: Map<String, *>?): IBaseViewModel? {
    if (block == null) {
        return null
    }

    val model = when (block["blockStyleType"] as? String) {
        "composition" -> JSONCompositionModel(block)
        else -> {
            null
        }
    }
    
    return model
}

internal actual fun fetchCompositionModels(useJSON: Boolean, callback: (List<IBaseViewModel>) -> Unit) {
    val context = TMMFeedListLoaderContext();
    val sizeWidth = UIScreen.mainScreen.bounds.useContents { size.width };
    val delegate = CGSizeMake(sizeWidth, TMMFloatMax)
    context.setCollectionViewSize(object : CValue<CGSize>() {
        override val align: Int get() = delegate.align
        override val size: Int get() = delegate.size
        override fun place(placement: CPointer<CGSize>): CPointer<CGSize> {
//            val result = delegate.place(object: CPointer<>)//todo
//            return result
            return placement
        }

    });

    if (useJSON) {
        TMMFeedListLoader.fetchNoImageJSONWithContext(context, isMore = false, success = {
            callback(createModelsFromJSON(it))
        }, failure = {
            callback(listOf())
        })
    } else {
        TMMFeedListLoader.fetchNoImageDataWithContext(context, isMore = false, success = {
            val result = (it as? List<TMMBaseViewModel>)?.asBaseViewModel()
            callback(result ?: emptyList())
        }, failure = {
            callback(listOf())
        })
    }
}