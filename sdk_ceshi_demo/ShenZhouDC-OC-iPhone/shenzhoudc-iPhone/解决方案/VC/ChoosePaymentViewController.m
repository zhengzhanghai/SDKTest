//
//  ChoosePaymentViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ChoosePaymentViewController.h"
#import "PayResultViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXLoginShare.h"
#import "UserBaseInfoModel.h"

#define BTN_BASE_TAG 9485

@interface ChoosePaymentViewController ()
{
    NSString *orderID;//业务订单号
    UILabel *accountLabel;//账户余额
    UITextField *textField;
    BOOL _isGotoPay;
}
@end

@implementation ChoosePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.title = @"账户充值";
    [self initPaymentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(someMethod1:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)appEnterBackground {
    AppDelegateWindow.userInteractionEnabled = false;
}

//应用从后台进入前台
- (void)someMethod1:(NSNotification *)notification {
    if (!_isGotoPay) {
        return ;
    }
    _isGotoPay = false;
    [self showLoadingToView:self.view];
    //验证支付结果
    NSString *api = [NSString stringWithFormat:@"%@v1/payment/recharge/confirmrecharge",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rechargeNo"] = self.rechargeNo;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:api parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"后台支付成功成功");
        [self hiddenLoading];
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 1000) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccessfullyYet" object:nil];
            PayResultViewController *vc = [[PayResultViewController alloc]init];
            vc.payResult = PayResultTypeSuccess;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (code == 1001) {
            PayResultViewController *vc = [[PayResultViewController alloc]init];
            vc.payResult = PayResultTypeFailure;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            PayResultViewController *vc = [[PayResultViewController alloc]init];
            vc.payResult = PayResultTypeOther;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PayResultViewController *vc = [[PayResultViewController alloc]init];
        vc.payResult = PayResultTypeOther;
        [self.navigationController pushViewController:vc animated:YES];
        [self hiddenLoading];
    }];
    
    
    AppDelegateWindow.userInteractionEnabled = true;
}

//创建选择支付方式的view
- (void)initPaymentView {
    NSArray *titles = @[@"支付宝", @"微信支付"];
    NSArray *images = @[@"pay_ali_icon", @"pay_wechat_icon"];
    NSArray *arr = @[@"tixian_blue", @"tixian_green"];
    
    CGFloat btnWidth =  SCREEN_WIDTH-30;
    CGFloat btnHeight = IS_IPAD ? 55 : 50;
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.layer.cornerRadius = 2;
        btn.clipsToBounds = true;
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = BTN_BASE_TAG+i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(NAVBARHEIGHT+STATUSBARHEIGHT+15+i*(btnHeight+15));
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnHeight);
        }];
        
        UIImageView *leftIcon = [[UIImageView alloc] init];
        leftIcon.image = [UIImage imageNamed:arr[i]];
        [btn addSubview:leftIcon];
        [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(2);
        }];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:icon];
        icon.userInteractionEnabled = false;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(34);
            make.height.mas_equalTo(34);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [btn addSubview:label];
        label.userInteractionEnabled = false;
        label.text = titles[i];
        label.textColor = UIColorFromRGB(0x1e1e1e);
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        label.userInteractionEnabled = NO;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(12);
            make.centerY.mas_equalTo(0);
        }];
        
        UIImageView *enterIcon = [[UIImageView alloc] init];
        enterIcon.image = [UIImage imageNamed:@"pay_enter"];
        [btn addSubview:enterIcon];
        [enterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
    }
}
//支付宝--本地核验支付结果
- (void)checkAlipayResultString:(NSString *)status {
    
   
}

#pragma mark:  点击支付方式
- (void)clickBtn:(UIButton *)btn {
    _isGotoPay = true;
    if (btn.tag - BTN_BASE_TAG == 0) {  // 支付宝
        [self orderWithType:0];
    } else {  // 微信
        [self orderWithType:1];
    }
}

- (void)orderWithType:(int)type {
    [self showLoadingToView:self.view];
    UserBaseInfoModel *userInfoModel = [UserBaseInfoModel readFromLocal];
    NSString *api = [NSString stringWithFormat:@"%@v1/payment/recharge",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nickName"] = userInfoModel.nickName;
    params[@"accountId"] = userInfoModel.id;
    params[@"price"] = _price;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:api parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"通知服务器即将支付成功===%@",responseObject);
        int code = [[responseObject objectForKey:@"code"] intValue];
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        if (code == 1000) {
            _appId = [dic[@"appId"] stringValue];
            _rechargeNo = dic[@"rechargeNo"];
            if (type == 0) { // 支付宝
                [self alipayPayment];
            } else { // 微信
                [self wechatPayment];
            }
        } else {
            [self showError:self.view message:[dic objectForKey:@"message"] afterHidden:3];
            _isGotoPay = false;
        }
        [self hiddenLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isGotoPay = false;
        NSLog(@"请求失败%@",error);
        [self hiddenLoading];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)getOrderSignRequest {
    __weak ChoosePaymentViewController *weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@userPaycheck/getOrderNumber/1",DOMAIN_NAME];//,[UserModel sharedModel].userId
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        orderID = dic[@"orderSn"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 支付宝支付相关
- (void)alipayPayment {
    NSString *url = @"http://pay.eteclab.org/api/v1/charge/order";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 应用  新的参数
    params[@"appId"] = self.appId;
    //订单号 直接用订单号orderNo
    params[@"orderSn"] = self.rechargeNo;
    params[@"amount"] = self.price;
    // 支付渠道
    params[@"channel"] = @"alipay";  //支付宝支付
    //商品描述
    params[@"body"] = @"神州方案云平台支付";
    //商品描述
    params[@"subject"] = @"神州方案云平台支付";
    
    [self loadingAddCountToView:AppDelegateWindow];
    
    NSLog(@"所有的支付参数 --> %@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[UserModel sharedModel].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[UserModel sharedModel].userId forHTTPHeaderField:@"userId"];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self loadingSubtractCount];
        NSLog(@"%@",responseObject);
        NSString *message = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]];
        NSLog(@"%@",message);
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 1000) {
            NSDictionary *dic = responseObject[@"data"];
            NSString *orderString = dic[@"data"];
            [self aliPay:orderString];
        } else {
            _isGotoPay = false;
            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:3];
        }
        [self hiddenLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self loadingSubtractCount];
        _isGotoPay = false;
        [self showError:self.view message:@"请求失败" afterHidden:3];
        NSLog(@"----请求失败---------");
    }];
  
}

#pragma mark 调起支付宝进行支付,支付后刷新订单，根据订单判断支付结果
- (void)aliPay:(NSString *)orderString {
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AliScheme callback:^(NSDictionary *resultDic) {
        
        
        
    }];
}

#pragma mark - 微信支付相关
- (void)wechatPayment {
    [self showLoadingToView:App_Delegate.window.rootViewController.view];
    WXLoginShare *log = [WXLoginShare shareInstance];
    [log getRechargeNumberWithPrice:_price appId:_appId orderId:_rechargeNo callBack:^(NSInteger type, NSString *message) {
        [self hiddenLoading];
        if (type == 0) {
            _isGotoPay = false;
            [self showError:self.view message:message afterHidden:3];
        }
    }];
}

#pragma mark 调起微信进行支付,支付后刷新订单，根据订单判断支付结果
- (void)wxPay:(NSDictionary *)data {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = WXPartnerId;
    /** 预支付订单 */
    request.prepayId = data[@"prePayId"];
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = @"Sign=WXPay";
    /** 随机串，防重发 */
    request.nonceStr = data[@"nonceStr"];
    /** 时间戳，防重发 */
    NSString *timeStr = data[@"timeStamp"];
    NSNumber *timeNum = [[NSNumberFormatter alloc] numberFromString:timeStr];
    request.timeStamp = timeNum.unsignedIntegerValue;
    request.sign = data[@"paySign"];

    
    [WXApi sendReq:request];
}
@end
