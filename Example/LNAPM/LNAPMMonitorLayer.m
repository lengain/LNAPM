//
//  LNMonitorLayer.m
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import "LNAPMMonitorLayer.h"
#import "LNAPMRAMMonitor.h"
@implementation LNAPMMonitorLayer

- (instancetype)init {
    if (self = [super init]) {
        [self addSublayer:self.textLayer];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    self.textLayer.frame = self.bounds;
}

#pragma mark - LNAPMManagerMonitorDelegate

- (void)manager:(LNAPMManager *)manager monitorOutput:(NSDictionary<LNAPMMonitorKey,id> *)output {
    NSMutableString *content = [[NSMutableString alloc] init];
    if (manager.monitorOptions & LNAPMMonitorOptionFramerate || manager.monitorOptions & LNAPMMonitorOptionAll) {
        [content appendFormat:@" FPS:%@\n",[output objectForKey:LNAPMMonitorFramerateKey]];
    }
    if (manager.monitorOptions & LNAPMMonitorOptionCPUUsage || manager.monitorOptions & LNAPMMonitorOptionAll) {
        [content appendFormat:@" CPU usage:%@%%\n",[output objectForKey:LNAPMMonitorCPUUsageKey]];
    }
    if (manager.monitorOptions & LNAPMMonitorOptionMemoryUsage || manager.monitorOptions & LNAPMMonitorOptionAll) {
        NSNumber *RAMUsage = [output objectForKey:LNAPMMonitorMemoryUsageKey];
        NSNumber *totalRAMUsage = [output objectForKey:LNAPMMonitorMemoryTotalUsageKey];
        [content appendFormat:@" RAM usage:%.1fMiB\n",[RAMUsage floatValue]/(1024 * 1024)];
        [content appendFormat:@" Total RAM:%.1fGiB\n",[totalRAMUsage floatValue]/(1024 * 1024 * 1024)];
    }
    NSLog(@"%@",output);
    self.textLayer.string = content;
}

#pragma mark - Getter

- (CATextLayer *)textLayer {
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        //set text attributes
        _textLayer.foregroundColor = [UIColor redColor].CGColor;
        _textLayer.alignmentMode = kCAAlignmentLeft;
        _textLayer.wrapped = YES;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        _textLayer.font = fontRef;
        _textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
    }
    return _textLayer;
}

@end
