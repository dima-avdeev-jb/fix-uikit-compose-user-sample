//
//  TMMDisplayLink.h
//  TMMUIKit
//
//  Created by chenxiong on 2022/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TMMDisplayTask)(double timestamp);

@interface TMMDisplayLink : NSObject

/// 启动刷帧任务
/// @param task TMMDisplayTask
- (void)startTask:(TMMDisplayTask)task;

/// 完全停止刷帧
- (void)stop;

/// 暂停，还可以恢复
/// @param pause 是否暂停
- (void)pause:(BOOL)pause;

@end

NS_ASSUME_NONNULL_END
