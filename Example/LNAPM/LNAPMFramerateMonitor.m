//
//  LNAPMFPSMonitor.m
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import "LNAPMFramerateMonitor.h"

@interface LNAPMFramerateMonitor ()

@property (nonatomic, assign) NSInteger expectFramesPerSecond;
@property (nonatomic, assign) CFTimeInterval expectFramesDurationPerSecond;

@property (nonatomic, strong) void (^framerateOutput)(NSInteger framerate);

@property (nonatomic, assign) NSInteger frameIndex;

/**
 Record frame time.
 its capacity is expectFramesPerSecond(60).
 */
@property (nonatomic, assign) CFTimeInterval *recentFramesTimes;
/**
 CADisplayLink is a class of representing a timer bound to the display vsync
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation LNAPMFramerateMonitor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frameIndex = 0;
        
        if (@available(iOS 10.3, *)) {
            _expectFramesPerSecond = [UIScreen mainScreen].maximumFramesPerSecond;
        }else {
            _expectFramesPerSecond = 60;
        }
        _framerate = _expectFramesPerSecond;
        
        self.expectFramesDurationPerSecond = 1.0/_expectFramesPerSecond;
        self.recentFramesTimes = malloc(sizeof(CFTimeInterval) * self.expectFramesPerSecond);
    }
    return self;
}

- (void)startOutput {
    [self startOutputFramerate:nil];
}

- (void)startOutputFramerate:(nullable void (^)(NSInteger framerate))framerate {
    self.framerateOutput = framerate;
    if (self.framerateOutput) {
        self.framerateOutput(self.expectFramesPerSecond);
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)dealloc {
    [self.displayLink invalidate];
}

#pragma mark - Action

- (void)displayLinkAction:(CADisplayLink *)displayLink {
    //record
    self.recentFramesTimes[self.frameIndex % self.expectFramesPerSecond] = displayLink.timestamp;
    if (self.frameIndex >= self.expectFramesPerSecond * 2) {
        self.frameIndex = self.expectFramesPerSecond;
    }
    self.frameIndex++;
    
    //get dropped frame count
    if (self.frameIndex >= self.expectFramesPerSecond) {
        NSInteger droppedFrameCount = 0;
        CFTimeInterval lastFrameTime = CACurrentMediaTime() - self.expectFramesDurationPerSecond;
        for (NSInteger i = 0; i < self.expectFramesPerSecond; i++) {
            if (lastFrameTime - self.recentFramesTimes[i] >= 1.0) {
                droppedFrameCount++;
            }
        }
        NSInteger framerate = self.expectFramesPerSecond - droppedFrameCount;
        if (framerate != self.framerate) {
            _framerate = framerate;
            if (self.framerateOutput) {
                self.framerateOutput(framerate);
            }
        }
    }
}

#pragma mark - Getters

- (NSInteger)maximumFramesPerSecond {
    return self.expectFramesPerSecond;
}


@end
