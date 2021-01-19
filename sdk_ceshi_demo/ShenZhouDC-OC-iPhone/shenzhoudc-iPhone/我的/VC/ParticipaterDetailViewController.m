//
//  ParticipaterDetailViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ParticipaterDetailViewController.h"
#import "NSString+CustomString.h"
#import "ChoosePaymentViewController.h"
#import "MyServiceViewController.h"
#import "ChargeViewController.h"
#import "IQKeyboardManager.h"
#import "WKWebView+HeaderFooter.h"

@interface ParticipaterDetailViewController ()<WKNavigationDelegate>
{
    UIButton *btn;//是否验收人为本人按钮
    UIView *paymentView;
    
    UIView *view;
}
//@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UITextField *name;
@property(nonatomic,strong)UITextField *cellNum;
@property(nonatomic,assign)NSInteger isSelf;//0非本人 1本人
@property(nonatomic, strong)UIButton *participateBtn;
@property(nonatomic, assign)BOOL isPay;


@end

@implementation ParticipaterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"报名人详情";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    self.isSelf = 0;
    self.isPay = false;
    
}

-(void)dealloc
{
    [self.webView removeObserverForWebViewContentSize];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [view removeFromSuperview];
}

-(void)makeWhiteView{
    
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.userInteractionEnabled = YES;
    
    
   
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(whiteView.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"填写验证人";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(line.mas_bottom).with.offset(13);
    }];
    
    btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"not_select"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickSelf:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(label.mas_bottom).with.offset(10.f);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UILabel *annotateLabel = [[UILabel alloc]init];
    annotateLabel.text = @"验收人是否是本人？";
    annotateLabel.textAlignment = NSTextAlignmentCenter;
    annotateLabel.textColor = [UIColor darkGrayColor];
    annotateLabel.font = [UIFont boldSystemFontOfSize:15];
    [whiteView addSubview:annotateLabel];
    [annotateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btn.mas_centerY);
        make.left.mas_equalTo(btn.mas_right).with.offset(10);
    }];
    
    UILabel *starLabel = [[UILabel alloc]init];
    starLabel.text = @"*";
    starLabel.textAlignment = NSTextAlignmentLeft;
    starLabel.textColor = MainColor;
    starLabel.font = [UIFont boldSystemFontOfSize:17];
    [whiteView addSubview:starLabel];
    [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_left);
        make.top.mas_equalTo(btn.mas_bottom).with.offset(13);
    }];
    
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.text = @"如验收人非本人，则必须填写验收人信息";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = UIColorFromRGB(0x999999);
    infoLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(starLabel.mas_right).with.offset(2);
        make.centerY.mas_equalTo(starLabel.mas_centerY);
    }];
    
    
    NSString *str = @"验证人姓名：";
    CGFloat width = [str getWidthWithContent:str height:18 font:15];
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = str;
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoLabel.mas_bottom).with.offset(25);
        make.left.mas_equalTo(10.f);
    }];
    
    _name = [[UITextField alloc]init];
   
    _name.textColor = [UIColor darkGrayColor];
    _name.font = [UIFont systemFontOfSize:16];
    _name.borderStyle = UITextBorderStyleRoundedRect;
    _name.clearButtonMode = UITextFieldViewModeAlways;
    [whiteView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label1.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-width-LandscapeNumber(40));
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"验收人电话：";
    label2.textColor = [UIColor darkGrayColor];
    label2.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_name.mas_bottom).with.offset(20);
        make.left.mas_equalTo(10.f);
    }];
    
    _cellNum = [[UITextField alloc]init];
   
    _cellNum.textColor = [UIColor darkGrayColor];
    _cellNum.font = [UIFont systemFontOfSize:16];
    _cellNum.keyboardType = UIKeyboardTypeNumberPad;
    _cellNum.borderStyle = UITextBorderStyleRoundedRect;
    _cellNum.clearButtonMode = UITextFieldViewModeAlways;
    [whiteView addSubview:_cellNum];
    [_cellNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label2.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-width-LandscapeNumber(40));
        make.height.mas_equalTo(40);
    }];
    
    
    
    self.participateBtn = [[UIButton alloc]init];
    self.participateBtn.backgroundColor = MainColor;
    self.participateBtn.layer.masksToBounds = YES;
    self.participateBtn.layer.cornerRadius = 4;
    if (_isPay) {
        
        [self.participateBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }else{
        
        [self.participateBtn setTitle:@"确定接单人" forState:UIControlStateNormal];
    }
    [self.participateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.participateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.participateBtn addTarget:self action:@selector(clickParticipateBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.participateBtn];
    [self.participateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_cellNum.mas_bottom).with.offset(20);
        make.left.mas_equalTo(10.f);
        //        make.centerY.mas_equalTo(label2.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(40);
        
    }];
    
    UIButton *getMobi = [[UIButton alloc]init];
    getMobi.backgroundColor = MainColor;
    getMobi.layer.masksToBounds = YES;
    getMobi.layer.cornerRadius = 4;
    [getMobi setTitle:@"获取联系方式" forState:UIControlStateNormal];
    [getMobi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getMobi.titleLabel.font = [UIFont systemFontOfSize:16];
    [getMobi addTarget:self action:@selector(getMobi) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:getMobi];
    [getMobi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(self.participateBtn.mas_bottom).with.offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(40.f);
    }];
    
    self.webView.footerView = whiteView;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeUI {
//    _scrollView = [[UIScrollView alloc]init];
//    [self.view addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0.f);
//        make.top.equalTo(self.view.mas_top).with.offset(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
//        make.right.mas_equalTo(0.f);
//        make.bottom.mas_equalTo(0.f);
//    }];
    
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:[WKWebViewConfiguration new]];
    _webView.navigationDelegate = self;
    NSString *url = [NSString stringWithFormat:@"%@%@?connectid=%@&orderSn=%@&type=getPersonDetails",DOMAIN_NAME_H5,H5_CONTENT,self.connectidID,self.orderSn];//展示报名人详细信息
    _webView.backgroundColor=  [UIColor whiteColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    NSLog(@"----------webViewUTRL --- %@",url);
    [self.view addSubview:_webView];
    
    
    view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    [_webView addSubview:view];
    
    [self makeWhiteView];
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0.f);
//        make.top.mas_equalTo(_scrollView.mas_top);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.height.mas_equalTo(SCREEN_WIDTH);
//    }];
    
    
}
#pragma -mark 获取联系方式
-(void)getMobi{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.orderSn;
    params[@"connectid"] = self.connectidID.description;
    
    
    NSString *api = [NSString stringWithFormat:@"%@v1/details/getConnectTelephone",DOMAIN_NAME];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"key = %@ and obj = %@", key, obj);
            NSString *value = [NSString stringWithFormat:@"%@",obj];
            [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }];
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        CGFloat  progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"赋值image:%@",[NSThread currentThread]);
//            [self showLoadingToView:self.view];
        });
        
        
        NSLog(@"ceshi   %f", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success = %@", responseObject);
        
        int code = [[responseObject objectForKey:@"code"] intValue];
        //上传成功
        if (code == 1000) {
//            [self showSuccess:self.view message:[responseObject objectForKey:@"message"] afterHidden:4];
            NSString *mobi = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
            NSString *msg = [NSString stringWithFormat:@"%@ \n%@",[responseObject objectForKey:@"data"],[responseObject objectForKey:@"message"]];
            NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            //    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //确定拨打电话
                
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobi];
                //            NSLog(@"str======%@",str);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
            
            
         
            
        }else{
            
            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:2];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failure %@", error.description);
    }];
    

    
    
    


}

- (void)clickSelf:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        self.isSelf = 0;
    }else {
        sender.selected = YES;
        self.isSelf = 1;
    }
}

- (void)clickParticipateBtn {
    if (self.isSelf == 0) {
        //非本人验收
        if (_name.text.length == 0 ) {
            [self showError:self.view message:@"验收人姓名不能为空" afterHidden:2];
            return;
        }else if (_cellNum.text.length == 0){
            [self showError:self.view message:@"验收人电话不能为空" afterHidden:2];
            return;
        }
    }
    
    if (_isPay) {
        //去支付
        [self paymentRequest];
    }else
    {
        [self loadFinalRequests];//选定接单人
        
    }
    
  
  
}
#pragma -mark 确定最终接单人
- (void)loadFinalRequests{
    
//    __weak typeof (self)selfVC = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.orderSn;
    if (self.isSelf == 1) {//是本人
        params[@"acceptorname"] =  [UserBaseInfoModel sharedModel].nickName;//验收人姓名
        params[@"acceptormobile"] = [UserBaseInfoModel sharedModel].mobile;//验收人手机
        params[@"checkedByself"] = @"1";//验收人姓名
    }else{//不是本人
        params[@"acceptorname"] = self.name.text;//验收人姓名
        params[@"acceptormobile"] = self.cellNum.text;//验收人手机
        params[@"checkedByself"] =@"0";//
    }
    
    
//    params[@"userid"] = [UserBaseInfoModel sharedModel].id;
    params[@"connectid"] = self.connectidID.description;
    
    NSLog(@"%@", params[@"acceptorname"]);
    
    NSString *api = [NSString stringWithFormat:@"%@v1/details/getOverPerson",DOMAIN_NAME];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:api parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int code = [[responseObject objectForKey:@"code"] intValue];
        //上传成功
        if (code == 1000) {
            //            [self showSuccess:self.view message:@"选定接单人成功" afterHidden:4];
            
            NSLog(@"选定接单人成功");
            _isPay = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
            [self showSuccess:self.view message:@"选定接单人成功" afterHidden:4];
            [self makeSureToPaymentViewWithInfo:@"接单人确认完工后，需验收人及时进行任务验收，否则预付款会在3个工作日后自动支付给接单人，请谨慎选择验收人！\n余额充足的情况直接扣款！" AndTitle:@"确认支付？" AndTag:111];
            [self reloadPay];
        } else {
             [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failure %@", error.description);
    }];
    
//    [manager POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            NSLog(@"key = %@ and obj = %@", key, obj);
//            NSString *value = [NSString stringWithFormat:@"%@",obj];
//            [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
//        }];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        CGFloat  progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"赋值image:%@",[NSThread currentThread]);
////            [self showLoadingToView:self.view];
//        });
//        
//        
//        NSLog(@"ceshi   %f", progress);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"Success = %@", responseObject);
//        
//        int code = [[responseObject objectForKey:@"code"] intValue];
//        //上传成功
//        if (code == 1000) {
////            [self showSuccess:self.view message:@"选定接单人成功" afterHidden:4];
//            
//            NSLog(@"选定接单人成功");
//            _isPay = true;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
//            [self showSuccess:self.view message:@"选定接单人成功" afterHidden:4];
//            [self makeSureToPaymentViewWithInfo:@"接单人确认完工后，需验收人及时进行任务验收，否则预付款会在3个工作日后自动支付给接单人，请谨慎选择验收人！\n余额充足的情况直接扣款！" AndTitle:@"确认支付？" AndTag:111];
//            [self reloadPay];
//            
//            
//        }else{
//            
//            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:2];
//            
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"Failure %@", error.description);
//    }];
    
}

-(void)reloadPay{
    if (_isPay) {
        [self.participateBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }else{
        [self.participateBtn setTitle:@"确定接单人" forState:UIControlStateNormal];
    }
    
    
}




//平台支付
- (void)paymentRequest {
    NSString *api = [NSString stringWithFormat:@"%@v1/payment/pay",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.orderSn;
    params[@"accountId"] = [UserBaseInfoModel sharedModel].id;
    
    
    
    NSLog(@" --- %@,,,%@",params,api);
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"支付成功");
                [self showSuccess:self.view message:@"预付款支付成功" afterHidden:4];
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
                UIViewController *getVC = nil;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    NSLog(@"%@",vc);
                if ([vc isKindOfClass:[MyServiceViewController class]]) {
                        getVC = vc;
                        break;
                    
                }
                
                }
                [self.navigationController popToViewController:getVC animated:YES];
                
            }else{
                if ([result getCode] == 1002) {//余额不足
                    //钱不够，调用第三方支付充值到平台
                    [self makeSureToPaymentViewWithInfo:@"平台账户余额不足，请进入支付页面进行充值。" AndTitle:@"提示" AndTag:222];
                    
                    
                    
                }else//错误
                {
                    [self showError:self.view message:[result getMessage] afterHidden:2];
                    
                }
                
            }
        } else {
            [self showError:self.view message:@"网络失败" afterHidden:2];

            NSLog(@"请求失败%@",error);
        }
        
    }];
}

//确定付款页面
- (void)makeSureToPaymentViewWithInfo:(NSString *)text  AndTitle:(NSString *)title AndTag:(NSInteger)tag {
    paymentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    paymentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:paymentView];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:paymentView];
//    [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"发单成功" afterHidden:4];
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
        //平台费用充足,调用平台的支付接口
        [self paymentRequest];
    }else if (sender.tag == 222) {
        
        //调用本地充值接口
        ChargeViewController *vc = [[ChargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag == 111) {
//        去支付
        [self paymentRequest];
    }


}
//关闭支付页面
- (void)closePayView {
    [paymentView removeFromSuperview];
}



@end
