//
//  HZWeakProxy.h
//  HZDebugTool
//
//  Created by harry on 2019/1/29.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target; 
+ (instancetype)weakProxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
