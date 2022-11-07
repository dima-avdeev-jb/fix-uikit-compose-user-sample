//
//  TMMUIView.m
//  TMMUIKit
//
//  Created by chenxiong on 2022/9/1.
//

#import "TMMUIView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

@interface TMMUIView ()
@property (nonatomic, strong) CAMetalLayer *renderLayer;
@property (nonatomic, strong) TMMDisplayLink *displayLink;

@property (nonatomic, strong) TMMUIHooks hooksForWillMoveToSuperview;
@property (nonatomic, strong) TMMUIHooks hooksForWillMoveToWindow;
@property (nonatomic, strong) TMMUIHooks hooksForLayoutSubviews;
@property (nonatomic, strong) TMMTitTestHooks hooksForHitTest;
@property (nonatomic, strong) TMMPointInsideHooks hooksForPointInside;
@end

@implementation TMMUIView

+ (dispatch_queue_t)renderQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.tmm.skia.renderqueue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    });
    return queue;
}

#pragma mark - public
- (void)prepareForRender {
    if (!self.displayLink) {
        self.displayLink = [[TMMDisplayLink alloc] init];
        [self.displayLink pause:YES];
    }
}

- (void)setRunLoopTask:(TMMDisplayTask)task {
    if (!task) {
        return;
    }
    
    TMMDisplayLink *displayLink = self.displayLink;
    if (!displayLink) {
        displayLink = [[TMMDisplayLink alloc] init];
        self.displayLink = displayLink;
    }
    
    [displayLink startTask:task];
}

- (CGFloat)width {
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)height {
    return CGRectGetHeight(self.bounds);
}

- (CALayer *)drawableLayer {
    return self.renderLayer;
}

- (void)dispose {
    [self.displayLink stop];
    [self.renderLayer removeFromSuperlayer];
    self.displayLink = nil;
    self.renderLayer = nil;
    
    _hooksForWillMoveToSuperview = nil;
    _hooksForWillMoveToWindow = nil;
    _hooksForLayoutSubviews = nil;
    _hooksForHitTest = nil;
    _hooksForPointInside = nil;
}

#pragma mark - super overwrite
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (_hooksForWillMoveToWindow) {
        _hooksForWillMoveToWindow(newWindow);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self.layer addSublayer:self.renderLayer];
    } else {
        [self.renderLayer removeFromSuperlayer];
    }
    
    if (_hooksForWillMoveToSuperview) {
        _hooksForWillMoveToSuperview(newSuperview);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CAMetalLayer *renderLayer = self.renderLayer;

    if (renderLayer) {
        CGFloat scale = [TMMUIView contentScale];
        CGSize size = self.bounds.size;
        renderLayer.frame = CGRectMake(0, 0, size.width, size.height);
        renderLayer.drawableSize = CGSizeMake(size.width * scale, size.height * scale);
    }
    
    if (_hooksForLayoutSubviews) {
        _hooksForLayoutSubviews(nil);
    }
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if (_hooksForHitTest) {
        return _hooksForHitTest(point, event);
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if (_hooksForPointInside) {
        return _hooksForPointInside(point, event);
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - public
- (void)setHooksForWillMoveToSuperview:(TMMUIHooks)hooks {
    _hooksForWillMoveToSuperview = hooks;
}

- (void)setHooksForWillMoveToWindow:(TMMUIHooks)hooks {
    _hooksForWillMoveToWindow = hooks;
}

- (void)setHooksForLayoutSubviews:(TMMUIHooks)hooks {
    _hooksForLayoutSubviews = hooks;
}

- (void)setHooksForHitTest:(TMMTitTestHooks)hooks {
    _hooksForHitTest = hooks;
}

- (void)setHooksForPointInside:(TMMPointInsideHooks)hooks {
    _hooksForPointInside = hooks;
}

+ (CGFloat)contentScale {
    static float scale = 0;
    if (scale == 0) {
        scale = [[UIScreen mainScreen] scale];
    }
    return scale;
}

#pragma mark - getter
- (CAMetalLayer *)renderLayer {
    if (_renderLayer) {
        return _renderLayer;
    }
    _renderLayer = [CAMetalLayer layer];
    _renderLayer.framebufferOnly = NO;
    _renderLayer.opaque = false;
    _renderLayer.contentsScale = [TMMUIView contentScale];
    _renderLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    return _renderLayer;
}

- (void)dealloc {
    if (self.displayLink) {
        [self.displayLink stop];
    }
}

@end

#pragma clang diagnostic pop
