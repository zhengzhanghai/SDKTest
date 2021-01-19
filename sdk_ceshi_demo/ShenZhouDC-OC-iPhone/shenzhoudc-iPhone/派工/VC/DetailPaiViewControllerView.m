//
//  DetailPaiViewControllerView.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "DetailPaiViewControllerView.h"
#import "DetailPaiTableViewCell.h"
#import "DetailHeaderView.h"
#import "PaiModel.h"
#import "SkillIntelligentViewController.h"
@interface DetailPaiViewControllerView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSourse;
@property (nonatomic,strong) DetailHeaderView *headerView;
@property (nonatomic,strong) MBProgressHUD *showError;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation DetailPaiViewControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"派工详情";
    [self setUpUi];
    _showError =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
    
}

- (void)loadData{

    _showError.label.text = @"加载中";
    [_showError showAnimated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/%zd",API_GET_ASSIGN_DETAILS,_ID];
    NSLog(@"URL=%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            if ([result isSucceed]) {
                
//                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *dict = [result getDataObj];
                PaiModel *model = [PaiModel modelWithDictionary:dict];
//                    [list addObject:model];
                
//                self.dataSourse = list;
               
                _headerView.model = model;
                _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headerView.selfHight);
                _tableView.tableHeaderView = _headerView;
                if (model.userId == [UserModel sharedModel].userId) {
//                    是发布人
                    if (model.assignStatus.intValue == 1) {
                        //                        待抢
                        _btn = [[UIButton alloc]init];
                        [_btn setTitle:@"待抢单" forState:UIControlStateNormal];
                        _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                        _btn.userInteractionEnabled = NO;
                        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    }else if(model.assignStatus.intValue == 2){
                        //                        已抢
                        _btn = [[UIButton alloc]init];
                        _btn.tag = 1001;
                        [_btn setTitle:@"待验收" forState:UIControlStateNormal];
                        _btn.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:22.0/255.0 blue:41.0/255.0 alpha:1];
                        [_btn addTarget:self action:@selector(clickShopEvent:) forControlEvents:UIControlEventTouchUpInside];
                        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else{
                        //                        结束
                        _btn = [[UIButton alloc]init];
                        [_btn setTitle:@"验收完毕" forState:UIControlStateNormal];
                        _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                        _btn.userInteractionEnabled = NO;
                        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                    }
                }else{
//                    不是发布人
                    if (model.assignStatus.intValue == 1) {
                        //                        待抢
                        _btn = [[UIButton alloc]init];
                        [_btn setTitle:@"立即抢单" forState:UIControlStateNormal];
                        _btn.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:22.0/255.0 blue:41.0/255.0 alpha:1];
                        [_btn addTarget:self action:@selector(clickPromptlyShopEvent:) forControlEvents:UIControlEventTouchUpInside];
                        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else if(model.assignStatus.intValue == 2){
                       //                        已抢
                        _btn = [[UIButton alloc]init];
                        [_btn setTitle:@"派工进行中" forState:UIControlStateNormal];
                        _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                        _btn.userInteractionEnabled = NO;
                        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else{
                       //                        结束
                        _btn = [[UIButton alloc]init];
                        [_btn setTitle:@"派工已结束" forState:UIControlStateNormal];
                        _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                        _btn.userInteractionEnabled = NO;
                        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                    }
                }
                _tableView.tableFooterView = [self creatFooterView];
                [_showError hideAnimated:YES afterDelay:0.3];
            }
//            [self.tableView reloadData];
        } else {
            [_showError hideAnimated:YES afterDelay:0];
            _showError.label.text = @"网络故障";
            [_showError showAnimated:YES];
            [_showError hideAnimated:YES afterDelay:0.5];
            NSLog(@"请求失败");
        }
        
    }];
    
}

#pragma mark - 派工抢单
- (void)loadDispatchingRobSingleData{
    if(![UserModel isLogin]){
        NSLog(@"请先登录");
        NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:^{
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    UserModel *userModel = [UserModel sharedModel];
    NSString *url = [NSString stringWithFormat:@"%@?id=%d&userId=%@",API_GET_ASSIGN_ASSIGNINDENT,self.ID,userModel.userId];
    NSLog(@"URL=%@",url);
//    NSString *ID = [NSString stringWithFormat:@"%d",self.ID];
//    NSDictionary *parameter = @{@"id":ID,@"userId":userModel.id};
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"抢单成功");
                NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"抢单成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertVc animated:YES completion:^{
                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [_btn setTitle:@"派工进行中" forState:UIControlStateNormal];
                _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                _btn.userInteractionEnabled = NO;
                [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
           
        } else {
            NSLog(@"抢单失败==%@",error);
            NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"抢单失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVc animated:YES completion:^{
                [alertVc dismissViewControllerAnimated:YES completion:nil];
            }];

        }

    }];
}

#pragma mark - 派工完成确认
- (void)loadDispatchingFinishdData{
        if(![UserModel isLogin]){
        NSLog(@"请先登录");
        NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:^{
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    UserModel *userModel = [UserModel sharedModel];
    NSString *url = [NSString stringWithFormat:@"%@?id=%d&userId=%@",API_GET_ASSIGN_ASSIGNAFFIRM,self.ID,userModel.userId];
    NSLog(@"URL=%@",url);
//    NSString *ID = [NSString stringWithFormat:@"%d",self.ID];
//    NSDictionary *parameter = @{@"id":ID,@"userId":userModel.id};
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
              
                if (_btn.tag == 1001) {
                    NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"验收成功" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertVc animated:YES completion:^{
                        [alertVc dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    [_btn setTitle:@"验收完毕" forState:UIControlStateNormal];
                    _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                    _btn.userInteractionEnabled = NO;
                    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                      NSLog(@"验收成功");
                }else{
                    NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"交付成功" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertVc animated:YES completion:^{
                        [alertVc dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    [_btn setTitle:@"交付完毕" forState:UIControlStateNormal];
                    _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                    _btn.userInteractionEnabled = NO;
                    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                      NSLog(@"交付成功");
                }
               
            }
            
        } else {
            NSLog(@"验收失败==%@",error);
            NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"验收失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVc animated:YES completion:^{
                [alertVc dismissViewControllerAnimated:YES completion:nil];
            }];
;
        }
        
    }];
}


- (void)setUpUi{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    DetailHeaderView *headerView = [DetailHeaderView customHeaaderFooterViewWith:_tableView];
    _headerView = headerView;
    
    [self.view addSubview:_tableView];
    
}

- (UIView*)creatFooterView{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 51);
    
    [view addSubview:_btn];
//    _btn = btn;
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return  view;
}
#pragma mark - 立即抢单
- (void)clickPromptlyShopEvent:(UIButton*)sender{
    NSLog(@"立即抢单");
    //    抢单
    [self loadDispatchingRobSingleData];
}
#pragma mark - 验收OR交付
- (void)clickShopEvent:(UIButton*)sender {
    
    if (sender.tag == 1001) {
        NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"是否确定验收派工?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //    验收
            [self loadDispatchingFinishdData];
        }];
        UIAlertAction *actionCnacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVc addAction:action];
        [alertVc addAction:actionCnacel];
        [self presentViewController:alertVc animated:YES completion:^{
        }];
        NSLog(@"验收");
    }else{
        NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"是否确定交付派工?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //    交付
            [self loadDispatchingFinishdData];
        }];
        UIAlertAction *actionCnacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVc addAction:action];
        [alertVc addAction:actionCnacel];
        [self presentViewController:alertVc animated:YES completion:^{
        }];
        NSLog(@"交付");
    }
    

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailPaiTableViewCell *cell = [DetailPaiTableViewCell customCellWithTableView:tableView andIndexPath:indexPath];
//    cell.model = self.dataSourse[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SkillIntelligentViewController *SkillIntelligent = [[SkillIntelligentViewController alloc]init];
    [self.navigationController pushViewController:SkillIntelligent animated:YES];
}
- (NSArray *)dataSourse{
    if (!_dataSourse) {
        _dataSourse = [NSArray array];
    }
    return _dataSourse;
}

@end
