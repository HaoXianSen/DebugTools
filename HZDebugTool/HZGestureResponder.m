//
//  HZShakeResponder.m
//  HZDebugTool
//
//  Created by harry on 2019/1/18.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import "HZGestureResponder.h"

@implementation HZGestureResponder

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 3;
    [keyWindow addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    if (self.tap) {
        self.tap();
    }
}

@end
