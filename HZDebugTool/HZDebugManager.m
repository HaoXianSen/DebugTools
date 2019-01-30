//
//  HZDebugManager.m
//  HZDebugTool
//
//  Created by harry on 2019/1/16.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import "HZDebugManager.h"
#import "HZDebugView.h"
#import "HZGestureResponder.h"
#import "HZDebugTool.h"

@interface HZDebugManager()

/// 调试视图
@property (nonatomic, strong) HZDebugView *debugView;

/// 摇一摇响应器
@property (nonatomic, strong) HZGestureResponder *tapGestureRes;

/// 显示调试类型
@property (nonatomic, assign) HZDebugManagerPerformanceType type;

/// debug 相关数据
@property (nonatomic, strong) HZDebugTool *debug;

@end

@implementation HZDebugManager
static HZDebugManager *_manager;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        _manager.type = HZDebugManagerPerformanceTypeFPS | HZDebugManagerPerformanceTypeCPU | HZDebugManagerPerformanceTypeMemory;
        _manager.tapGestureRes = [[HZGestureResponder alloc] init];
        __weak typeof(_manager) weakSelf = _manager;
        _manager.tapGestureRes.tap = ^{
            [weakSelf showPerformanceWithType:weakSelf.type];
        };
    });
    return _manager;
}

- (void)showPerformanceWithType:(HZDebugManagerPerformanceType)type {
    __weak typeof(self) weakSelf = self;
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    self.debugView.hidden = NO;
    [window bringSubviewToFront:self.debugView];
    [self.debug beginCaculateWithCaculateType:(CaculateType)type ChangeBlock:^(NSInteger fps, CGFloat memory, long cpu) {
        weakSelf.debugView.fps = fps;
        weakSelf.debugView.memory = memory;
        weakSelf.debugView.cpu = cpu;
    }];
}

- (void)hidePerformanceWithType:(HZDebugManagerPerformanceType)type {
    
}

- (void)hide {
    if (_debugView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.debugView.frame = CGRectMake(self.debugView.frame.size.width/2.0, self.debugView.frame.size.height/2.0, 0, 0);
        } completion:^(BOOL finished) {
            [self.debugView removeFromSuperview];
            self.debugView = nil;
            [self.debug stopCaculate];
        }];
    }
}

- (HZDebugView *)debugView {
    if (!_debugView) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        _debugView = [[HZDebugView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, window.bounds.size.width, 44)];
        _debugView.layer.zPosition = 10000;
        __weak typeof(self) weakSelf = self;
        _debugView.closeBlock = ^(UIButton *btn) {
            [weakSelf hide];
        };
        [window addSubview:_debugView];
    }
    return _debugView;
}

- (HZDebugTool *)debug {
    if (!_debug) {
        _debug = [[HZDebugTool alloc] init];
    }
    return _debug;
}

@end
