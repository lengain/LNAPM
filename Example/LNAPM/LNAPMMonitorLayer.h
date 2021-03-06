//
//  LNMonitorLayer.h
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LNAPM.h"
NS_ASSUME_NONNULL_BEGIN

@interface LNAPMMonitorLayer : CALayer <LNAPMManagerMonitorDelegate>

@property (nonatomic, strong) CATextLayer *textLayer;

@end

NS_ASSUME_NONNULL_END
