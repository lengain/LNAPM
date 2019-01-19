//
//  LNViewController.m
//  LNAPM
//
//  Created by lengain@qq.com on 01/18/2019.
//  Copyright (c) 2019 lengain@qq.com. All rights reserved.
//

#import "LNViewController.h"
#import "LNAPMMonitorLayer.h"
@interface LNViewController ()

@end

@implementation LNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    LNAPMMonitorLayer *monitorLayer = [[LNAPMMonitorLayer alloc] init];
    monitorLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    monitorLayer.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, 200, 100);
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:monitorLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
