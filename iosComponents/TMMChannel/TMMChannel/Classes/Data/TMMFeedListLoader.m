//
//  TMMFeedListLoader.m
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import "TMMFeedListLoader.h"
#import "TMMCellPoster.h"
#import "TMMTitleCellViewModel.h"
#import "TMMLandScrollViewModel.h"
#import "TMMVideoViewModel.h"
#import "TMMCompositionViewModel.h"

@interface TMMTaskRunner : NSObject
@property (nonatomic, strong) dispatch_block_t task;
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation TMMTaskRunner
+ (instancetype)sharedInstance {
    static TMMTaskRunner *runner;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        runner = [[TMMTaskRunner alloc] init];
    });
    return runner;
}

- (void)start {
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(run)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    link.paused = YES;
    self.link = link;
}

- (void)dispatch:(dispatch_block_t)task {
    self.task = task;
    if (!self.link) {
        [self start];
    }
    self.link.paused = NO;
}

- (void)run {
    if (self.task) {
        self.task();
    }
}

- (void)pause {
    self.link.paused = YES;
}

@end

@implementation TMMFeedListLoaderContext
@end

@implementation TMMFeedListLoader

#pragma mark - public
+ (void)fetchDataWithContext:(TMMFeedListLoaderContext *)context
                      isMore:(BOOL)isMore
                     success:(TMMDataSuccess)success
                     failure:(TMMDataFailure)failure {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *resName = !isMore ? @"index.json" : @"nextpage.json";
        NSArray <TMMBaseViewModel *> *list = [self createViewModelsWithResName:resName context:context];
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ?: success(list);
        });
    });
}

+ (void)fetchNoImageDataWithContext:(TMMFeedListLoaderContext *)context
                             isMore:(BOOL)isMore
                            success:(TMMDataSuccess)success
                            failure:(TMMDataFailure)failure {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray <TMMBaseViewModel *> *list = [self createViewModelsWithResName:@"noimage.json" context:context];
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ?: success(list);
        });
    });
}

+ (void)fetchNoImageJSONWithContext:(TMMFeedListLoaderContext *)context
                             isMore:(BOOL)isMore
                            success:(TMMJSONSuccess)success
                            failure:(TMMDataFailure)failure {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *resName = @"noimage.json";
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *dataBundlePath = [bundle pathForResource:@"data.bundle" ofType:@""];
        NSString *dataJSONPath = [dataBundlePath stringByAppendingPathComponent:resName];
        NSData *data = [NSData dataWithContentsOfFile:dataJSONPath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:NULL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ?: success(json);
        });
    });
}

+ (NSArray <TMMBaseViewModel *> *)createViewModelsWithResName:(NSString *)resName context:(TMMFeedListLoaderContext *)context {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *dataBundlePath = [bundle pathForResource:@"data.bundle" ofType:@""];
    NSString *dataJSONPath = [dataBundlePath stringByAppendingPathComponent:resName];
    NSData *data = [NSData dataWithContentsOfFile:dataJSONPath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:NULL];
    NSArray <TMMBaseViewModel *> *list = [self createViewModelsWithResponse:json context:context];
    return list;
}

#pragma mark - 根据大 JSON 创建 VM
+ (NSArray <TMMBaseViewModel *> *)createViewModelsWithResponse:(NSDictionary *)response
                                                       context:(TMMFeedListLoaderContext *)context {
    NSMutableArray <TMMBaseViewModel *> *models = @[].mutableCopy;
    NSDictionary *modules = asDictionary(response[@"modules"]);
    NSArray <NSDictionary *> *sections = asArray(modules[@"sections"]);
    for (NSInteger i = 0;i < 50;i++) {
        for (NSDictionary *item in sections) {
            NSString *sectionLayoutType = asString(item[@"sectionLayoutType"]);
            if ([sectionLayoutType isEqualToString:@"title"]) {
                [self createTitleViewModelFromSection:item models:models];
            } else if ([sectionLayoutType isEqualToString:@"landscroll"]) {
                [self createLandScrollModelFromSection:item models:models];
            } else if ([sectionLayoutType isEqualToString:@"tile"]) {
                [self createAdaptiveTileModelFromSection:item context:context models:models];
            } else if ([sectionLayoutType isEqualToString:@"video"]) {
                [self createVideoViewModelFromSection:item models:models];
            } else if ([sectionLayoutType isEqualToString:@"composition"]) {
                [self createCompositionViewModelFromSection:item models:models];
            }
        }
    }
    return models;
}

/// 创建标题 VM
+ (void)createTitleViewModelFromSection:(NSDictionary *)section models:(NSMutableArray <TMMBaseViewModel *> *)models {
    NSArray *blocks = asArray(section[@"blocks"]);
    for (NSUInteger i = 0;i < blocks.count; i++) {
        TMMTitleCellViewModel *titleCellVM = [[TMMTitleCellViewModel alloc] initWithJSON:[blocks objectAtIndex:i]];
        [models addObject:titleCellVM];
    }
}

/// 创建横滑 VM
+ (void)createLandScrollModelFromSection:(NSDictionary *)section models:(NSMutableArray <TMMBaseViewModel *> *)models {
    NSArray *blocks = asArray(section[@"blocks"]);
    if (blocks.count) {
        TMMLandScrollViewModel *group = [[TMMLandScrollViewModel alloc] initWithJSON:section];
        group.cellType = TMMCellTypeLandScroll;
        for (NSUInteger i = 0;i < blocks.count; i++) {
            TMMCellPoster *poster = [[TMMCellPoster alloc] initWithJSON:blocks[i]];
            poster.cellClass = NSClassFromString(@"TMMLandScrollItemCell");
            [group addPoster:(id)poster];
        }
        [models addObject:group];
    }
}

/// 创建平铺 VM
+ (void)createAdaptiveTileModelFromSection:(NSDictionary *)section
                                   context:(TMMFeedListLoaderContext *)context
                                    models:(NSMutableArray <TMMBaseViewModel *> *)models {
    
}

+ (void)createPosterViewModelFromBlockVM:(NSDictionary *)blockVM
                                             cellClass:(Class)cellClass
                                                models:(NSMutableArray <TMMBaseViewModel *> *)models {
    TMMCellPoster *poster = [[TMMCellPoster alloc] initWithJSON:blockVM];
    poster.cellClass = cellClass;
    [models addObject:poster];
}

+ (void)createVideoViewModelFromSection:(NSDictionary *)section
                                 models:(NSMutableArray <TMMBaseViewModel *> *)models {
    NSArray *blocks = asArray(section[@"blocks"]);
    if (blocks.count) {
        for (NSDictionary *videoBlock in blocks) {
            TMMVideoViewModel *poster = [[TMMVideoViewModel alloc] initWithJSON:videoBlock];
            [models addObject:poster];
        }
    }
}

+ (void)createCompositionViewModelFromSection:(NSDictionary *)section
                                       models:(NSMutableArray <TMMBaseViewModel *> *)models {
    NSArray *blocks = asArray(section[@"blocks"]);
    if (blocks.count) {
        for (NSDictionary *videoBlock in blocks) {
            NSString *blockStyleType = asString(videoBlock[@"blockStyleType"]);
            if ([blockStyleType isEqualToString:@"composition"]) {
                TMMCompositionViewModel *poster = [[TMMCompositionViewModel alloc] initWithJSON:videoBlock];
                poster.cellType = TMMCellTypeComposition;
                [models addObject:poster];
            }
        }
    }
}

+ (TMMCompositionViewModel *)createBaseViewModel {
    return nil;
}

+ (void)dispatch:(dispatch_block_t)task {
    [[TMMTaskRunner sharedInstance] dispatch:task];
}

+ (void)pauseDispatch {
    [[TMMTaskRunner sharedInstance] pause];
}

@end
