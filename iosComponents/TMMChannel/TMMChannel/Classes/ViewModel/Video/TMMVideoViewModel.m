//
//  TMMVideoViewModel.m
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/5.
//

#import "TMMVideoViewModel.h"

@implementation TMMVideoViewModel

- (instancetype)initWithJSON:(NSDictionary<NSString *,id> *)json {
    if (self = [super initWithJSON:json]) {
        NSDictionary *videoData = asDictionary(json[@"data"]);
        [self initData:videoData];
    }
    return self;
}

- (void)initData:(NSDictionary *)videoData {
    self.title = videoData[@"title"];
    self.subtitle = videoData[@"subtitle"];
    self.descTitle = videoData[@"descTitle"];
    self.posterURL = videoData[@"posterURL"];
    self.smallCoverURL = videoData[@"smallCoverURL"];
}

- (TMMCellType)cellType {
    return TMMCellTypeVideo;
}

- (CGFloat)heightForContext:(CGFloat)context {
    return 298.0f;
}

- (Class)cellClass {
    return NSClassFromString(@"TMMVideoCell");
}

@end
