//
//  MyAudioViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyAudioViewController.h"
#import "ZXVideoPlayerController.h"
#import "ZXVideo.h"

@interface MyAudioViewController ()
@property (nonatomic, strong) ZXVideoPlayerController *videoController;

@end

@implementation MyAudioViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频播放";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self playVideo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playVideo
{
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
        
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
            
            strongSelf.videoController = nil;
        };
        
        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
            NSLog(@"切换为竖屏模式");
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
        };
        
        [self.videoController showInView:self.view];
    }
    
    self.videoController.video = self.video;
}

@end
