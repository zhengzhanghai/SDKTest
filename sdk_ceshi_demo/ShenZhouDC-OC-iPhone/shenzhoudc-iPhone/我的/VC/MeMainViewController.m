//
//  MeMainViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//


#import "MeMainViewController.h"
#import "MeTableViewCell.h"
#import "RecieveTaskViewController.h"

#import "SettingViewController.h"
#import "PersonInfoViewController.h"
#import "LoginViewController.h"
//我的
#import "MyPlanViewController.h"
#import "MyDispatchViewController.h"
#import "MyRequireMentViewController.h"
#import "MyDownloadViewController.h"
#import "VideoDownloadRecordViewController.h"
#import "MyServiceViewController.h"
#import "MyKeyProjectViewController.h"
//发布
#import "PublickDispatchViewController.h"
#import "PublickRequirementViewController.h"
#import "PublickPlanViewController.h"
#import "ParticipaterListViewController.h"
#import "ChargeViewController.h"
#import "MyFavoriteViewController.h"

#import "KeyProjectSurePassController.h"

@interface MeMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *headImgBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UIView *statusView;
@property(nonatomic,strong) UILabel *identifierLabel; //认证的身份

@property (strong, nonatomic) NSDictionary *cellTitleDict;
@property (strong, nonatomic) NSDictionary *titleIconDict;

@property (strong, nonatomic) UserBaseInfoModel *baseInfoModel;

@end

@implementation MeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self configData];
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessful) name:@"LogoutSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserBaseInfoRequest) name:@"personalInfoRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMe) name:@"refreshMe" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPay) name:@"pushPay" object:nil];
    
}

- (void)configData {
    _cellTitleDict = @{@(-1): @[@"我的平台账户"],
                       @0: @[@"我的下载", @"我的方案", @"我的交钥匙项目", @"发布方案", @"我的派工", @"我的平台账户", @"我的收藏"],
                       @1: @[@"我的下载", @"我的方案", @"我的交钥匙项目", @"我的派工", @"我的平台账户", @"我的收藏"],
                       @2: @[@"我的下载", @"我的平台账户", @"我的收藏"],
                       @3: @[@"我的下载", @"我的平台账户", @"我的收藏"],
                       @4: @[@"我的下载", @"我的平台账户", @"我的收藏"],
                       @5: @[@"我的下载", @"我的方案", @"我的交钥匙项目", @"发布方案", @"我的派工", @"我的平台账户", @"我的收藏"],
                       @6: @[@"我的下载", @"我的平台账户", @"我的收藏"],
                       @"未登录": @[]};
    _titleIconDict = @{@"我的下载": @"me_download",
                       @"我的方案": @"me_solution",
                       @"我的交钥匙项目": @"me_keyproject",
                       @"发布方案": @"me_send_solution",
                       @"我的派工": @"me_paigong",
                       @"我的平台账户": @"me_account",
                       @"我的收藏": @"me_favorite"};
}

//获取用户资料
-(void)loadUserBaseInfoRequest {
    if (![UserModel isLogin]) return;
    NSString *url = [NSString stringWithFormat:@"%@v1/user/getUsers?id=%@",DOMAIN_NAME,[UserModel sharedModel].userId];
    NSLog(@"%@",url);
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                dic = [NSDictionary changeType:dic];
                UserBaseInfoModel *model = [UserBaseInfoModel modelWithDictionary:dic];
                
                [model writeToLocal];
                [self loginSuccessful];
                _baseInfoModel = model;
                [self personalInfoRefresh: model];
            }
        }else{
            [self showError:self.view message:@"加载用户信息失败" afterHidden:2];
        }
    }];
}

#pragma -mark pushPay
-(void)pushPay{
    ChargeViewController *vc = [[ChargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshMe {
    _baseInfoModel = [UserBaseInfoModel readFromLocal];
    [self.tableView reloadData];
}
//登录成功 刷新
-(void) loginSuccessful{
    UserBaseInfoModel *model = [UserBaseInfoModel readFromLocal];
    [self.headImgBtn sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    self.nameLabel.text = [model.nickName isEqualToString: @""]?@"未设置":model.nickName;
    self.phoneNumLabel.hidden = NO;
    
    NSString *numStr = model.mobile;
    if (![model.mobile isEqualToString:@""] && model.mobile != nil) {
       
        NSString *string = [numStr substringWithRange:NSMakeRange(3,4)];
        //字符串的替换
        numStr = [numStr stringByReplacingOccurrencesOfString:string withString:@"****"];
    }
    self.phoneNumLabel.text = [model.mobile isEqualToString:@""]?@"未绑定手机号":numStr;
    _identifierLabel.text = [model userTypeStr];
}

//退出登录 刷新
-(void)logoutSuccessful {
    self.headImgBtn.image = [UIImage imageNamed:@"user_icon"];
    self.nameLabel.text = @"点击登录";
    self.phoneNumLabel.hidden = YES;
    
    self.identifierLabel.text = @"";
}
//个人信息页变更 刷新
-(void)personalInfoRefresh:(UserBaseInfoModel *)infoModel {
    if (![UserModel isLogin]) return;
    UserBaseInfoModel *model = [UserBaseInfoModel readFromLocal];
    if (infoModel != nil && [infoModel isKindOfClass:[UserBaseInfoModel class]]) {
        model = infoModel;
    }
    NSString *str = model.portrait;
    [self.headImgBtn sd_setImageWithURL:[NSURL URLWithString:str]];
    _identifierLabel.text = [model userTypeStr];
    self.nameLabel.text = model.nickName;
    [self.headImgBtn sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    [self.tableView reloadData];
  
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserBaseInfoRequest];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

-(void)makeUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [self makeHeadView];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-TABBARHEIGHT);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}
-(UIView*)makeHeadView {
    UserBaseInfoModel *userModel = [UserBaseInfoModel readFromLocal];
    
    UIButton *headView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*662/1242)];
    [headView addTarget:self action:@selector(clickHeadView) forControlEvents:UIControlEventTouchUpInside];
    [headView setImage:[UIImage imageNamed:@"head_icon_bg"] forState:UIControlStateNormal];
    
    self.headImgBtn = [[UIImageView alloc]init];
    self.headImgBtn.layer.masksToBounds = YES;
    self.headImgBtn.layer.cornerRadius = LandscapeNumber(65)/2;
    self.headImgBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImg)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.headImgBtn addGestureRecognizer:singleRecognizer];

    [self.headImgBtn sd_setImageWithURL:[NSURL URLWithString:[UserBaseInfoModel sharedModel].portrait] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    [headView addSubview:self.headImgBtn];
    [self.headImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(65), LandscapeNumber(65)));
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    if (![UserModel isLogin]) {
        self.nameLabel.text = @"点击登录";
    }else{
        self.nameLabel.text = userModel.nickName;
    }
    [headView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(self.headImgBtn.mas_bottom).with.offset(2);
    }];
    
    self.phoneNumLabel = [[UILabel alloc]init];
    self.phoneNumLabel.textColor = UIColorFromRGB(0xFFA5A5);
    self.phoneNumLabel.font = [UIFont systemFontOfSize:10];
    [headView addSubview:self.phoneNumLabel];
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).with.offset(4);
    }];
    if (![UserModel isLogin]) {
        self.phoneNumLabel.hidden = YES;
    }else{
        self.phoneNumLabel.hidden = NO;
        if (![userModel.mobile isEqualToString:@""] && userModel.mobile != nil) {
            
            NSString *numStr = userModel.mobile;
            NSString *string = [numStr substringWithRange:NSMakeRange(3,4)];
            //字符串的替换
            numStr = [numStr stringByReplacingOccurrencesOfString:string withString:@"****"];
            
            self.phoneNumLabel.text = numStr;//userModel.mobile;
        }else{
            self.phoneNumLabel.text = @"未绑定手机号";
        }
    }
    
    self.identifierLabel = [[UILabel alloc]init];
    self.identifierLabel.font = [UIFont systemFontOfSize:10];
    self.identifierLabel.textColor = UIColorFromRGB(0xFFA5A5);
    [headView addSubview:self.identifierLabel];
    [self.identifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(self.phoneNumLabel.mas_bottom);
    }];
    if(![UserModel isLogin]) {
        self.identifierLabel.text = @"";
    }else{
        _identifierLabel.text = [userModel userTypeStr];
    }
    return headView;
}

//点击 头像
- (void)clickHeadImg {
    if (![UserModel isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PersonInfoViewController *vc = [[PersonInfoViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
  }
}
//点击 搜索 按钮
- (void)clickSearchBtn {
    
}
//点击 头部视图
- (void)clickHeadView {
    //判断是否是登录状态
    if ([UserModel isLogin]) {
        PersonInfoViewController *vc = [[PersonInfoViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //未登录
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//MARK: UITableViewDelegate -----------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *type = _baseInfoModel.type;
//    NSString *type = [UserBaseInfoModel sharedModel].type;
    if (section == 0) {
        if (![UserModel isLogin]) {
            return 0;
        }
        NSArray *titles = _cellTitleDict[type];
        return titles.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeTableViewCell *cell = [MeTableViewCell makeMeTableViewCell:tableView WithIndexPath:indexPath];
    NSString *type = _baseInfoModel.type;
    if (indexPath.section == 0) {
        NSArray *titles = nil;
        if (![UserModel isLogin]) {
            titles = _cellTitleDict[@"未登录"];
        } else {
            titles = _cellTitleDict[type];
        }
        NSString *title = titles[indexPath.row];
        cell.titleLabel.text = title;
        cell.icon.image = [UIImage imageNamed:_titleIconDict[title]];
    } else {
        cell.titleLabel.text = @"设置";
        cell.icon.image = [UIImage imageNamed:@"me_setting"];
    }
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 7;
    }
    return 0;
}

// TODO: ------  点击跳转页面  ---------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0) {
        NSString *type = nil; 
        if (![UserModel isLogin]) {
            type = @"未登录";
        } else {
            type = _baseInfoModel.type;
        }
        NSString *cellTitle = [_cellTitleDict[type] objectAtIndex:indexPath.row];
        if ([cellTitle isEqualToString:@"我的下载"]) {
            VideoDownloadRecordViewController *vc = [[VideoDownloadRecordViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([cellTitle isEqualToString:@"我的方案"]) {
            MyPlanViewController *vc = [[MyPlanViewController alloc]init];
            vc.type = 1;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([cellTitle isEqualToString:@"我的交钥匙项目"]) {
            MyKeyProjectViewController *vc = [[MyKeyProjectViewController alloc] init];
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([cellTitle isEqualToString:@"发布方案"]) {
            [self showError:self.view message:@"请到PC端发布方案" afterHidden:1.5];
//            PublickPlanViewController *vc = [[PublickPlanViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        } else if ([cellTitle isEqualToString:@"我的派工"]) {
            MyServiceViewController *vc = [[MyServiceViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([cellTitle isEqualToString:@"我的平台账户"]) {
            ChargeViewController *vc = [[ChargeViewController alloc]init];
            vc.userInfoModel = _baseInfoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([cellTitle isEqualToString:@"我的收藏"]) {
            MyFavoriteViewController *vc = [[MyFavoriteViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
