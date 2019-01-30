//
//  HZWeakProxy.m
//  HZDebugTool
//
//  Created by harry on 2019/1/29.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import "HZWeakProxy.h"

@implementation HZWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)weakProxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject methodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isProxy {
    return YES;
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (Class)class {
    return [_target class];
}

- (Class)superclass {
    return [_target superclass];
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}
@end
