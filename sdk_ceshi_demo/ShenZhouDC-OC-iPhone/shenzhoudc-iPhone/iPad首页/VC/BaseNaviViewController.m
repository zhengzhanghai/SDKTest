//
//  BaseNaviViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/1.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "SZHomeViewController.h"

@interface BaseNaviViewController ()

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    //方式二 判断是不是自己想要设置自动选择的视图,使用这种方式,需要设置的VC不需要重写这个方法
        if ([[self.viewControllers lastObject]isKindOfClass:[SZHomeViewController class]]) {
            return YES;
        }
    
        return false;
    //方式一 通过找到当前的VC,返回相应的设置
//    return [[self.viewControllers lastObject] shouldAutorotate];
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}



@end
