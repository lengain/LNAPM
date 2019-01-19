//
//  LNAPMFPSMonitor.h
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNAPMFramerateMonitor : NSObject

@property (nonatomic, assign, readonly) NSInteger maximumFramesPerSecond;

/**
 frames per second
 */
@property (nonatomic, assign, readonly) NSInteger framerate;

- (void)startOutputFramerate:(void (^)(NSInteger framerate))framerate;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
