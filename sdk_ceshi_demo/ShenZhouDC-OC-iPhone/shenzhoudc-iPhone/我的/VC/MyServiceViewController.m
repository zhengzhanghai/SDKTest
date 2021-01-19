//
//  MyServiceViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyServiceViewController.h"
#import "ParticipaterListViewController.h"
#import "SendDealViewController.h"
#import "DispatchDetailsViewController.h"
#import "DoubleCommentViewController.h"
#import "DealDetailViewController.h"
#import "RecieveTaskViewController.h"
#import "ActingViewController.h"
#import "MySendCell.h"
#import "MySendModel.h"
#import "MyRecievedModel.h"
#import "ShensuViewController.h"
#import "ChargeViewController.h"
#import "MyRevicedOrderCell.h"
#import "MeChooseMenuView.h"


@interface MyServiceViewController ()<UITableViewDelegate,UITableViewDataSource,CancelDelegate>
{
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIButton    *_unfoldBtn;
    NSArray     *_protocolArray;
}

@property(nonatomic , assign) int type;//类型 0.我的派单 1.我的接单
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (nonatomic,assign) NSInteger page;
@property (strong, nonatomic) UIView *protocolView;
@end

@implementation MyServiceViewController

-(NSMutableArray *)dataSourse {
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return  _dataSourse;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的派工";
    [self makeUI];
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = 0;//默认为0
    if (leftBtn) {
        leftBtn.selected = YES;
    }
    [self loadData];
    [self loadingAddCountToView:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMySendList) name:@"refreshMySendList" object:nil];
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, 0, 70, 30);
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [publishBtn setTitle:@"我要发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(clickRightItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)refreshMySendList {
    _page = 1;
    [self loadData];
}

#pragma -mark 申诉
-(void)buttonClick:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"去支付"]) {
        NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:@"确定支付？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //确定删除订单
            
            [self paymentRequestWith:sender.tag];
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if ([sender.currentTitle isEqualToString:@"取消订单"]) {
        NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:@"确定取消订单？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //确定删除订单
            
            [self cancelNetWith:sender.tag];
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//发单人  接单人  支付 一样
- (void)paymentRequestWith:(NSInteger)sender {
    
    MySendModel *model = self.dataSourse[sender];
    NSString *api = [NSString stringWithFormat:@"%@v1/payment/pay",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = model.orderSn;
    params[@"accountId"] = [UserModel sharedModel].userId;
    
    
    
    NSLog(@" --- %@,,,%@",params,api);
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"支付成功");
                [self showSuccess:self.view message:@"预付款支付成功" afterHidden:4];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
               
               
                
            }else{
                if ([result getCode] == 1002) {//余额不足
                    //钱不够，调用第三方支付充值到平台
                    NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:@"账户余额不足" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        //确定删除订单
                        //调用本地充值接口
                        ChargeViewController *vc = [[ChargeViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                    [alert addAction:confirm];
                    [self presentViewController:alert animated:YES completion:nil];

                    
                   
                    
                    
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





#pragma -mark 取消订单
-(void)cancelClick:(UIButton *)sender
{
    NSLog(@"cancel 订单");
    NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:@"确定取消订单？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //确定删除订单
        
        [self cancelNetWith:sender.tag];
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];

    
    
}

-(void)doWorkClick:(UIButton *)sender
{
    NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:@"确认开工？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //确定删除订单
        
        [self doWorkNetWith:sender.tag];
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma -mark 取消订单接口
-(void)cancelNetWith:(NSInteger)sender{
    
    MySendModel *model = self.dataSourse[sender];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *api = [NSString stringWithFormat:@"%@v1/details/cancleorderbypusher/",DOMAIN_NAME];
    if (self.type == 1) {
        params[@"orderSn"] = model.orderSn;
        params[@"userId"] = [UserModel sharedModel].userId;
        api = [NSString stringWithFormat:@"%@v1/details/cancleorder/",DOMAIN_NAME];

    }else{
        params[@"orderSn"] = model.orderSn;
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
            [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"取消订单成功" afterHidden:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:3];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self showError:self.view message:@"网络错误" afterHidden:3];
        NSLog(@"Failure %@", error.description);
    }];

    
    
}



#pragma -mark 确认开工
-(void)doWorkNetWith:(NSInteger)sender{
    MySendModel *model = self.dataSourse[sender];
    

    NSString *api = [NSString stringWithFormat:@"%@v1/details/getWorkStart",DOMAIN_NAME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"connectid"] = [UserModel sharedModel].userId;
    params[@"userid"] = model.userid;
    params[@"orderSn"] = model.orderSn;
    
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
                [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"开工成功" afterHidden:2];
                
            }else{
                 [self showError:self.view message:[result getMessage] afterHidden:3];
            }
        } else {
             [self showError:self.view message:@"网络错误" afterHidden:3];
            NSLog(@"请求失败");
        }
        
    }];
    
    
}

- (void)clickRightItem {
    SendDealViewController *vc = [[SendDealViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *)makeHeadView {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LandscapeNumber(65))];
    headView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, LandscapeNumber(30)));
    }];
    
    leftBtn = [[UIButton alloc]init];
    [leftBtn setTitle:@"我的派单" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(line.mas_left);
    }];
    
    
    rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"我的接单" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(line.mas_right);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [headView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(headView.mas_bottom);
    }];
    
    return headView;
}
//点击 我的派单
-(void)clickLeftBtn:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        rightBtn.selected = NO;
        self.type = 0;
        [self loadData];
        [self loadingAddCountToView:self.view];
    }
    NSLog(@"%d",self.type);
}
//点击 我的接单
-(void)clickRightBtn :(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        leftBtn.selected = NO;
        self.type = 1;
        [self loadData];
        [self loadingAddCountToView:self.view];
    }
    NSLog(@"%d",self.type);
    
}

-(void)makeUI {
    MeChooseMenuView *menuView = [[MeChooseMenuView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, 45) titles:@[@"我的派单", @"我的接单"]];
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(IS_IPAD ? 55 : 45);
        
    }];
    menuView.clickItemBlock = ^(NSUInteger index) {
        self.type = (int)index;
        [self loadData];
        [self loadingAddCountToView:self.view];
    };
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 117;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(menuView.mas_bottom);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page+=1;
        [self loadData];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MySendCell" bundle:nil] forCellReuseIdentifier:@"MySendCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyRevicedOrderCell" bundle:nil] forCellReuseIdentifier:@"MyRevicedOrderCell"];
//    self.tableView.tableHeaderView = [self makeHeadView];
}
//MARK: UITableViewDelegate ----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourse.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MySendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MySendCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.buttonClick.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.type == 0) {
        [cell makeITSendCellWithModel:self.dataSourse[indexPath.row]];
    } else {
        [cell makeITSendCellWithRecieveModel:self.dataSourse[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        //我的派单
        MySendModel *model = self.dataSourse[indexPath.row];
        MyRecievedModel *remodel = self.dataSourse[indexPath.row];
        switch ([model.workType intValue]) {
            case -1:
                // 发单人取消
            {
                [self showError:self.view message:@"订单已经取消" afterHidden:2];
            }
                 break;
            case 0:
                //未报名  跳转到订单详情
            {
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
                dvc.canShensu = NO;
                dvc.isWork = NO;
                dvc.showBtn = YES;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 1:
            {
                //已报名   跳转到   报名者列表
                ParticipaterListViewController *vc = [[ParticipaterListViewController alloc]init];
                vc.orderSn = model.orderSn;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2://未付款   去支付
            {
            }
                break;
            case 3://等接单人接单 可取消订单
            {
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
                dvc.canShensu = NO;
                dvc.isWork = NO;
                 dvc.showBtn = YES;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 4://待接单人开始工作  可以取消订单
            {
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
                dvc.canShensu = NO;
                dvc.isWork = NO;
                 dvc.showBtn = YES;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 5://进行中 跳转到查看详情  可以申诉
            {
                //不能取消  能申诉
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
                dvc.canShensu = YES;
                dvc.isWork = NO;
                 dvc.showBtn = YES;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 6://待验收
            {
                DispatchDetailsViewController *vc = [[DispatchDetailsViewController alloc]init];
                vc.isOver = [model.confirmType intValue];
                vc.type = 0;
                vc.model = model;
                vc.recModel = remodel;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 7://完工
            {
                DoubleCommentViewController *vc = [[DoubleCommentViewController alloc]init];
                vc.orderSn = model.orderSn;
                vc.type = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 8://申诉中
            {
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
              
                dvc.showBtn = NO;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 9://接单人取消订单
            {
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
                dvc.showBtn = NO;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            default:
                break;
        }
    } else if (self.type == 1) {
        //我的接单
        MyRecievedModel *model = self.dataSourse[indexPath.row];
        switch ([model.serviceType intValue]) {
            case -1:
            {
                //已取消
            }
                break;
            case 0:
            {
                //已报名 接单人能取消
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 1;
                dvc.canShensu = NO;
                 dvc.showBtn = YES;
                dvc.orderSn = [NSString stringWithFormat:@"%@",model.orderSn];
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 1:
            {
                //待接单
                RecieveTaskViewController *dvc = [[RecieveTaskViewController alloc]init];
                dvc.orderSn = [NSString stringWithFormat:@"%@",model.orderSn];
                dvc.orderPrice = [NSString stringWithFormat:@"%@",model.orderPrice];
                dvc.userid = [NSString stringWithFormat:@"%@",model.userid];
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 2:
            {
                //未付款
            }
                break;
            case 3:
            {
                //未开工  去开工
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 1;
                dvc.canShensu = YES;
                dvc.orderSn = model.orderSn;
                dvc.isWork = YES;
                 dvc.showBtn = YES;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 4:
            {
                //进行中 完工+评价+申诉
                DispatchDetailsViewController *dvc = [[DispatchDetailsViewController alloc]init];
                dvc.type = 1;
                dvc.recModel = model;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            case 5://完工 到评价列表
            {
                DoubleCommentViewController *vc = [[DoubleCommentViewController alloc]init];
                vc.orderSn = model.orderSn;
                vc.type = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6://申诉中
            {
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
                dvc.showBtn = NO;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                 break;
            case 7://发单人取消
            {
                DealDetailViewController *dvc = [[DealDetailViewController alloc]init];
                dvc.type = 0;
                dvc.orderSn = model.orderSn;
                dvc.showBtn = NO;
                [self.navigationController pushViewController:dvc animated:YES];
            }
                break;
            default:
                break;
        }
        
    }
    
}
-(void)loadData {
    NSLog(@"当前用户类型======= %d",self.type);
    
//    [self loadingAddCountToView:self.view];
   
    [self.dataSourse removeAllObjects];
     [self.tableView reloadData];
    
    if (self.type == 0) {
//        [self.dataSourse removeAllObjects];
        //我的派单
        NSString *url = [NSString stringWithFormat:@"%@?userid=%@&page=%zd&size=20",API_GET_MYSENDLIST,[UserModel sharedModel].userId, _page];
        NSLog(@"接口1------ %@",url);
        [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
            [self loadingSubtractCount];
            if (result != nil) {
                if ([result isSucceed]) {
                    NSLog(@"%@",result);
                    NSMutableArray *list = [NSMutableArray array];
                    NSArray *array = [result getDataObj];
                    for (int i = 0; i < array.count; i++) {
                        MySendModel *model = [MySendModel modelWithDictionary:array[i]];
                        [list addObject:model];
                    }
                    
                    if (_page == 1) {
                        self.dataSourse = list;
                        NSLog(@"下拉刷新出%zd条数据",list.count);
                    }else{
                        NSLog(@"上拉加载更多%zd条数据",list.count);
                        for (MySendModel *model in list) {
                            [self.dataSourse addObject:model];
                        }
//                    self.dataSourse = list;
                    
                    }
                    [self.tableView reloadData];
                    
                }
            } else {
                NSLog(@"请求失败");
                [self showError:self.view message:@"加载错误，请重试" afterHidden:2];
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self loadingSubtractCount];
            
        }];
    }else if(self.type == 1){
    //我的接单
        NSString *url = [NSString stringWithFormat:@"%@?connectid=%@",API_GET_MYRECIEVELIST,[UserModel sharedModel].userId];
        NSLog(@"接口2------ %@",url);
        [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
            [self loadingSubtractCount];
            if (result != nil) {
                if ([result isSucceed]) {
                    
                    NSMutableArray *list = [NSMutableArray array];
                    NSArray *array = [result getDataObj];
                    for (int i = 0; i < array.count; i++) {
                        MyRecievedModel *model = [MyRecievedModel modelWithDictionary:array[i]];
                        [list addObject:model];
                    }
//                    self.dataSourse = list;
                    if (_page == 1) {
                        self.dataSourse = list;
                        NSLog(@"下拉刷新出%zd条数据",list.count);
                    }else{
                        NSLog(@"上拉加载更多%zd条数据",list.count);
                        for (MySendModel *model in list) {
                            [self.dataSourse addObject:model];
                        }
                }
                    [self.tableView reloadData];
  
                }
            } else {
                NSLog(@"请求失败");
                 [self showError:self.view message:@"加载错误，请重试" afterHidden:2];
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self loadingSubtractCount];
        }];
    }
    
    
}

@end
