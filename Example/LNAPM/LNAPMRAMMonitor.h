//
//  LNAPMRamMonitor.h
//  LNAPM_Example
//
//  Created by lengain on 2019/3/11.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNAPMRAMMonitor : NSObject

+ (CGFloat)totalRAM;
+ (CGFloat)usedMemory;

@end

NS_ASSUME_NONNULL_END
