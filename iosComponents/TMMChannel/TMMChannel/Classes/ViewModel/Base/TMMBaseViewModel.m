//
//  TMMBaseViewModel.m
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import "TMMBaseViewModel.h"

NSDictionary *asDictionary(id param) {
    return [param isKindOfClass:NSDictionary.class] ? param : @{};
}

NSArray *asArray(id param) {
    return [param isKindOfClass:NSArray.class] ? param : @[];
}

NSString *asString(id param) {
    return [param isKindOfClass:NSString.class] ? param : @"";
}

@implementation TMMBaseViewModel

- (instancetype)initWithJSON:(NSDictionary <NSString *, id>*)json {
    if (self = [super init]) {
        [self initBasePropertiesWithJSON:json];
    }
    return self;
}

- (void)initBasePropertiesWithJSON:(NSDictionary <NSString *, id> *)json {
    self.reportInfo = asDictionary(json[@"report_infos"]);
    self.operations = asDictionary(json[@"operations"]);
    self.flipInfos = asDictionary(json[@"flip_infos"]);
    self.data = asDictionary(json[@"data"]);
    self.extraData = asDictionary(json[@"extraData"]);
    self.blockId = asString(json[@"id"]);
}

+ (Class)cellClass {
    return nil;
}

- (CGFloat)heightForContext:(CGFloat)context {
    return 0.0f;
}

@end
