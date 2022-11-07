//
//  TMMDisplayLink.m
//  TMMUIKit
//
//  Created by chenxiong on 2022/9/1.
//

#import "TMMDisplayLink.h"

@interface TMMDisplayLink ()
@property (nonatomic, strong) TMMDisplayTask task;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation TMMDisplayLink

- (void)startTask:(TMMDisplayTask)task {
    _task = task;
    if(_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(update:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSRunLoopCommonModes];
    }
}

- (void)update:(CADisplayLink *)sender {
    if (_task) {
        _task([sender timestamp]);
    }
}

- (void)stop {
    if (_displayLink != nil) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)pause:(BOOL)pause {
    _displayLink.paused = pause;
}

@end
