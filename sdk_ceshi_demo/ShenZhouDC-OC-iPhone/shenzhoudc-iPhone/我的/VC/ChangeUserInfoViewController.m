//
//  ChangeUserInfoViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/5/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ChangeUserInfoViewController.h"

@interface ChangeUserInfoViewController ()
{
    UIButton *maleBtn;
    UIButton *femaleBtn;
    
    int sex; //1男 2女
}
@property(nonatomic,strong) UITextField *nameField;


@end

@implementation ChangeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sex = [[UserBaseInfoModel sharedModel].sex intValue];
    
    // Do any additional setup after loading the view.
    self.title = self.titleTxt;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    self.title = @"修改用户资料";
    
    UIButton *SearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SearchBtn.frame = CGRectMake(SCREEN_WIDTH - 60,5, 50, 30);
    [SearchBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SearchBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [SearchBtn addTarget: self action: @selector(clickLeftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *search=[[UIBarButtonItem alloc]initWithCustomView:SearchBtn];
    self.navigationItem.rightBarButtonItem = search;
}
- (void)clickLeftItem {
    if (self.type == 0) {
        if (_nameField.text.length == 0) {
            [self showError:self.view message:@"请填写姓名" afterHidden:2];
            return;
        } 
        
    }
    [self sendRequest];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    if (self.type == 0) {
        
        UILabel *label = [[UILabel alloc]init];
        label.textColor = UIColorFromRGB(0x0F0F0F);
        label.text = @"姓名：";
        label.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT+30);
            make.width.mas_equalTo(60);
        }];
        
        
        _nameField = [[UITextField alloc]init];
        _nameField.textColor = UIColorFromRGB(0x0F0F0F);
        _nameField.font = [UIFont systemFontOfSize:15];
        _nameField.placeholder = @"请输入姓名";
        _nameField.borderStyle = UITextBorderStyleNone;
        _nameField.clearButtonMode = UITextFieldViewModeAlways;
        [self.view addSubview:_nameField];
        [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).with.offset(10);
            make.centerY.mas_equalTo(label.mas_centerY);
            make.width.mas_equalTo(SCREEN_WIDTH-90);
            make.height.mas_equalTo(44);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xECECEC);
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(_nameField.mas_bottom).with.offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(1);
        }];
        
        
        
    }else if (self.type == 1) {
       
        maleBtn = [[UIButton alloc]init];
        maleBtn.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
        maleBtn.layer.borderWidth = 1;
        maleBtn.layer.masksToBounds = YES;
        maleBtn.layer.cornerRadius = 4;
        [maleBtn addTarget:self action:@selector(chooseMale:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:maleBtn];
        [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(15+NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
            make.size.mas_equalTo(CGSizeMake(30,30));
        }];
        
        UILabel *makeLabel = [[UILabel alloc]init];
        makeLabel.text = @"男";
        makeLabel.textColor = UIColorFromRGB(0x3D4245);
        makeLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:makeLabel];
        [makeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(maleBtn.mas_centerY);
            make.left.mas_equalTo(maleBtn.mas_right).with.offset(10);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xECECEC);
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(maleBtn.mas_bottom).with.offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(1);
        }];
        
        
        femaleBtn = [[UIButton alloc]init];
        femaleBtn.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
        femaleBtn.layer.borderWidth = 1;
        femaleBtn.layer.masksToBounds = YES;
        femaleBtn.layer.cornerRadius = 4;
        [femaleBtn setImage:[UIImage imageNamed:@"maleBtn"] forState:UIControlStateSelected];
        [femaleBtn addTarget:self action:@selector(chooseFemale:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:femaleBtn];
        [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(maleBtn.mas_left);
            make.top.mas_equalTo(line.mas_bottom).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(30,30));
        }];
        
        UILabel *femaleLabel = [[UILabel alloc]init];
        femaleLabel.text = @"女";
        femaleLabel.textColor = UIColorFromRGB(0x3D4245);
        femaleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:femaleLabel];
        [femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(femaleBtn.mas_centerY);
            make.left.mas_equalTo(femaleBtn.mas_right).with.offset(10);
        }];
        
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = UIColorFromRGB(0xECECEC);
        [self.view addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(femaleBtn.mas_bottom).with.offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(1);
        }];
 
    }
    
    
    
}

- (void)chooseMale:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        femaleBtn.selected = NO;
        sex = 1;
        [sender setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
        
    }
    
    
}
- (void)chooseFemale:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        maleBtn.selected = NO;
        sex = 2;
        [sender setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
        
    }
    
}
- (void)sendRequest {
    NSString *api = [NSString stringWithFormat:@"%@v1/user/updateuser",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [UserModel sharedModel].userId;
    if (self.type == 0) {
        //姓名
        params[@"nickName"] = _nameField.text;
        
    }else if (self.type == 1) {
        params[@"sex"] = [NSString stringWithFormat:@"%d",sex];
    }
    
    NSLog(@"参数------ &&&&&  %@",params);
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
                [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"更改成功" afterHidden:4];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"personalInfoRefresh" object:nil];

                [self.navigationController popViewControllerAnimated:YES];
                           }
        } else {
            NSLog(@"请求失败");
            [self showError:self.view message:@"网络错误" afterHidden:3];
        }
        
    }];
    
    
}

@end
