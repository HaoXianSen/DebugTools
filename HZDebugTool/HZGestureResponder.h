//
//  HZShakeResponder.h
//  HZDebugTool
//
//  Created by harry on 2019/1/18.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZGestureResponder : NSObject

/// 摇晃结束
@property (nonatomic, copy) void(^tap)(void);

@end
