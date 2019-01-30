//
//  HZDebugTool.m
//  HZDebugTool
//
//  Created by harry on 2019/1/22.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import "HZDebugTool.h"
#import <mach/mach.h>
#import <mach/task.h>
#import "HZWeakProxy.h"

@interface HZDebugTool()

/// CADisplayer
@property (nonatomic, strong) CADisplayLink *displayLink;
/// 计数
@property (nonatomic, assign) NSInteger count;
/// 计时
@property (nonatomic, assign) NSTimeInterval time;
/// fps
@property (nonatomic, assign) NSInteger fps;
/// cpu
@property (nonatomic, assign) long cpu;
/// memory
@property (nonatomic, assign) CGFloat memory;

@property (nonatomic, assign) CaculateType caculateType;
@end

@implementation HZDebugTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        HZWeakProxy *proxy = [HZWeakProxy weakProxyWithTarget:self];
        _displayLink = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(refresh:)];
        _time = 0;
        _caculateType = CaculateTypeFps | CaculateTypeCpu | CaculateTypeMemory;
    }
    return self;
}

- (void)beginCaculateWithCaculateType:(CaculateType)type ChangeBlock:(void (^)(NSInteger, CGFloat, long))changeBlock {
    self.changeBlock = changeBlock;
    self.caculateType = type;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _time = 0;
    _count = 0;
}

- (void)stopCaculate {
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)refresh:(CADisplayLink *)link {
    NSTimeInterval lastFrameTime = link.timestamp;
    self.count += 1;
    if (self.time == 0) {
        _time = lastFrameTime;
        return;
    }
    
    NSTimeInterval duration = lastFrameTime - self.time;
    if (duration < 1) {
        return;
    }
    
    
    if (self.caculateType & CaculateTypeFps) {
        self.fps = (NSInteger)round(self.count / duration);
    }
    if (self.caculateType & CaculateTypeCpu) {
        self.cpu = [self getCpuUsage];
    }
    if (self.caculateType & CaculateTypeMemory) {
        self.memory = [self getUsedMemory];
    }
    if (self.changeBlock) {
        self.changeBlock(self.fps, self.memory, self.cpu);
    }
    _time = link.timestamp;
    _count = 0;
}

- (CGFloat)getUsedMemory {
    struct mach_task_basic_info info;
    mach_msg_type_number_t info_count = MACH_TASK_BASIC_INFO_COUNT;
    kern_return_t kern_return = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &info_count);
    if (kern_return != KERN_SUCCESS) {
        return NSNotFound;
    }
    CGFloat value = (CGFloat)(info.resident_size/1024.0/1024.0);
    return value;
}

- (long)getCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    task_basic_info_t basic_info;
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0;
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    if (thread_count > 0) {
        stat_thread += thread_count;
    }
    long tot_sec = 0;
    long tot_usec = 0;
    long tot_cpu = 0;
    
    for (int j = 0; j < (int)thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec +basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
    }
    kr = vm_deallocate(mach_task_self(), (vm_address_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
}

- (void)dealloc {
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

@end
