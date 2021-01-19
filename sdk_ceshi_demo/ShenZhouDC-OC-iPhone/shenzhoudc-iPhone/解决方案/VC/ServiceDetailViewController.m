//
//  ServiceDetailViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "TechnicallyLiterateInfoViewController.h"
#import "ParticipateViewController.h"
#import "DealViewController.h"
#import "JoinInViewController.h"
#import "WXLoginShare.h"
#import "HXEasyCustomShareView.h"///分享
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "AppDelegate.h"
#import <WebKit/WebKit.h>


@interface ServiceDetailViewController ()<TencentSessionDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)DealViewController *dealVC;
//@property(nonatomic,copy)NSString *orderSn;//订单号

@end

@implementation ServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"派工详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self loadInfomation];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 28, 28);
    [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addGuanjiaShareView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

}


/**
 *  分享界面
 */
- (void)addGuanjiaShareView {
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信好友"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"},
                          @{@"image":@"shareView_qq",
                            @"title":@"QQ"},
                          @{@"image":@"shareView_qzone",
                            @"title":@"QQ空间"},
//                          @{@"image":@"share_copyLink",
//                            @"title":@"复制链接"}
                          ];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    HXEasyCustomShareView *shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:shareAry firstCount:7];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.middleLineLabel.hidden = YES;
    [shareView.cancleButton addSubview:lineLabel1];
    shareView.cancleButton.frame = CGRectMake(shareView.cancleButton.frame.origin.x, shareView.cancleButton.frame.origin.y, shareView.cancleButton.frame.size.width, 54);
    shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [shareView setShareAry:shareAry delegate:self];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController.view addSubview:shareView];
}

// 发送图片文字链接
- (void)showMediaNewsWithScene:(int)scene {
    if ([TencentOAuth iphoneQQInstalled]) {
        NSLog(@"请移步App Store去下载腾讯QQ客户端");
    }else {
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104063046"
                                                    andDelegate:self];
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:@"www.baidu.com"]
                                    title:@"李易峰撞车了"
                                    description:@"李易峰的兰博基尼被撞了李易峰的兰博基尼被撞了李易峰的兰博基尼被撞了"
                                    previewImageURL:[NSURL URLWithString:@""]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        if (scene == 0) {
            NSLog(@"QQ好友列表分享 - %d",[QQApiInterface sendReq:req]);
        }else if (scene == 1){
            NSLog(@"QQ空间分享 - %d",[QQApiInterface SendReqToQZone:req]);
        }
    }
}


#pragma mark HXEasyCustomShareViewDelegate

- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    NSLog(@"当前点击:%@",title);
    if ([title isEqualToString:@"微信好友"]) {
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = @"神州方案云-派工";//分享标题
        urlMessage.description = @"派工";//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"logoyun"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5,H5_CONTENT,self.orderSn];//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
        
    }
    if ([title isEqualToString:@"朋友圈"]) {
        
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = @"神州方案云-派工";//分享标题
        urlMessage.description = @"派工";//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"logoyun"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl =  [NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5,H5_CONTENT,self.orderSn];//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];

        
        
    }
    if ([title isEqualToString:@"QQ"]) {
        [self showMediaNewsWithScene:0];
    }
    if ([title isEqualToString:@"QQ空间"]) {
         [self showMediaNewsWithScene:1];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    UIButton *participateBtn = [[UIButton alloc]init];
    participateBtn.backgroundColor = MainColor;
    participateBtn.layer.masksToBounds = YES;
    participateBtn.layer.cornerRadius = 4;
    [participateBtn setTitle:@"点击报名" forState:UIControlStateNormal];
    [participateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    participateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [participateBtn addTarget:self action:@selector(clickParticipateBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:participateBtn];
    [participateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(10);
//        make.top.mas_equalTo(line.mas_bottom).with.offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 40);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(participateBtn.mas_top).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 5));
    }];

    
    _webView = [[WKWebView alloc]init];
    _webView.backgroundColor = [UIColor clearColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5,H5_CONTENT,self.orderSn]]]];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).with.offset(NAV_TAB_BAR_HEIGHT+STATUSBARHEIGHT);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(line.mas_top);
    }];
    
}

- (void)loadInfomation {
    NSString *url = [NSString stringWithFormat:@"%@v1/details/%ld",DOMAIN_NAME,(long)self.id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功-- %@",responseObject);
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 1000) {
            self.orderSn = [responseObject objectForKey:@"data"][@"orderSn"];
            NSLog(@"%@",self.orderSn);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)clickParticipateBtn {
    
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录！" afterHidden:2];
        return;
    }
    UserBaseInfoModel *model = [UserBaseInfoModel sharedModel];
    if ([model.type intValue] == 1) {
        //当前用户身份是达人
        if ([self.userid isEqualToString:[NSString stringWithFormat:@"%@",model.id]]) {
            //如果发单人就是当前用户，不能报名接单
            [self showError:self.view message:@"这是自己的订单哦~" afterHidden:2];
            return;
        }
        JoinInViewController *vc = [[JoinInViewController alloc]init];
        vc.orderSn = self.orderSn;
        [self.navigationController pushViewController:vc animated:YES];
    }else  {
            //当前用户身份是访客
            //跳转到达人身份认证页面，认证为技术达人后才能报名接单
                       [self showError:self.view message:@"您目前没有权限报名,请认证后报名，谢谢！" afterHidden:3];
        }

}



@end
