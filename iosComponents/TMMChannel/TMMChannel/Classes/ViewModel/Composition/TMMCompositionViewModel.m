//
//  TMMCompositionViewModel.m
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/11.
//

#import "TMMCompositionViewModel.h"

typedef NSDictionary<NSString *, NSString *> TMMJSONData;

@implementation TMMCompositionItem

@end

@interface TMMCompositionViewModel ()
@property (nonatomic, strong) NSNumber *heightCache;
@end

@implementation TMMCompositionViewModel

- (instancetype)initWithJSON:(NSDictionary <NSString *, id> *)json {
    if (self = [super initWithJSON:json]) {
        NSString *blockStyleType = json[@"blockStyleType"];
        if ([blockStyleType isEqualToString:@"composition"]) {
            NSDictionary *data = asDictionary(json[@"data"]);
            self.title = asString(data[@"title"]);
            self.subtitle = asString(data[@"subtitle"]);
            
            NSDictionary *overly = asDictionary(data[@"overly"]);
            [self initPropertiesWithJSON:overly];
        }
    }
    return self;
}

- (void)initPropertiesWithJSON:(NSDictionary <NSString *, TMMJSONData *> *)json {
    self.overlyTopleft = [self createCompositionItemWithData:json[@"overlyTopleft"]];
    self.overlyView1 = [self createCompositionItemWithData:json[@"overlyView1"]];
    self.overlyView2 = [self createCompositionItemWithData:json[@"overlyView2"]];
    self.overlyView3 = [self createCompositionItemWithData:json[@"overlyView3"]];
    self.overlyTopRight = [self createCompositionItemWithData:json[@"overlyTopRight"]];
    self.label = [self createCompositionItemWithData:json[@"label"]];
}

- (TMMCompositionItem *)createCompositionItemWithData:(NSDictionary *)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        TMMCompositionItem *item = [[TMMCompositionItem alloc] init];
        item.bgColor = asString(data[@"bgColor"]);
        item.radius = asString(data[@"radius"]);
        item.alpha = asString(data[@"alpha"]);
        item.shadowColor = asString(data[@"shadowColor"]);
        item.textColor = asString(data[@"textColor"]);
        item.text = asString(data[@"text"]);
        return item;
    }
    return nil;
}

- (CGFloat)heightForContext:(CGFloat)context {
    if (self.heightCache) {
        return [self.heightCache floatValue];
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.label.text];
    [attributedText addAttributes:@{
        NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f]
    } range:NSMakeRange(0, self.label.text.length)];
    CGFloat width = 276;
    CGFloat minHeight = 64.5;
    NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                               options:options
                                               context:nil].size;
    
    if (size.height < minHeight) {
        size.height = minHeight;
    }
    
    CGFloat diff = size.height - minHeight + 30.0f;
    self.heightCache = @(240.0f + diff);
    return [self.heightCache floatValue];
}

- (Class)cellClass {
    return NSClassFromString(@"TMMCompositionCell");
}

@end
