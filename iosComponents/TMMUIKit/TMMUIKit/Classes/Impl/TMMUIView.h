//
//  TMMUIView.h
//  TMMUIKit
//
//  Created by chenxiong on 2022/9/1.
//

#import <UIKit/UIKit.h>
#import "TMMDisplayLink.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMLayerDrawInfo;

typedef void(^TMMUIHooks)(id _Nullable object);
typedef UIView *_Nullable(^TMMTitTestHooks)(CGPoint point, UIEvent * _Nullable event);
typedef BOOL(^TMMPointInsideHooks)(CGPoint point, UIEvent * _Nullable event);

@interface TMMUIView : UIView

/// 全局唯一的渲染队列
+ (dispatch_queue_t)renderQueue;

/// 拉伸系数
+ (CGFloat)contentScale;

/// 视图的宽
- (CGFloat)width;

/// 视图的高
- (CGFloat)height;

/// 渲染层的 layer
- (CALayer *)drawableLayer;

/// 准备渲染工作
- (void)prepareForRender;

/// 设置 runloop 任务
/// @param task TMMDisplayTask
- (void)setRunLoopTask:(TMMDisplayTask)task;

/// 销毁绘制相关
- (void)dispose;

#pragma mark - hooks
/// 设置 WillMoveToSuperview 的 hook
/// @param hooks TMMUIHooks
- (void)setHooksForWillMoveToSuperview:(TMMUIHooks)hooks;

/// 设置 WillMoveToWindow 的 hook
/// @param hooks TMMUIHooks
- (void)setHooksForWillMoveToWindow:(TMMUIHooks)hooks;

/// 设置 LayoutSubviews 的 hook
/// @param hooks TMMUIHooks
- (void)setHooksForLayoutSubviews:(TMMUIHooks)hooks;

/// 设置 hitTest 的 hook
/// @param hooks TMMTitTestHooks
- (void)setHooksForHitTest:(TMMTitTestHooks)hooks;

/// 设置 pointInside 的 hook
/// @param hooks TMMTitTestHooks
- (void)setHooksForPointInside:(TMMPointInsideHooks)hooks;

@end

NS_ASSUME_NONNULL_END
