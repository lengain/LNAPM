//
//  LNAPMCPUMonitor.m
//  LNAPM_Example
//
//  Created by lengain on 2019/2/12.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import "LNAPMCPUMonitor.h"
#import <mach/mach.h>
@implementation LNAPMCPUMonitor


/**
 mach_port_t unsigned int
 typedef mach_port_t        task_t;
 typedef mach_port_t        task_name_t;
 typedef mach_port_t        task_inspect_t;
 typedef mach_port_t        task_suspension_token_t;
 typedef mach_port_t        thread_t;
 typedef    mach_port_t        thread_act_t;
 typedef mach_port_t        thread_inspect_t;
 typedef mach_port_t        ipc_space_t;
 typedef mach_port_t        ipc_space_inspect_t;
 typedef mach_port_t        coalition_t;
 typedef mach_port_t        host_t;
 typedef mach_port_t        host_priv_t;
 typedef mach_port_t        host_security_t;
 typedef mach_port_t        processor_t;
 typedef mach_port_t        processor_set_t;
 typedef mach_port_t        processor_set_control_t;
 typedef mach_port_t        semaphore_t;
 typedef mach_port_t        lock_set_t;
 typedef mach_port_t        ledger_t;
 typedef mach_port_t        alarm_t;
 typedef mach_port_t        clock_serv_t;
 typedef mach_port_t        clock_ctrl_t;
 
 */
+ (CGFloat)CPUUsage {
    double usageRatio = 0;
    thread_act_array_t threadArray;
    mach_msg_type_number_t machMegNumber = 0;
    kern_return_t kernReturn = task_threads(mach_task_self(), &threadArray, &machMegNumber);
    if (kernReturn == KERN_SUCCESS) {
        for (int index = 0; index < machMegNumber; index ++) {
            thread_inspect_t threadInspect = threadArray[index];
            mach_msg_type_number_t threadMsgNumber;
            thread_info_data_t threadInfo;
            kern_return_t threadInfoReturn = thread_info(threadInspect, THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadMsgNumber);
            if (threadInfoReturn == KERN_SUCCESS) {
                thread_basic_info_t threadBasicInfo = (thread_basic_info_t)threadInfo;
                if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
                    usageRatio += threadBasicInfo->cpu_usage / (double)TH_USAGE_SCALE;
                }
            }
        }
        assert(vm_deallocate(mach_task_self(), (vm_address_t)threadArray, machMegNumber * sizeof(thread_t)) == KERN_SUCCESS);
    }
    
    return ((CGFloat)((NSInteger)((usageRatio * 100.f + 0.0005) * 1000)))/1000;
}

@end
