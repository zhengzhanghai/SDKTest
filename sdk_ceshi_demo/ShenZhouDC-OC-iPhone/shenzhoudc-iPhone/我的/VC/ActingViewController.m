//
//  ActingViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ActingViewController.h"
#import "CommentViewController.h"
#import "CommentDispatcherViewController.h"
#import <WebKit/WebKit.h>

@interface ActingViewController ()
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation ActingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.title = @"服务实施详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self loadData];
}

- (void)makeUI {
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5,H5_CONTENT,self.orderSn]]]];//查看订单详情 + 接单人详细信息
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(self.view.mas_top).with.offset(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
        make.right.mas_equalTo(-10.f);
    }];
    

    UIButton *participateBtn = [[UIButton alloc]init];
    participateBtn.backgroundColor = MainColor;
    participateBtn.layer.masksToBounds = YES;
    participateBtn.layer.cornerRadius = 4;
    if (self.type == 0) {
        [participateBtn setTitle:@"验收" forState:UIControlStateNormal];
    }else if (self.type == 1) {
        [participateBtn setTitle:@"确认完工" forState:UIControlStateNormal];
    }
    
    [participateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    participateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [participateBtn addTarget:self action:@selector(clickParticipateBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:participateBtn];
    [participateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(_webView.mas_bottom).with.offset(15.f);
        make.right.mas_equalTo(-10.f);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(40.f);
    }];
    
}

- (void)loadData {
    //获取接单详情和实施人详情的url
    
    
}
- (void)clickParticipateBtn {
    if (self.type == 0) {
        //进入评价页面
        CommentViewController *vc = [[CommentViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if(self.type == 1) {
        CommentDispatcherViewController *vc = [[CommentDispatcherViewController alloc]init];
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
   }

@end
