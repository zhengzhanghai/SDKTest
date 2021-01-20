//
//  TestView.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2020/12/31.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

#import "TestView.h"
#import "AppDelegate.h"
#import <ZHTestSDK/ZHTestSDK.h>

@implementation TestView

+ (void)showToWindow {
    UIWindow *window = [AppDelegate shareAppDelegate].window;
    TestView *testView = [[TestView alloc] init];
    testView.frame = [UIScreen mainScreen].bounds;
    [window addSubview:testView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    ZHImageView *imageView = [[ZHImageView alloc] init];
    imageView.frame = CGRectMake(100, 100, 200, 200);
    imageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:imageView];
    [imageView setLocalImage];
}

@end
