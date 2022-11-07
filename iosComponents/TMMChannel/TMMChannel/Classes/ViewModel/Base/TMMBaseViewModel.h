//
//  TMMBaseViewModel.h
//  TMMBenchmark
//
//  Created by chenxiongon 2022/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMMCellType) {
    TMMCellTypeUnknow = 0,
    TMMCellTypeLandScroll = 1,
    TMMCellTypeTile = 2,
    TMMCellTypeVideo = 3,
    TMMCellTypeComposition = 4,
    TMMCellTypeTitle = 5,
    TMMCellTypePoster = 6,
};

FOUNDATION_EXTERN NSDictionary *asDictionary(id param);

FOUNDATION_EXTERN NSArray *asArray(id param);

FOUNDATION_EXTERN NSString *asString(id param);

@interface TMMBaseViewModel : NSObject

/// cell 类型
@property (nonatomic, assign) TMMCellType cellType;

/// 该 blockVM 的 cellClass
@property (nonatomic, assign) Class cellClass;

/// 总的数据
@property (nonatomic, copy) NSDictionary <NSString *, id> *data;

/// 上报数据
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *reportInfo;

/// operations 跳转等操作
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *operations;

/// 翻牌信息
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *flipInfos;

/// 当前 block 的 id
@property (nonatomic, copy) NSString *blockId;

/// 其他数据
@property (nonatomic, copy) NSDictionary <NSString *, id> *extraData;

- (instancetype)initWithJSON:(NSDictionary <NSString *, id>*)json;

/// 返回该 cell 的高度
/// @param context 当前CollectionView 的宽度
- (CGFloat)heightForContext:(CGFloat)context;

@end

NS_ASSUME_NONNULL_END
