//
//  TMMVideoViewModel.h
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/5.
//

#import "TMMBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMMVideoViewModel : TMMBaseViewModel

@property (nonatomic, copy) NSString *posterURL;
@property (nonatomic, copy) NSString *smallCoverURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descTitle;
@property (nonatomic, copy) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
