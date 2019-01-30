//
//  HZDebugTool.h
//  HZDebugTool
//
//  Created by harry on 2019/1/22.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CaculateType) {
    CaculateTypeFps = 1 << 0,
    CaculateTypeMemory = 1 << 1,
    CaculateTypeCpu = 1 << 2
};

@interface HZDebugTool : NSObject
/// fps改变回调
@property (nonatomic, copy) void(^changeBlock)(NSInteger fps, CGFloat memory, long cpu);
/// 按照类型开始统计
- (void)beginCaculateWithCaculateType:(CaculateType)type ChangeBlock:(void(^)(NSInteger fps, CGFloat memory, long cpu))changeBlock;
/// 停止统计全部
- (void)stopCaculate;
@end

NS_ASSUME_NONNULL_END
