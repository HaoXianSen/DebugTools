//
//  HZDebugView.h
//  HZDebugTool
//
//  Created by harry on 2019/1/16.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kIsIPhoneX [UIApplication sharedApplication].statusBarFrame.size.height > 20
#define kNavigationHeight (kIsIPhoneX ? 88 : 64)

@interface HZDebugView : UIView

/// 关闭事件
@property (nonatomic, copy) void(^closeBlock)(UIButton *btn);
/// fps
@property (nonatomic, assign) CGFloat fps;
/// memery
@property (nonatomic, assign) CGFloat memory;
/// cpu
@property (nonatomic, assign) long cpu;

@end
