//
//  ChanPinDetailsWEBController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinDetailsWEBController.h"

@interface ChanPinDetailsWEBController ()

@end

@implementation ChanPinDetailsWEBController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientChange:(NSNotification *)noti {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(0);
                self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            NSLog(@"left");
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
                self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            NSLog(@"right");
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
