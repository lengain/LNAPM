//
//  LNAPMManager.h
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LNAPMMonitorOptions) {
    LNAPMMonitorOptionNone              = 0,
    LNAPMMonitorOptionFramerate         = 1 << 0,
    LNAPMMonitorOptionCPUUsage          = 1 << 1,
    LNAPMMonitorOptionMemoryUsage       = 1 << 2,
    LNAPMMonitorOptionAll               = 1 << 3,
};

typedef NSString* LNAPMMonitorKey;

FOUNDATION_EXTERN LNAPMMonitorKey const LNAPMMonitorFramerateKey;
FOUNDATION_EXTERN LNAPMMonitorKey const LNAPMMonitorCPUUsageKey;
FOUNDATION_EXTERN LNAPMMonitorKey const LNAPMMonitorMemoryUsageKey;
FOUNDATION_EXTERN LNAPMMonitorKey const LNAPMMonitorMemoryTotalUsageKey;

typedef void(^LNAPMMonitorOutputBlock)(NSDictionary <LNAPMMonitorKey,id>*output);

@class LNAPMManager;
@protocol LNAPMManagerMonitorDelegate <NSObject>

- (void)manager:(LNAPMManager *)manager monitorOutput:(NSDictionary <LNAPMMonitorKey,id>*)output;

@end

@interface LNAPMManager : NSObject

/**
 Monitor Options,Default is LNAPMMonitorOptionNone.
 please set the option manually.
 */
@property (nonatomic, assign) LNAPMMonitorOptions monitorOptions;

/**
 Time interval for reload monitor infomation.Default is 1 second.
 */
@property (nonatomic, assign) NSTimeInterval reloadTimeInterval;

@property (nonatomic, weak) id <LNAPMManagerMonitorDelegate> monitorDelegate;
@property (nonatomic, copy) LNAPMMonitorOutputBlock outputBlock;

+ (LNAPMManager *)manager;
+ (void)monitor;

- (void)startMonitor;
- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
