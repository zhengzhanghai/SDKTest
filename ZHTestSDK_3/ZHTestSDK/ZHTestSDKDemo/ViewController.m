//
//  ViewController.m
//  ZHTestSDKDemo
//
//  Created by 郑章海 on 2020/5/22.
//  Copyright © 2020 zzh. All rights reserved.
//

#import "ViewController.h"
#import <ZHTestSDK/ZHTestSDK.h>
@import SDWebImage;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHImageView *imageView = [[ZHImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    [self.view addSubview:imageView];
    [imageView setLocalImage];
}


@end
