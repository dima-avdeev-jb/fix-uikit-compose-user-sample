//
//  TMMCellPoster.h
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import "TMMBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMMCellPoster : TMMBaseViewModel

/// 标题
@property (nonatomic, copy) NSString *title;

/// 副标题
@property (nonatomic, copy) NSString *subtitle;

/// 海报的 url
@property (nonatomic, copy) NSString *posterURL;

/// 右下角标识
@property (nonatomic, copy) NSString *posterRightBottomText;

/// 左下角标识
@property (nonatomic, copy) NSString *posterLeftBottomText;

/// 右上角标识
@property (nonatomic, copy) NSString *posterRightTopText;

/// 左上角标识
@property (nonatomic, copy) NSString *posterLeftTopText;

/// 左上角角标
@property (nonatomic, copy) NSString *posterLeftTopIconURL;

/// 左下角角标
@property (nonatomic, copy) NSString *posterLeftBottomIconURL;

/// 右上角角标
@property (nonatomic, copy) NSString *posterRightTopIconURL;

/// 左上角角标
@property (nonatomic, copy) NSString *posterRightBottomIconURL;

@end

NS_ASSUME_NONNULL_END
