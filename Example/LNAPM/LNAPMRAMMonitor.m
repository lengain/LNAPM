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

+ (CGFloat)usedMemory {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo,&count);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return (CGFloat)vmInfo.phys_footprint;
}

+ (CGFloat)totalRAM {
    return (CGFloat)[NSProcessInfo processInfo].physicalMemory;
}


@end
