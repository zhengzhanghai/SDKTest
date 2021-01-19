//
//  DealDetailViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//验收人为本人 进行中详情

#import "DealDetailViewController.h"
#import "ShensuViewController.h"
#import <WebKit/WebKit.h>

@interface DealDetailViewController ()
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation DealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    if (self.type == 1) {
         self.title = @"订单详情";
    }else if (self.type == 0) {
         self.title = @"订单详情";
    }
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45) configuration:[WKWebViewConfiguration new]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5, H5_CONTENT,self.orderSn]]]];//展示订单详情 + 最终接单人的详情
    [self.view addSubview:_webView];
    NSLog(@"---- WebUrl:%@", [NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5, H5_CONTENT,self.orderSn]);
    
    UIButton *shenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shenBtn.frame = CGRectMake(0, SCREEN_HEIGHT- 45, SCREEN_WIDTH, 45);
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, SCREEN_HEIGHT- 45, SCREEN_WIDTH, 45);

    if (_showBtn) {
        if (_canShensu) {
            UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"投诉" style:UIBarButtonItemStyleDone target:self action:@selector(shensuButton)];
            rightButtonItem.title = @"投诉";
            self.navigationItem.rightBarButtonItem = rightButtonItem;
        } else {
            [cancelBtn setBackgroundColor:MainColor];
            [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [cancelBtn addTarget:self action:@selector(cancleButton) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cancelBtn];
        }
        if (_isWork) {
            _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
            UIButton *sureWork = [UIButton buttonWithType:UIButtonTypeCustom];
            sureWork.frame = CGRectMake(0, SCREEN_HEIGHT- 100, SCREEN_WIDTH, 45);
            if (_canShensu) {
                sureWork.y = SCREEN_HEIGHT- 45;
                _webView.height = SCREEN_HEIGHT - 45;
            }
            [sureWork setBackgroundColor:MainColor];
            [sureWork setTitle:@"确认开工" forState:UIControlStateNormal];
            [sureWork setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sureWork.titleLabel.font = [UIFont systemFontOfSize:16];
            [sureWork addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:sureWork];
            
            cancelBtn.frame = CGRectMake(0, SCREEN_HEIGHT- 45, SCREEN_WIDTH, 45);
            shenBtn.frame = CGRectMake(0, SCREEN_HEIGHT- 45, SCREEN_WIDTH, 45);
        }
    } else {
        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}


-(void)sureButton{
    NSString *api = [NSString stringWithFormat:@"%@v1/details/getWorkStart",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"connectid"] = [UserModel sharedModel].userId;
    params[@"orderSn"] = self.orderSn;
    
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
                [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"开工成功" afterHidden:2];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [self showError:self.view message:[result getMessage] afterHidden:3];
            }
        } else {
            [self showError:self.view message:@"网络错误" afterHidden:3];
            NSLog(@"请求失败");
        }
    }];
}

//申诉
-(void)shensuButton{
    //确定申诉
    ShensuViewController *vc = [[ShensuViewController alloc]init];
    vc.orderSn = self.orderSn;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma -mark 取消订单

-(void)cancleButton{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *api = [NSString stringWithFormat:@"%@v1/details/cancleorderbypusher/",DOMAIN_NAME];
    if (self.type == 1) {
        params[@"orderSn"] = self.orderSn;
        params[@"userId"] = [UserModel sharedModel].userId;
        api = [NSString stringWithFormat:@"%@v1/details/cancleorder/",DOMAIN_NAME];
        
    }else{
        params[@"orderSn"] = self.orderSn;
        params[@"pushUserId"] = [UserModel sharedModel].userId;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"key = %@ and obj = %@", key, obj);
            [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat  progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        NSLog(@"ceshi   %f", progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success = %@", responseObject);
        
        int code = [[responseObject objectForKey:@"code"] intValue];
        //上传成功
        if (code == 1000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
            [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"取消订单成功" afterHidden:2];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:3];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError:self.view message:@"网络错误" afterHidden:3];
        NSLog(@"Failure %@", error.description);
    }];
}

- (void)loadURL {
    //获取展示详情的url请求
}

@end
