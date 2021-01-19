//
//  VideoPlayViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "ZFPlayer.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ZFDownloadManager.h"

@interface VideoPlayViewController ()<ZFPlayerDelegate>

@property (strong, nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
/** 是否是本地下载的视屏 */
@property (assign, nonatomic) BOOL isCacheVideo;
@end

@implementation VideoPlayViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        //        [self.playerView pause];
        self.playerView.playerPushedOrPresented = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = true;
    [self.view addSubview:self.playerFatherView];

    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        // 自动播放，默认不自动播放
        [self.playerView autoPlayTheVideo];
    } else {
        [self playerView];
    }
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = _titleTxt;
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = !self.isCacheVideo;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}

- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16)];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerFatherView;
}

- (BOOL)isCacheVideo {
    if (_isCacheVideo == false) {
        _isCacheVideo = [self.videoURL.scheme isEqualToString:@"file"];
    }
    return _isCacheVideo;
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}


#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerDownload:(NSString *)url {
    if (![UserModel isLogin]) {
        return;
    }
    [self loadingAddCountToView:self.view];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_downloadIcon] options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self loadingSubtractCount];
        if (error) {
            [self showError:self.view message:@"下载失败，请重试" afterHidden:2.0];
        } else {
            [ZF_MANAGER downFileUrl:_downloadUrlStr filename:_titleTxt fileimage:image];
        }
    }];
}


@end

