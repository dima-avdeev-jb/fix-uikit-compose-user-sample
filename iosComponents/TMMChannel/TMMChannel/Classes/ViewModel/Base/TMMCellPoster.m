//
//  TMMCellPoster.m
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import "TMMCellPoster.h"

@implementation TMMCellPoster

- (instancetype)initWithJSON:(NSDictionary<NSString *,id> *)json {
    if (self = [super initWithJSON:json]) {
        NSDictionary *data = asDictionary(json[@"data"]);
        self.title = asString(data[@"title"]);
        self.subtitle = asString(data[@"subtitle"]);
        self.posterLeftBottomText = asString(data[@"bottomLeftText"]);
        self.posterURL = asString(data[@"posterURL"]);
        self.posterRightTopIconURL = asString(data[@"posterRightTopIconURL"]);
    }
    return self;
}

- (TMMCellType)cellType {
    return TMMCellTypePoster;
}

@end
