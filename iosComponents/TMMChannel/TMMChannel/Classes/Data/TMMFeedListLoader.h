//
//  TMMFeedListLoader.h
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import <UIKit/UIKit.h>
#import "TMMBaseViewModel.h"
#import "TMMCompositionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMBaseViewModel;

typedef void(^TMMDataSuccess)(NSArray <TMMBaseViewModel *> *viewModels);
typedef void(^TMMJSONSuccess)(NSDictionary *json);
typedef void(^TMMDataFailure)(NSError *error);

@interface TMMFeedListLoaderContext : NSObject
@property (nonatomic, assign) CGSize collectionViewSize;
@end

@interface TMMFeedListLoader : NSObject

+ (void)fetchDataWithContext:(TMMFeedListLoaderContext *)context
                      isMore:(BOOL)isMore
                     success:(TMMDataSuccess)success
                     failure:(TMMDataFailure)failure;

+ (void)fetchNoImageDataWithContext:(TMMFeedListLoaderContext *)context
                             isMore:(BOOL)isMore
                            success:(TMMDataSuccess)success
                            failure:(TMMDataFailure)failure;

+ (void)fetchNoImageJSONWithContext:(TMMFeedListLoaderContext *)context
                             isMore:(BOOL)isMore
                            success:(TMMJSONSuccess)success
                            failure:(TMMDataFailure)failure;

+ (TMMCompositionViewModel *)createBaseViewModel;

+ (void)dispatch:(dispatch_block_t)task;


+ (void)pauseDispatch;
@end

NS_ASSUME_NONNULL_END
