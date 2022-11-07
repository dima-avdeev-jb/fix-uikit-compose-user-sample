//
//  TMMTitleCellViewModel.m
//  TMMBenchmark
//
//  Created by chenxiongon 2022/8/4.
//

#import "TMMTitleCellViewModel.h"

@implementation TMMTitleCellViewModel

- (instancetype)initWithJSON:(NSDictionary<NSString *,id> *)json {
    if (self = [super initWithJSON:json]) {
        NSDictionary *data = asDictionary(json[@"data"]);
        self.title = data[@"title"];
        self.subtitle = data[@"subtitle"];
    }
    return self;
}

- (TMMCellType)cellType {
    return TMMCellTypeTitle;
}

- (Class)cellClass {
    return NSClassFromString(@"TMMTitleCell");
}

- (CGFloat)heightForContext:(CGFloat)context {
    return 29.0f;
}

@end
