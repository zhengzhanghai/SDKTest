//
//  EditInformationViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "EditInformationViewController.h"


@interface EditInformationViewController ()

@end

@implementation EditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人信息";
    self.view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [self makeUI];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeUI {
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT+20, SCREEN_WIDTH, LandscapeNumber(113))];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.detailTextField = [[UITextField alloc]init];
    self.detailTextField.placeholder = @"请填写具体信息...";
    self.detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.detailTextField.textColor = UIColorFromRGB(0x666666);
    self.detailTextField.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.detailTextField];
    [self.detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).with.offset(15);
        make.top.mas_equalTo(backView.mas_top).with.offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH-LandscapeNumber(30));
        make.height.mas_equalTo(LandscapeNumber(50));
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(self.detailTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    UIButton *logBtn = [[UIButton alloc]init];
    logBtn.layer.masksToBounds = YES;
    logBtn.layer.cornerRadius = 6;
    logBtn.backgroundColor = UIColorFromRGB(0xDD5C5C);
    [logBtn setTitle:@"确认" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [logBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-LandscapeNumber(24), LandscapeNumber(44)));
        make.top.mas_equalTo(backView.mas_bottom).with.offset(LandscapeNumber(24));
    }];
    
}
-(void)clickConfirmBtn {

    if ([self.detailTextField.text isEqualToString:@""]) {
        //不能为空
        [self showError:self.view message:@"内容不能为空" afterHidden:3];
        return;
    }
    [self.detailTextField resignFirstResponder];
    
    [self modifyUserInfoRequest];
    
    /*
    if (_detailBlock) {
        _detailBlock(self.detailTextField.text);
    }
    
     */
}
-(void)modifyUserInfoRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@",API_POST_MODIFY_USER_PROFILE];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [UserModel sharedModel].userId;
    params[@"modifyName"] = @"accountName";
    params[@"modifyValue"] = self.detailTextField.text;
    
    NSLog(@"%@",params);
    [[AINetworkEngine sharedClient] postWithApi:url parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                //密码修改成功
                [self showSuccess:self.view message:@"修改成功" afterHidden:3];
                
//                NSLog(@"%@",[UserBaseInfoModel sharedModel].nickName);
//                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
        NSLog(@"%@",error);
        
    }];
}

@end
