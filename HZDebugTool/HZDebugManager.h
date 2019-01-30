//
//  HZDebugManager.h
//  HZDebugTool
//
//  Created by harry on 2019/1/16.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, HZDebugManagerPerformanceType) {
    HZDebugManagerPerformanceTypeFPS = 1 << 0, // 屏幕刷新率
    HZDebugManagerPerformanceTypeMemory = 1 << 1, // 内存
    HZDebugManagerPerformanceTypeCPU = 1 << 2, // CPU
};

@interface HZDebugManager : NSObject

/// 单利初始化
+ (instancetype)sharedManager;

/// 根据类型显示需要的测试性能
- (void)showPerformanceWithType:(HZDebugManagerPerformanceType)type;
/// 根据类型隐藏显示的测试性能
- (void)hidePerformanceWithType:(HZDebugManagerPerformanceType)type;

@end
