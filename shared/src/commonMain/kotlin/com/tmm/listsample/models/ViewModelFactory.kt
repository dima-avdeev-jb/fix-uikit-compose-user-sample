package com.tmm.listsample.models

internal expect fun fetchCompositionModels(useJSON: Boolean, callback: (List<IBaseViewModel>) -> Unit)