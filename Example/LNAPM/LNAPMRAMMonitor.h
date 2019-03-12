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

@property (nonatomic, assign, readonly) CGFloat used;
@property (nonatomic, assign, readonly) CGFloat total;

- (void)refreshRAMUsage;

@end

NS_ASSUME_NONNULL_END
