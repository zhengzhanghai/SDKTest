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
#import "AppDelegate.h"
#import <WebKit/WebKit.h>


@interface ServiceDetailViewController ()
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
   
}

// 发送图片文字链接
- (void)showMediaNewsWithScene:(int)scene {
   
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
