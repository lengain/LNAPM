//
//  LNMonitorLayer.m
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import "LNAPMMonitorLayer.h"

@implementation LNAPMMonitorLayer

- (instancetype)init {
    if (self = [super init]) {
        
        [self addSublayer:self.framerateText];
        LNAPMFramerateMonitor *monitor = [[LNAPMFramerateMonitor alloc] init];
        __weak __typeof(self) weakSelf = self;
        [monitor startOutputFramerate:^(NSInteger framerate) {
            weakSelf.framerateText.string = [NSString stringWithFormat:@" FPS:%ld",(long)framerate];
        }];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    self.framerateText.frame = self.bounds;
}

- (CATextLayer *)framerateText {
    if (!_framerateText) {
        _framerateText = [CATextLayer layer];
        //set text attributes
        _framerateText.foregroundColor = [UIColor blackColor].CGColor;
        _framerateText.alignmentMode = kCAAlignmentJustified;
        _framerateText.wrapped = YES;
        _framerateText.contentsScale = [UIScreen mainScreen].scale;
        
        UIFont *font = [UIFont systemFontOfSize:15];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        _framerateText.font = fontRef;
        _framerateText.fontSize = font.pointSize;
        CGFontRelease(fontRef);
    }
    return _framerateText;
}

@end
