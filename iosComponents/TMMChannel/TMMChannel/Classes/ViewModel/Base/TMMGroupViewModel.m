//
//  TMMGroupViewModel.m
//  TMMBenchmark
//
//  Created by chenxiong on 2022/8/4.
//

#import "TMMGroupViewModel.h"
#import "TMMCellPoster.h"

@implementation TMMGroupViewModel

- (void)addPoster:(TMMCellPoster *)poster {
    if ([poster isKindOfClass:[TMMCellPoster class]]) {
        if (!_posterList) {
            _posterList = @[].mutableCopy;
        }
        [_posterList addObject:poster];
    }
}

@end
