//
//  SettingViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)makeUI {
    UIButton *logoutBtn = [[UIButton alloc]init];
    logoutBtn.layer.masksToBounds = YES;
    logoutBtn.layer.cornerRadius = 3;
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    logoutBtn.backgroundColor = MainColor;
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
//    [footView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 40);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOPBARHEIGHT-50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = UIColorFromRGB(0xfafafa);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(logoutBtn.mas_top).offset(-10);
    }];
    
    if(![UserModel isLogin]) {
        logoutBtn.hidden = YES;
    }else{
        logoutBtn.hidden = NO;
    }
//    self.tableView.tableFooterView = footView;
  
}

//MARK: UITableViewDelegate ----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    if (indexPath.row == 0) {
        cell.textLabel.text = @"消息推送";
        UISwitch *swich = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 51, 31)];
        [swich addTarget:self action:@selector(clickPushSwitch:) forControlEvents:UIControlEventTouchUpInside];
        swich.onTintColor = UIColorFromRGB(0xDD5C5C);
        cell.accessoryView = swich;
    }else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"关于我们";
        UIImageView *enterImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        enterImg.image = [UIImage imageNamed:@"icon_right"];
        cell.accessoryView = enterImg;
        
    }else {
        
        cell.textLabel.text = @"清除缓存";
        UILabel *cashLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        cashLabel.textColor = UIColorFromRGB(0x666666);
        cashLabel.font = [UIFont systemFontOfSize:16];
        cashLabel.textAlignment = NSTextAlignmentRight;
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            cashLabel.text = [NSString stringWithFormat:@"%.2lf M",totalSize/1024.0/1024.0];
        }];

        cell.accessoryView = cashLabel;
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)clickPushSwitch:(UISwitch *)swich {
    if (swich.isOn == YES) {
        
//        [[UIApplication sharedApplication] unregisterForRemoteNotifications]; //关闭远程推送
        
    }else if(swich.isOn == NO){
        
//        [[UIApplication sharedApplication] registerForRemoteNotifications]; //开启推送
    }
    
    
}
-(void)logoutBtnClick {
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要退出吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
    [actionSheet showInView:self.view];
    
   
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击  %ld", buttonIndex);
    
    switch (buttonIndex) {
        case 0:
        {
            [self sendLogoutRequest];
        }
            break;
            
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return  200;
    }
    return  0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 2) {
        [[SDWebImageManager sharedManager].imageCache calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            
            NSString *message = [NSString stringWithFormat:@"您确认清除%.2lfM的缓存吗？",totalSize/1024.0/1024.0];
            NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //确定时做的事
                [[[SDWebImageManager sharedManager] imageCache] clearDisk];
                [[[SDWebImageManager sharedManager] imageCache] clearMemory];
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                
            }];
            
            [alert addAction:cancel];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }else if (indexPath.row == 1) {
        AboutUsViewController *vc = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//网络请求 ---------
-(void)sendLogoutRequest {
    
    [self showLoadingToView:self.view];
    
    NSString *Url = [NSString stringWithFormat:@"%@%@?token=%@",DOMAIN_NAME,API_GET_LOGINOUT,[UserModel sharedModel].token];
    NSLog(@"%@",Url);
    if (![[UserModel sharedModel].token isEqualToString:@""] ||![[UserModel sharedModel].token isKindOfClass:[NSNull class]]) {
        [[AINetworkEngine sharedClient] getWithApi:Url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
            [self hiddenLoading];
            if (result != nil) {
                if(result.isSucceed){
                   NSLog(@"退出登录成功");
                    
                    [UserModel deleteFromLocal] ;
                    [UserBaseInfoModel deleteFromLocal];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutSuccess" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMe" object:nil];
                    [self showSuccess:App_Delegate.window message:@"退出成功" afterHidden:2];
                    [self.navigationController popViewControllerAnimated:true];
//                    [self performSelector:@selector(myTimerHandler) withObject:nil afterDelay:2];
                    
                }else{
                    [self showError:self.view message:@"退出失败" afterHidden:3];
                }
            } else {
                [self showError:self.view message:@"退出失败" afterHidden:3];
            }
        }];
  
    }else{
        NSLog(@"token已失效");
    }
}


-(void)myTimerHandler {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
