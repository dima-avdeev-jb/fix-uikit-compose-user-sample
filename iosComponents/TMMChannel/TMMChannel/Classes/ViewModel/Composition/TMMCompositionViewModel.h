//
//  TMMCompositionViewModel.h
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/11.
//

#import "TMMBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMMCompositionItem : NSObject
@property (nonatomic, copy) NSString *bgColor;
@property (nonatomic, copy) NSString *radius;
@property (nonatomic, copy) NSString *alpha;
@property (nonatomic, copy) NSString *shadowColor;
@property (nonatomic, copy) NSString *textColor;
@property (nonatomic, copy) NSString *text;
@end

@interface TMMCompositionViewModel : TMMBaseViewModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) TMMCompositionItem *overlyTopleft;
@property (nonatomic, strong) TMMCompositionItem *overlyView1;
@property (nonatomic, strong) TMMCompositionItem *overlyView2;
@property (nonatomic, strong) TMMCompositionItem *overlyView3;
@property (nonatomic, strong) TMMCompositionItem *overlyTopRight;
@property (nonatomic, strong) TMMCompositionItem *label;

- (instancetype)initWithJSON:(NSDictionary <NSString *, id>*)json;
@end

NS_ASSUME_NONNULL_END
