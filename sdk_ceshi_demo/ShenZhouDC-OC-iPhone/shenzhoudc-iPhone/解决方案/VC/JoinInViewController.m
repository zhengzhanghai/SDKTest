//
//  JoinInViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "JoinInViewController.h"
#import "ProtocolModel.h"
#import "ProtocolPDFViewController.h"
#import "NoAutorotateAlertController.h"

@interface JoinInViewController ()
@property(nonatomic,strong)UITextField *price;
@end

@implementation JoinInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报名接单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeUI {
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"请填写您接受派单的价格，单位（元）";
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(self.view.mas_top).with.offset(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT+LandscapeNumber(30));
    }];
    
    _price = [[UITextField alloc]init];
    _price.textColor = [UIColor darkGrayColor];
    _price.font = [UIFont systemFontOfSize:17];
    _price.keyboardType = UIKeyboardTypeDecimalPad;
//    _price.borderStyle = UITextBorderStyleRoundedRect;
    _price.clearButtonMode = UITextFieldViewModeAlways;
    _price.placeholder = @"请输入价格";
    [self.view addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(label.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 40));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = MainColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, IS_IPAD ? 55 : 40));
    }];
}

//报名 提交价格
- (void)clickBtn {
    
    if (_price.text.floatValue < 1.0) {
        [_price resignFirstResponder];
        [self showError:self.view message:@"金额不能小于1元" afterHidden:2];
        return ;
    }
    
    [self showLoadingToView:App_Delegate.window];
    NSString *url = API_GET_IT_JOIN_PROTOCOL;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result.isSucceed) {
            NSArray *list = result.getDataObj;
            NSMutableArray *arr = [NSMutableArray array];
            for (NSUInteger i = 0; i < list.count; i++) {
                [arr addObject:[ProtocolModel modelWithDictionary:list[i]]];
            }
            
            if (arr.count > 0) {
                NoAutorotateAlertController *alertVC = [NoAutorotateAlertController alertControllerWithTitle:@"请认真阅读协议" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertVC addAction:cancel];
                for (NSUInteger i = 0; i < arr.count; i++) {
                    ProtocolModel *model = arr[i];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:model.protocolName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ProtocolPDFViewController *vc = [[ProtocolPDFViewController alloc] init];
                        vc.loadURLString = model.protocolPdf;
                        vc.hidesBottomBarWhenPushed = true;
                        [self.navigationController pushViewController:vc animated:true];
                    }];
                    [alertVC addAction:action];
                }
                UIAlertAction *buyAction = [UIAlertAction actionWithTitle:@"同意协议并提交" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self submitBoming];
                }];
                [alertVC addAction:buyAction];
                [self presentViewController:alertVC animated:true completion:^{
                    
                }];
            }
        } else {
            if (error) {
                [self showError:self.view message:@"获取协议失败，请重试" afterHidden:1.5];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:1.5];
            }
        }
    }];
}

- (void)submitBoming {
    [self loadingAddCountToView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"price"] = self.price.text;
    params[@"id"] = [UserModel sharedModel].userId;
    params[@"orderSn"] = self.orderSn;
    params[@"mobile"] = [UserBaseInfoModel sharedModel].mobile;
    params[@"type"] = [UserBaseInfoModel sharedModel].type;
    params[@"checkbox"] = @"1";
    NSLog(@"参数--%@",params);
    [[AINetworkEngine sharedClient] postWithApi:API_POST_RECIEVE parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self loadingSubtractCount];
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"报名成功");
                [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"报名成功" afterHidden:1.5];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self showError:self.view message:[result getMessage] afterHidden:2];
            }
            
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:2];
            NSLog(@"请求失败");
        }
        
    }];
}

@end
