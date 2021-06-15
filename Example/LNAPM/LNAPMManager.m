//
//  LNAPMManager.m
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import "LNAPMManager.h"
#import "LNAPMCPUMonitor.h"
#import "LNAPMRAMMonitor.h"
@interface LNAPMManagerTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer*timer;

@end

@implementation LNAPMManagerTimerTarget

- (void)fire:(NSTimer *)timer {
    if(self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0f];
#pragma clang diagnostic pop
    } else {
        [self.timer invalidate];
    }
}

@end

#import "LNAPMFramerateMonitor.h"

LNAPMMonitorKey const LNAPMMonitorFramerateKey = @"LNAPMMonitorFramerate";
LNAPMMonitorKey const LNAPMMonitorCPUUsageKey = @"LNAPMMonitorCPUUsage";
LNAPMMonitorKey const LNAPMMonitorMemoryUsageKey = @"LNAPMMonitorMemoryUsage";
LNAPMMonitorKey const LNAPMMonitorMemoryTotalUsageKey = @"LNAPMMonitorMemoryTotalUsageKey";

@interface LNAPMManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableDictionary *monitorDictionary;
@property (nonatomic, strong) LNAPMFramerateMonitor *framerateMonitor;
@property (nonatomic, assign) BOOL monitoring;

@property (nonatomic, strong) dispatch_queue_t monitorQueue;

@end

@implementation LNAPMManager

+ (LNAPMManager *)manager {
    static LNAPMManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LNAPMManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self) {
        _monitorOptions = LNAPMMonitorOptionNone;
        _reloadTimeInterval = 1;
        self.monitorQueue = dispatch_queue_create("com.lengain.lnapm.monitor", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)startMonitor {
    NSAssert(self.monitorOptions != LNAPMMonitorOptionNone, @"LNAPM:Please set the option manually before monitor");
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    self.monitoring = YES;
    
    if (self.monitorOptions & LNAPMMonitorOptionFramerate || self.monitorOptions & LNAPMMonitorOptionAll) {
        [self.framerateMonitor startOutput];
    }
    if (self.monitorOptions & LNAPMMonitorOptionCPUUsage || self.monitorOptions & LNAPMMonitorOptionAll) {
        
    }
    if (self.monitorOptions & LNAPMMonitorOptionMemoryUsage || self.monitorOptions & LNAPMMonitorOptionAll) {
        
    }
    
    dispatch_async(self.monitorQueue, ^{
        LNAPMManagerTimerTarget *timerTarget = [[LNAPMManagerTimerTarget alloc] init];
        timerTarget.target = self;
        timerTarget.selector = @selector(onTimer:);
        timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:self.reloadTimeInterval target:timerTarget selector:@selector(fire:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timerTarget.timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
        self.timer = timerTarget.timer;
    });
    
}

- (void)stopMonitor {
    [_timer invalidate];
    self.monitoring = NO;
}

+ (void)monitor {
    [[LNAPMManager manager] setMonitorOptions:LNAPMMonitorOptionAll];
    [[LNAPMManager manager] startMonitor];
}

#pragma mark - Action

- (void)onTimer:(NSTimer *)timer {
    NSMutableDictionary <LNAPMMonitorKey,id>*output = [NSMutableDictionary dictionary];
    
    if (self.monitorOptions & LNAPMMonitorOptionFramerate || self.monitorOptions & LNAPMMonitorOptionAll) {
        [output setObject:@(self.framerateMonitor.framerate) forKey:LNAPMMonitorFramerateKey];
    }
    if (self.monitorOptions & LNAPMMonitorOptionCPUUsage || self.monitorOptions & LNAPMMonitorOptionAll) {
        [output setObject:@([LNAPMCPUMonitor CPUUsage]) forKey:LNAPMMonitorCPUUsageKey];
    }
    if (self.monitorOptions & LNAPMMonitorOptionMemoryUsage || self.monitorOptions & LNAPMMonitorOptionAll) {
        [output setObject:@([LNAPMRAMMonitor usedMemory]) forKey:LNAPMMonitorMemoryUsageKey];
        [output setObject:@([LNAPMRAMMonitor totalRAM]) forKey:LNAPMMonitorMemoryTotalUsageKey];
    }
    
    if (self.monitorDelegate && [self.monitorDelegate respondsToSelector:@selector(manager:monitorOutput:)]) {
        [self.monitorDelegate manager:self monitorOutput:output];
    }
    if (self.outputBlock) {
        self.outputBlock(output);
    }
}

#pragma mark - Getters

- (void)setMonitorOptions:(LNAPMMonitorOptions)monitorOptions {
    _monitorOptions = monitorOptions;
}

- (void)setReloadTimeInterval:(NSTimeInterval)reloadTimeInterval {
    _reloadTimeInterval = reloadTimeInterval;
    if (_timer != nil) {
        [self startMonitor];
    }
}

- (LNAPMFramerateMonitor *)framerateMonitor {
    if (!_framerateMonitor) {
        _framerateMonitor = [[LNAPMFramerateMonitor alloc] init];
    }
    return _framerateMonitor;
}

@end
