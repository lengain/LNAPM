//
//  LNAPMRamMonitor.m
//  LNAPM_Example
//
//  Created by lengain on 2019/3/11.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import "LNAPMRAMMonitor.h"
#import <mach/mach.h>
@implementation LNAPMRAMMonitor

- (void)refreshRAMUsage {//获取手机RAM容量
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = sizeof(info) / sizeof(integer_t);
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count) == KERN_SUCCESS) {
        _used = (CGFloat)info.resident_size;
        _total = (CGFloat)[NSProcessInfo processInfo].physicalMemory;
    }
}


@end
