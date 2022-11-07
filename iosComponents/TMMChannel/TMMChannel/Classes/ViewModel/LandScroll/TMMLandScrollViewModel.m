//
//  TMMLandScrollViewModel.m
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import "TMMLandScrollViewModel.h"

@implementation TMMLandScrollViewModel

- (CGFloat)heightForContext:(CGFloat)context {
    return 120.0f;
}

- (Class)cellClass {
    return NSClassFromString(@"TMMLandScrollCell");
}

@end
