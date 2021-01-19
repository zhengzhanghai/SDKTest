//
//  RecieveTaskViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "RecieveTaskViewController.h"
#import "NSString+CustomString.h"
#import "ChoosePaymentViewController.h"
#import "MyServiceViewController.h"
#import <WebKit/WebKit.h>

@interface RecieveTaskViewController ()
{
    UIView *paymentView;
    UIView *mentionView;
}
@property(nonatomic,strong)WKWebView *webView;

@end

@implementation RecieveTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"派单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-70) configuration:[WKWebViewConfiguration new]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5,H5_CONTENT,self.orderSn]]]];
   
    [self.view addSubview:_webView];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_webView.frame)+15, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.view addSubview:line];
    
    UIButton *recieveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame)+10, SCREEN_WIDTH-20, 40)];
    recieveBtn.backgroundColor = MainColor;
    recieveBtn.layer.masksToBounds = YES;
    recieveBtn.layer.cornerRadius = 4;
    [recieveBtn setTitle:@"接单" forState:UIControlStateNormal];
    [recieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recieveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [recieveBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recieveBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//确认接单
- (void)clickBtn {
    //先确认账户余额是否充足
//    [self makePopView];
    
    [self makeSureToGet];
    
}

//提示用户接单需要支付押金
- (void)makePopView {
    
    mentionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mentionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:mentionView];
    
    NSString *info = @"如果确认接单，您需要支付该派单价格10%的押金~";
    CGFloat height = [info getHeightWithContent:info width:SCREEN_WIDTH-60 font:13];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 4;
    [mentionView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(mentionView.mas_centerX);
        make.centerY.mas_equalTo(mentionView.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-60);
        make.height.mas_greaterThanOrEqualTo( LandscapeNumber(140)+height);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"确认接单";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(whiteView.mas_top).with.offset(20);
        make.height.mas_equalTo(24);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(whiteView.mas_left);
        make.right.mas_equalTo(whiteView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeViewBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView.mas_right);
        make.top.mas_equalTo(whiteView.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = info;
    detailLabel.textColor = UIColorFromRGB(0x666666);
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(20);
        make.right.mas_equalTo(whiteView.mas_right).with.offset(-10);
    }];
    
    UIButton *cancleBtn = [[UIButton alloc]init];
    cancleBtn.backgroundColor = MainColor;
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.cornerRadius = 4;
    [cancleBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleBtn addTarget:self action:@selector(clickKnowBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.equalTo(detailLabel.mas_bottom).with.offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-90);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(40.f);
    }];

    
}
- (void) closeViewBtn {
    [mentionView removeFromSuperview];

}
//用户对于需要交押金事宜表示认可，继续进行
- (void) clickKnowBtn {
    //检查账户余额是否充足
     [mentionView removeFromSuperview];
    [self paymentRequest];
   
}

//接单人检查账户余额是否充足
- (void)checkMoneyIsEnough {
    
    NSString *api = [NSString stringWithFormat:@"%@v1/details/getConnectMoney?orderSn=%@&connectid=%@",DOMAIN_NAME,self.orderSn,[UserBaseInfoModel sharedModel].id];
    NSLog(@"--->>>> %@",api);
    [[AFHTTPSessionManager manager]GET:api parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功，正在返回... %@",responseObject);
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 1000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
            [self makeSureToPaymentViewWithInfo:@"账户余额充足，确认后押金将会从您账户扣取，是否继续？" AndTitle:@"提示" AndTag:333];
            
        }else if (code == 1002) {
            //钱不够，调用第三方支付充值到平台
            [self makeSureToPaymentViewWithInfo:@"平台账户余额不足，请进入支付页面进行充值。" AndTitle:@"提示" AndTag:222];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求不成功");
        [self showError:self.view message:@"支付失败,请稍后重试" afterHidden:2];
    }];
    
    
}
//确定付款页面
- (void)makeSureToPaymentViewWithInfo:(NSString *)text  AndTitle:(NSString *)title AndTag:(NSInteger)tag {
    paymentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    paymentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:paymentView];
    
    NSString *info = text;
    CGFloat height = [info getHeightWithContent:info width:SCREEN_WIDTH-60 font:13];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 4;
    [paymentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(paymentView.mas_centerX);
        make.centerY.mas_equalTo(paymentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, LandscapeNumber(195)+height));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(whiteView.mas_top).with.offset(20);
        make.height.mas_equalTo(24);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(whiteView.mas_left);
        make.right.mas_equalTo(whiteView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePayView) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView.mas_right);
        make.top.mas_equalTo(whiteView.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = info;
    detailLabel.textColor = UIColorFromRGB(0x666666);
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(20);
        make.right.mas_equalTo(whiteView.mas_right).with.offset(-10);
    }];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(whiteView.mas_left);
        make.right.mas_equalTo(whiteView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    cancelBtn.backgroundColor = MainColor;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 4;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.equalTo(line.mas_bottom).with.offset(15.f);
        make.right.mas_equalTo(whiteView.mas_centerX).with.offset(-10);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(40.f);
    }];
    
    
    
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.backgroundColor = MainColor;
    makeSureBtn.layer.masksToBounds = YES;
    makeSureBtn.layer.cornerRadius = 4;
    makeSureBtn.tag = tag;
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [makeSureBtn addTarget:self action:@selector(clickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:makeSureBtn];
    [makeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_centerX).with.offset(10);
        make.top.equalTo(line.mas_bottom).with.offset(15.f);
        make.right.mas_equalTo(whiteView.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(40.f);
    }];
    
}

- (void)clickCancelBtn {
    [paymentView removeFromSuperview];
}

//确定
- (void)clickPayBtn :(UIButton *)sender {
    
    [paymentView removeFromSuperview];
    
    if (sender.tag == 333) {
        //平台费用充足,调用平台的支付接口，支付完了调用确认接单接口
        [self paymentRequest];
        
    }else if (sender.tag == 222) {
//        [self showError:self.view message:@"账户余额不足，请到平台中心充值后再操作" afterHidden:2];
        //平台账户余额不足 ----  跳转充值中心
        ChoosePaymentViewController *vc = [[ChoosePaymentViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
//关闭支付页面
- (void)closePayView {
    [paymentView removeFromSuperview];
}

//接单人接单支付 --- 直接平台
- (void)paymentRequest {
    
    NSString *api = [NSString stringWithFormat:@"%@v1/payment/pay",DOMAIN_NAME];
    
    NSMutableDictionary *myparams = [NSMutableDictionary dictionary];
    myparams[@"orderSn"] = self.orderSn;
    myparams[@"accountId"] = [UserBaseInfoModel sharedModel].id;
    

    NSLog(@" --- %@,,,%@",myparams,api);
    [[AINetworkEngine sharedClient] postWithApi:api parameters:myparams CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
                [self.navigationController popViewControllerAnimated:YES];

                
            }else if ([result getCode] == 1002) {
            //钱不够，调用第三方支付充值到平台
            
                [self makeSureToPaymentViewWithInfo:@"平台账户余额不足，请进入支付页面进行充值。" AndTitle:@"提示" AndTag:222];
                    
            }
        } else {
            NSLog(@"请求失败%@",error);
        }
        
    }];
}

//确认接单 接口
- (void)makeSureToGet {
    
    AINetworkEngine *manager = [AINetworkEngine sharedClient];
//    [manager.requestSerializer setValue:[UserModel sharedModel].userId forHTTPHeaderField:@"connectid"];
    NSString *api = [NSString stringWithFormat:@"%@v1/details/getSure",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.orderSn;
    params[@"userid"] = self.userid;
    params[@"connectid"] = [UserModel sharedModel].userId;
    NSLog(@"参数------ 📚📚  %@%@",api,params);
    [manager postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"接单成功");
                [self showSuccess:self.view message:@"接单成功" afterHidden:2];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
                [self makePopView];
                
            }else{
                [self showError:self.view message:@"接单失败，请稍后重试" afterHidden:2];
            }
        } else {
            NSLog(@"请求失败");
             [self showError:self.view message:@"网络错误" afterHidden:2];
        }
        
    }];
    
}

@end
