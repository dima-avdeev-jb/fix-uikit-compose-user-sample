//
//  TMMGroupViewModel.h
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import "TMMBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMCellPoster;

@interface TMMGroupViewModel : TMMBaseViewModel

/// 标题
@property (nonatomic, copy) NSString *title;

/// 副标题
@property (nonatomic, copy) NSString *subtitle;

/// 海报列表
@property (nonatomic, strong) NSMutableArray <TMMCellPoster *> *posterList;


- (void)addPoster:(TMMCellPoster *)poster;

@end

NS_ASSUME_NONNULL_END
