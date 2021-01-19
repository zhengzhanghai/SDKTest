//
//  DetailPaiCollectionViewControllerView.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 17/1/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DetailPaiCollectionViewControllerView.h"
#import "SuccessCaseCollectionViewCell.h"
#import "PaiModel.h"
#import "CustomDetailHeaderView.h"
#import "DetailCaseCollectionViewCell.h"
#import "SkillIntelligentViewController.h"
@interface DetailPaiCollectionViewControllerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSourse;
@property (nonatomic,strong) CustomDetailHeaderView *headerView;
@property (nonatomic,strong) MBProgressHUD *showError;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) PaiModel *detailModel;
@end

@implementation DetailPaiCollectionViewControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"派工详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpUi];
    [self loadExpertList];
    [self loadData];
//    [self loadDerailImages];
    
//    _showError =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)loadData{
    
    [self loadingAddCountToView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%zd",API_GET_ASSIGN_DETAILS,_ID];
    NSLog(@"派工详情....URL=%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            if ([result isSucceed]) {
                
                //                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *dict = [result getDataObj];
                PaiModel *model = [PaiModel modelWithDictionary:dict];
                //                    [list addObject:model];
                
                //                self.dataSourse = list;
                _detailModel = model;
                _headerView.model = model;
                [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(LandscapeNumber(_headerView.selfHight));
                }];
                _scrollView.contentSize = CGSizeMake(0,LandscapeNumber(_headerView.selfHight) + LandscapeNumber(322) + LandscapeNumber(64));
                if([UserModel isLogin]){
            
                if (model.orderUserId.intValue == [UserModel sharedModel].userId.intValue) {
                    //                    是抢单人
                    if(model.assignStatus.intValue == 2){
                        //                        待交付
                        [self creatFooterButtonStatus:2 andIsIssue:0];
                        
                    }else{
                        //                        结束
                        [self creatFooterButtonStatus:3 andIsIssue:0];
                        
                    }

                }else{
                    if (model.userId.intValue == [UserModel sharedModel].userId.intValue) {
                        //                    是发布人
                        if (model.assignStatus.intValue == 1) {
                            //                        待抢
                            [self creatFooterButtonStatus:1 andIsIssue:1];
                            
                        }else if(model.assignStatus.intValue == 2){
                            //                        已抢
                            [self creatFooterButtonStatus:2 andIsIssue:1];
                            
                        }else if(model.assignStatus.intValue == 3){
                            //                        交付中
                            [self creatFooterButtonStatus:3 andIsIssue:1];
                            
                        }else{
                            //                        结束
                            [self creatFooterButtonStatus:4 andIsIssue:1];
                            
                        }
                    }
                    
                    if (model.userId.intValue != [UserModel sharedModel].userId.intValue){
                        //                    不是发布人
                        if (model.assignStatus.intValue == 1) {
                            //                        待抢
                            [self creatFooterButtonStatus:1 andIsIssue:2];
                            
                        }else if(model.assignStatus.intValue == 2){
                            //                        已抢
                            [self creatFooterButtonStatus:2 andIsIssue:2];
                            
                        }else{
                            //                        结束
                            [self creatFooterButtonStatus:3 andIsIssue:2];
                            
                        }
                    }

                }
     
                
                }else{
//                    未登录
                    if (model.userId.intValue == [UserModel sharedModel].userId.intValue) {
                        //                    是发布人
                        if (model.assignStatus.intValue == 1) {
                            //                        待抢
                            [self creatFooterButtonStatus:1 andIsIssue:1];
                            
                        }else if(model.assignStatus.intValue == 2){
                            //                        已抢
                            [self creatFooterButtonStatus:2 andIsIssue:1];
                            
                        }else{
                            //                        结束
                            [self creatFooterButtonStatus:3 andIsIssue:1];
                            
                        }
                    }
                    
                    if (model.userId.intValue != [UserModel sharedModel].userId.intValue){
                        //                    不是发布人
                        if (model.assignStatus.intValue == 1) {
                            //                        待抢
                            [self creatFooterButtonStatus:1 andIsIssue:2];
                            
                        }else if(model.assignStatus.intValue == 2){
                            //                        已抢
                            [self creatFooterButtonStatus:2 andIsIssue:2];
                            
                        }else{
                            //                        结束
                            [self creatFooterButtonStatus:3 andIsIssue:2];
                            
                        }
                    }
                }
            }else{
              //  204
              NSLog(@"%@",[result getMessage]);
            }
        } else {
             _scrollView.contentSize = CGSizeMake(0,LandscapeNumber(_headerView.selfHight));
            NSLog(@"请求失败");
            NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"请求失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVc animated:YES completion:^{
                [alertVc dismissViewControllerAnimated:YES completion:nil];
            }];
        }
       [self loadingSubtractCount]; 
    }];
    
}
#pragma mark - 获取派工详情图片
//- (void)loadDerailImages{
//    
//    NSString *url = [NSString stringWithFormat:@"%@?id=%zd",API_GET_ASSIGN_GETIMAGE,_ID];
//    NSLog(@"派工详情图片....URL=%@",url);
//    AINetworkEngine * manger = [AINetworkEngine sharedClient];
//   [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
//    if (result != nil) {
//        if ([result isSucceed]) {
//            
//            //                NSMutableArray *list = [NSMutableArray array];
//            NSArray *arr = [result getDataObj];
//            NSMutableArray *arrM = [NSMutableArray array];
//            for (NSDictionary *dict in arr) {
//                PaiModel *model = [PaiModel modelWithDictionary:dict];
//                [arrM addObject:model.downUrl];
//            }
////            PaiModel *model = [PaiModel modelWithDictionary:dict];
//            //                    [list addObject:model];
//            
//            //                self.dataSourse = list;
//            
//            [_headerView setCycleScrollViewImage:arrM];
//
//        }else{
//            //204
//            NSLog(@"%@",[result getMessage]);
//        }
//        
//    }else{
//        _showError.label.text = @"网络故障";
//        [_showError showAnimated:YES];
//        [_showError hideAnimated:YES afterDelay:0.5];
//
//    }
//}];
//    
//}

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
                if (_refreshBlcok) {
                    _refreshBlcok();
                }
                NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"抢单成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertVc animated:YES completion:^{
                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [_btn setTitle:@"交付派工" forState:UIControlStateNormal];
                _btn.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:22.0/255.0 blue:41.0/255.0 alpha:1];
                [_btn addTarget:self action:@selector(clickShopEvent:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 派工验收确认
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
                if (_refreshBlcok) {
                    _refreshBlcok();
                }
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
#pragma mark - 派工交付确认
- (void)loadShellOut{
    if(![UserModel isLogin]){
        NSLog(@"请先登录");
        NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:^{
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    UserModel *userModel = [UserModel sharedModel];
    NSString *url = [NSString stringWithFormat:@"%@?id=%d&userId=%@",API_GET_ASSIGN_DELIVERY,self.ID,userModel.userId];
    NSLog(@"URL=%@",url);
    //    NSString *ID = [NSString stringWithFormat:@"%d",self.ID];
    //    NSDictionary *parameter = @{@"id":ID,@"userId":userModel.id};
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                if (_refreshBlcok) {
                    _refreshBlcok();
                }
                    NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:@"交付成功" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertVc animated:YES completion:^{
                        [alertVc dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    [_btn setTitle:@"已交付" forState:UIControlStateNormal];
                    _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
                    _btn.userInteractionEnabled = NO;
                    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    NSLog(@"交付成功");
                
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

#pragma mark - 优秀技术达人列表
- (void)loadExpertList{
    
    NSString *url = [NSString stringWithFormat:@"%@",API_GET_USER_GETUSER];
    NSLog(@"优秀技术达人列表....URL=%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            if ([result isSucceed]) {
                NSArray *arr = [result getDataObj];
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    [arrM addObject:[PaiModel modelWithDictionary:dict]];
                }
                _dataArr = arrM;
                [_collectionView reloadData];
            }else{
                NSLog(@"%@",[result getMessage]);
            }
            
        }else{
            
            _showError.label.text = @"网络故障";
            [_showError showAnimated:YES];
            [_showError hideAnimated:YES afterDelay:0.5];

        }
        
    }];
}
- (void)setUpUi{
    __weak typeof(self)weakSelf = self;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.contentSize = CGSizeMake(0, 900);
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_scrollView];
    CustomDetailHeaderView *headerView = [[CustomDetailHeaderView alloc]init];
    [_scrollView addSubview:headerView];
    _headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.top.equalTo(_scrollView);
        make.height.mas_equalTo(LandscapeNumber(300));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(LandscapeNumber(130),LandscapeNumber(261));
    flowLayout.sectionInset = UIEdgeInsetsMake(LandscapeNumber(10), 10, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 261) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.top.equalTo(_headerView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,LandscapeNumber(261)));
    }];
    
}

- (void)creatFooterButtonStatus:(int)status andIsIssue:(int)isIssue{
    _btn = [[UIButton alloc]init];
    [_scrollView addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.top.equalTo(_collectionView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, LandscapeNumber(51)));
    }];
    
    if (isIssue == 0) {
        //                    是抢单人
        if(status == 2){
            //                        待交付
            [_btn setTitle:@"交付派工" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:22.0/255.0 blue:41.0/255.0 alpha:1];
            [_btn addTarget:self action:@selector(clickShopEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            //                        结束
            [_btn setTitle:@"已交付" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
            _btn.userInteractionEnabled = NO;
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        

    }else if (isIssue == 1) {
        //                    是发布人
        if (status == 1) {
            //                        待抢
//            _btn = [[UIButton alloc]init];
            [_btn setTitle:@"待抢单" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
            _btn.userInteractionEnabled = NO;
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else if(status == 2){
            //                        已抢
//            _btn = [[UIButton alloc]init];
            [_btn setTitle:@"派工进行中" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
            _btn.userInteractionEnabled = NO;
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if(status == 3){
            //                        交付中
            //            _btn = [[UIButton alloc]init];
            _btn.tag = 1001;
            [_btn setTitle:@"待验收" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:22.0/255.0 blue:41.0/255.0 alpha:1];
            [_btn addTarget:self action:@selector(clickShopEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            //                        结束
//            _btn = [[UIButton alloc]init];
            [_btn setTitle:@"验收完毕" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
            _btn.userInteractionEnabled = NO;
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
    }else{
        //                    不是发布人
        if (status == 1) {
            //                        待抢
//            _btn = [[UIButton alloc]init];
            [_btn setTitle:@"立即抢单" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:22.0/255.0 blue:41.0/255.0 alpha:1];
            [_btn addTarget:self action:@selector(clickPromptlyShopEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if(status == 2){
            //                        已抢
//            _btn = [[UIButton alloc]init];
            [_btn setTitle:@"派工进行中" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
            _btn.userInteractionEnabled = NO;
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            //                        结束
//            _btn = [[UIButton alloc]init];
            [_btn setTitle:@"派工已结束" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1];
            _btn.userInteractionEnabled = NO;
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCaseCollectionViewCell *cell = [DetailCaseCollectionViewCell cell:collectionView indexPath:indexPath];
    cell.model = _dataArr[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PaiModel *model = _dataArr[indexPath.item];
    SkillIntelligentViewController *vc = [[SkillIntelligentViewController alloc]init];
    vc.ID = model.id.intValue;
    vc.resourceId = _detailModel.id.intValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 立即抢单
- (void)clickPromptlyShopEvent:(UIButton*)sender{
    NSLog(@"立即抢单");
    //    抢单
    [self loadDispatchingRobSingleData];
}
#pragma mark - 验收or交付
- (void)clickShopEvent:(UIButton*)sender{
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
            [self loadShellOut];
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

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
