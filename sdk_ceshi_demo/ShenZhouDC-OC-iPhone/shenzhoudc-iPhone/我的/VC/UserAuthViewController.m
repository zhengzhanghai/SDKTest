//
//  UserAuthViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "UserAuthViewController.h"
#import "MeMainViewController.h"
#import "ProtocolModel.h"
#import "ProtocolPDFViewController.h"

@interface UserAuthViewController ()
{
    UITextField *name;
    UITextField *mobile;
    UITextField *companyName;
    UITextField *companyEmail;
    UITextField *telephone;
    UITextField *referrer;
    UIButton    *_navSureBtn;
    UIButton    *_unfoldBtn;
    NSArray     *_protocolArray;
    UIButton    *_selectedBtn;
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property (strong, nonatomic) UIView *protocolView;
@end

@implementation UserAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"普通用户认证";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadProtocol];
}

- (void)loadProtocol {
    NSString *url = API_GET_USER_PROTOCOL;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSArray *list = result.getDataObj;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            for (NSUInteger i = 0; i < list.count; i++) {
                [arr addObject:[ProtocolModel modelWithDictionary:list[i]]];
            }
            _protocolArray = arr;
            [self makeUI];
            _navSureBtn.enabled = true;
        } else {
            [self showError:self.view message:@"获取协议失败，请重试" afterHidden:1.5];
        }
    }];
}

- (void)clickLeftItem {
    
    if (name.text.length == 0  || companyName.text.length == 0 || companyEmail.text.length == 0 || telephone.text.length == 0) {
        [self showError:self.view message:@"所有信息都不能为空" afterHidden:2];
        return;
    } if (!_selectedBtn.isSelected) {
        [self showError:self.view message:@"必须同意相关服务条款和隐私政策" afterHidden:2];
        return;
    }
    
    NSString *api = [NSString stringWithFormat:@"%@v1/regist/regist",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"accountId"] = [UserModel sharedModel].userId;
    params[@"accountName"] = name.text;
    params[@"email"] = companyEmail.text;
//    params[@"password"] = [UserBaseInfoModel sharedModel].password;
    params[@"unitName"] = companyName.text;
    params[@"telephone"] = telephone.text;
    params[@"checkbox"] = _selectedBtn.isEnabled ? @"1": @"0";
    if (referrer.text != nil && ![referrer.text isEqualToString:@""]) {
        params[@"referee"] = referrer.text;
    }
//    params[@"mobile"] = [UserBaseInfoModel sharedModel].mobile;
    
    NSLog(@"参数 ------> %@",params);
    
    [[AINetworkEngine sharedClient] postWithApi: api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"认证用户成功");
                [self showSuccess:self.view message:@"用户身份认证成功" afterHidden:2];
                NSDictionary *dic = result.getDataObj;
                NSLog(@"%@",dic);
                dic = [NSDictionary changeType:dic];
                
//                UserBaseInfoModel *model = [UserBaseInfoModel modelWithDictionary:dic];
//                [model writeToLocal];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"personalInfoRefresh" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:true];
                });
//                [self loadUserBaseInfoRequest];
                
            }else {
                NSLog(@"....%@",error);
                 [self showError:self.view message:[result getMessage] afterHidden:2];
            }
        } else {
            NSLog(@"请求失败 %@",error);
        }
    }];
}

//获取用户资料
-(void)loadUserBaseInfoRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@v1/user/getUsers?id=%@",DOMAIN_NAME,[UserModel sharedModel].userId];
    NSLog(@"%@",url);
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                NSLog(@"%@",dic);
                dic = [NSDictionary changeType:dic];
                
                UserBaseInfoModel *model = [UserBaseInfoModel modelWithDictionary:dic];
                [model writeToLocal];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMe" object:nil];
                
                UIViewController *getVC = nil;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    NSLog(@"%@",vc);
                    
                    if ([vc isKindOfClass:[MeMainViewController class]]) {
                        getVC = vc;
                        break;
                    }
                }
                
                if (getVC) {
                    [self.navigationController popToViewController:getVC animated:YES];
                }
            }
        }else{
            [self showError:self.view message:@"加载用户信息失败" afterHidden:3];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeUI {
    
    _navSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navSureBtn.frame = CGRectMake(15, SCREEN_HEIGHT, SCREEN_WIDTH-30, 40);
    [_navSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_navSureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_navSureBtn setTitleColor:[UIColorFromRGB(0xffffff) colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    _navSureBtn.backgroundColor = MainColor;
    _navSureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_navSureBtn addTarget: self action: @selector(clickLeftItem) forControlEvents: UIControlEventTouchUpInside];
    _navSureBtn.clipsToBounds = true;
    _navSureBtn.layer.cornerRadius = 3;
    [self.view addSubview:_navSureBtn];
    [_navSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 40);
    }];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-LandscapeNumber(51))];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_navSureBtn.mas_top).offset(-10);
    }];


    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"姓名";
    label1.textColor = UIColorFromRGB(0x3D4245);
    label1.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).with.offset(16);
        make.top.mas_equalTo(_scrollView.mas_top).with.offset(16);
    }];
    
    name = [self makeTextField];
    [_scrollView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label1.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(name.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
//    UILabel *label2 = [[UILabel alloc]init];
//    label2.text = @"手机号码";
//    label2.textColor = UIColorFromRGB(0x3D4245);
//    label2.font = [UIFont systemFontOfSize:16];
//    [self.scrollView addSubview:label2];
//    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(label1.mas_left);
//        make.top.mas_equalTo(name.mas_bottom).with.offset(15);
//    }];
//    
//    mobile = [self makeTextField];
//    mobile.keyboardType = UIKeyboardTypeNumberPad;
//    [_scrollView addSubview:mobile];
//    [mobile mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(label1.mas_left);
//        make.top.mas_equalTo(label2.mas_bottom).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
//    }];
    
//    UIView *line2 = [[UIView alloc]init];
//    line2.backgroundColor = UIColorFromRGB(0xECECEC);
//    [_scrollView addSubview:line2];
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(label1.mas_left);
//        make.top.mas_equalTo(mobile.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
//    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"邮箱";
    label3.textColor = UIColorFromRGB(0x3D4245);
    label3.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(name.mas_bottom).with.offset(10);
    }];
    
    UILabel *laber = [[UILabel alloc]init];
    laber.text = @"（尽量填写公司邮箱地址）";
    laber.textColor = UIColorFromRGB(0x3D4245);
    laber.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:laber];
    [laber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right).with.offset(3);
        make.centerY.mas_equalTo(label3.mas_centerY);
    }];
    
    
    companyEmail = [self makeTextField];
    [_scrollView addSubview:companyEmail];
    [companyEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label3.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyEmail.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"单位名称";
    label4.textColor = UIColorFromRGB(0x3D4245);
    label4.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyEmail.mas_bottom).with.offset(10);
    }];
    
    companyName = [self makeTextField];
    [_scrollView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label4.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line4 = [[UIView alloc]init];
    line4.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"固定电话";
    label5.textColor = UIColorFromRGB(0x3D4245);
    label5.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyName.mas_bottom).with.offset(10);
    }];
    
    telephone = [self makeTextField];
    telephone.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:telephone];
    [telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label5.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line5 = [[UIView alloc]init];
    line5.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(telephone.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"推荐人";
    label6.textColor = UIColorFromRGB(0x3D4245);
    label6.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(telephone.mas_bottom).with.offset(10);
    }];
    
    referrer = [self makeTextField];
    referrer.placeholder = @"(选填)";
    [_scrollView addSubview:referrer];
    [referrer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label6.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line6 = [[UIView alloc]init];
    line6.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line6];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(referrer.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.selected = true;
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_normal"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_selected"] forState:UIControlStateSelected];
    [_selectedBtn addTarget:self action:@selector(clickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_selectedBtn];
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(line6.mas_bottom).offset(15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(-70);
    }];
    
    UILabel *protocolTextLabel = [[UILabel alloc] init];
    protocolTextLabel.textColor = UIColorFromRGB(0x999999);
    protocolTextLabel.font = [UIFont systemFontOfSize:13];
    protocolTextLabel.text = @"我已阅读并同意相关服务条款和隐私政策";
    [_scrollView addSubview:protocolTextLabel];
    [protocolTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectedBtn.mas_right);
        make.centerY.mas_equalTo(_selectedBtn.mas_centerY);
    }];
    
    _unfoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_unfoldBtn setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [_unfoldBtn setImage:[UIImage imageNamed:@"icon_up"] forState:UIControlStateSelected];
    [_unfoldBtn addTarget:self action:@selector(clickUnfoldBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_unfoldBtn];
    [_unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(protocolTextLabel.mas_right);
        make.centerY.mas_equalTo(_selectedBtn.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
}

- (UITextField *)makeTextField {
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = @"请输入";
    textField.textColor = UIColorFromRGB(0x0F0F0F);
    textField.font = [UIFont systemFontOfSize:16];
    
    return textField;
}

- (void)clickSelectedBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
//    _navSureBtn.enabled = btn.isSelected;
}

- (void)clickUnfoldBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        [_scrollView addSubview:self.protocolView];
        [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_unfoldBtn.mas_bottom);
            make.centerX.mas_equalTo(_unfoldBtn.mas_centerX);
        }];
    } else {
        [_protocolView removeFromSuperview];
    }
}

- (void)clickProtocolBtn:(UIButton *)btn {
    ProtocolModel *model = _protocolArray[btn.tag];
    ProtocolPDFViewController *vc = [[ProtocolPDFViewController alloc] init];
    vc.loadURLString = model.protocolPdf;
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
}

- (UIView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[UIView alloc] init];
        
        for (NSUInteger i = 0; i < _protocolArray.count; i++) {
            ProtocolModel *model = _protocolArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:model.protocolName forState:UIControlStateNormal];
            [button setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickProtocolBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_protocolView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(i*30);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(30);
                if (i == _protocolArray.count-1) {
                    make.bottom.mas_equalTo(0);
                }
            }];
        }
        
    }
    return _protocolView;
}


@end
