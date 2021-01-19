//
//  NCNavigationController.m
//  NebulaCommunityAgent
//
//  Created by zzh on 2017/7/5.
//  Copyright © 2017年 nebula. All rights reserved.
//

#import "NCNavigationController.h"

@interface NCNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation NCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.enabled = false;
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == [navigationController.viewControllers firstObject]) {
        navigationController.interactivePopGestureRecognizer.enabled = false;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = true;
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//       shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
