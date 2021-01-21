//
//  JieJueDetailShuoMingViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueDetailShuoMingViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GlobleFunction.h"

#import "DetailsBaseInfoView.h"
#import "DetailsMiddleView.h"
#import "DetailsBuyView.h"

#import "PreviewViewController.h"
#import "WatchOnlineViewController.h"
#import "ChanPinDetailsViewController.h"
#import "RelateProductViewController.h"
#import "ChoosePaymentViewController.h"
#import "ChargeViewController.h"
#import "KeyProjectDetailsViewController.h"
#import "ProtocolPDFViewController.h"
#import "NoAutorotateAlertController.h"

#import "BuyPackageModel.h"
#import "OrderModel.h"
#import "PlanDetailsModel.h"
#import "PlanSimpleModel.h"
#import "PKCCollectionCell.h"
#import "ProtocolModel.h"

static NSString *tableViewReuseIdentifier = @"UITableViewCell";
static NSString *collectionViewReuseIdentifier = @"UICollectionViewCell";

// 底部工具条高度
#define kTOOLHEIGHT 50.f

// 导航栏高度 + 状态栏高度
#define kSTATUSBAR_NAVIGATION_HEIGHT (STATUSBARHEIGHT + NAVBARHEIGHT)


@interface JieJueDetailShuoMingViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,SDCycleScrollViewDelegate, WKNavigationDelegate>

/** 商品详情整体 */
@property(strong,nonatomic) UIScrollView *scrollView;

/** 第一页背景视图 */
@property (strong,nonatomic) UIScrollView *firsePageScrollView;
/** 轮播图 */
@property (strong, nonatomic) SDCycleScrollView *cycleView;
// 上面基本信息
@property (strong, nonatomic) DetailsBaseInfoView *baseInfoView;
// 详细说明全部评价
@property (strong, nonatomic) DetailsMiddleView *middleView;
// 点击购买弹出的视图
@property (strong, nonatomic) DetailsBuyView *buyView;

/** 第二页 */
@property (strong, nonatomic) UIView *twoPageView;
/** 网页 */
@property (strong,nonatomic)  WKWebView *webView;

/** 推荐商品视图 */
/** 成功案例 */
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *goodsDetailButton;

@property (strong, nonatomic) UIButton *buyButton;
@property (strong, nonatomic) UIButton *watchOnlineButton;
@property (strong, nonatomic) UIButton *previewButton;

@property (strong, nonatomic) NSMutableArray *productArray;
@property (strong, nonatomic) NSMutableArray *packageArray;
@property (strong, nonatomic) OrderModel *orderModel;
@property (strong, nonatomic) PlanSimpleModel *simpleModel;
@property (strong, nonatomic) PlanDetailsModel *detailsModel;


@property (strong, nonatomic) UIView *infoView; //提示用户付款页面

@end

@implementation JieJueDetailShuoMingViewController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
    //    [self configureRefresh];
    [self loadDetails];
    [self loadPlanSimaple];
    //    [self loadPackage];
}

// 获取解决方案简单信息
- (void)loadPlanSimaple {
    NSString *url = [NSString stringWithFormat:@"%@%@%@",DOMAIN_NAME, API_GET_SLOUTION_SIMPLE, self.id];
    NSLog(@".......%@",url);
    if ([UserModel isLogin]) {
        [[AINetworkEngine sharedClient]  setRequestHeaderValue:[[UserModel sharedModel] userId] headerKey:@"userId"];
    }
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSDictionary *data = [result getDataObj];
                self.simpleModel = [PlanSimpleModel modelWithDictionary:data];
                [self refresh];
            }
        } else {
            NSLog(@"1—————————请求失败—————————");
        }
    }];
}

// 获取解决方案详细信息
- (void)loadDetails {
    NSString *url = [NSString stringWithFormat:@"%@%@%@",DOMAIN_NAME, API_GET_SLOUTION_DETAILS_NEW, self.id];
    NSLog(@".......%@",url);
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSDictionary *data = [result getDataObj];
                self.detailsModel = [PlanDetailsModel modelWithDictionary:data];
                [self refresh];
            }
        } else {
            NSLog(@"2—————————请求失败—————————");
        }
    }];
}


/**
 点赞或踩
 
 @param type 1赞  2踩
 */
- (void)evaluateSolutionWithType:(NSString *)type {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:2.f];
        return;
    }
    [self showLoadingToView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[@"id"] = _id;
    dict[@"userId"] = [[UserModel sharedModel] userId];
    dict[@"type"] = type;
    [[AINetworkEngine sharedClient] postWithApi:API_POST_SLOUTION_ADDTHUMBS parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result) {
            if (result.isSucceed) {
                [self loadPlanSimaple];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        }
    }];
}

#pragma mark: 收藏接口
- (void)favorite {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:2.f];
        self.baseInfoView.favoriteBtn.userInteractionEnabled = true;
        return;
    }
    [self showLoadingToView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[@"goodsid"] = _id;
    dict[@"userid"] = [[UserModel sharedModel] userId];
    dict[@"goosType"] = @"1";
    [[AINetworkEngine sharedClient] postWithApi:API_POST_FAVORITE parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result) {
            if (result.isSucceed) {
                self.simpleModel.isCollent = @1;
                self.baseInfoView.favoriteBtn.selected = true;
                [self showSuccess:self.view message:@"收藏成功" afterHidden:1.5];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        }
        self.baseInfoView.favoriteBtn.userInteractionEnabled = true;
    }];
}

#pragma mark: 取消收藏接口
- (void)cancelFavorite {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:2.f];
        self.baseInfoView.favoriteBtn.userInteractionEnabled = true;
        return;
    }
    [self showLoadingToView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[@"goodsid"] = _id;
    dict[@"userid"] = [[UserModel sharedModel] userId];
    dict[@"goosType"] = @"1";
    [[AINetworkEngine sharedClient] postWithApi:API_POST_CANCEL_FAVORITE parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result) {
            if (result.isSucceed) {
                self.simpleModel.isCollent = @0;
                self.baseInfoView.favoriteBtn.selected = false;
                [self showSuccess:self.view message:@"已取消收藏" afterHidden:1.5];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        }
        self.baseInfoView.favoriteBtn.userInteractionEnabled = true;
    }];
}

- (void)buySloutionOrder {
    NSString *url = API_POST_SLOUTION_ORDER_NEW;
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithCapacity:2];
    muDict[@"userId"] = [[UserModel sharedModel] userId];
    muDict[@"solutionId"] = _id;
    muDict[@"checkbox"] = @"1";
    
    [self showLoadingToView:self.view];
    [[AINetworkEngine sharedClient] postWithApi:url parameters:muDict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                [self payAlert:result.getDataObj];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        } else {
            [self showError:self.view message:@"请求失败，请稍后再试" afterHidden:2.f];
        }
        [self hiddenLoading];
    }];
}

- (void)payAlert:(NSString *)orderSn {
    NoAutorotateAlertController *alertVC = [NoAutorotateAlertController alertControllerWithTitle:@"下单成功，确定支付吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self buySolution:orderSn];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:true completion:nil];
}

- (void)buySolution:(NSString *)orderSn {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithCapacity:2];
    muDict[@"userId"] = [[UserModel sharedModel] userId];
    muDict[@"orderSn"] = orderSn;
    [self showLoadingToView:self.view];
    [[AINetworkEngine sharedClient] postWithApi:API_POST_SLOUTION_BUY_NEW parameters:muDict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.getCode == 1000) {
                [self showSuccess:self.view message:@"购买成功" afterHidden:2];
            } else if (result.getCode == 1002) {
                [self alertNotSufficientFunds];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        }
        [self hiddenLoading];
    }];
}

- (void)alertNotSufficientFunds {
    NoAutorotateAlertController *alertVC = [NoAutorotateAlertController alertControllerWithTitle:@"余额不足，去充值？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self popChargeController];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:true completion:nil];
}

// 获取方案套餐
- (void)loadPackage {
    //    NSString *url = [NSString stringWithFormat:@"%@?solutionId=875", API_GET_SLOUTION_PACKAGE];//, self.id
    //    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
    //        if (result) {
    //            if ([result getCode] == 1) {
    //                NSMutableArray *list = [NSMutableArray array];
    //                NSMutableArray *titles = [NSMutableArray array];
    //                NSArray *array = [result getDataObj];
    //                for (int i = 0; i < array.count; i++) {
    //                    BuyPackageModel *model = [BuyPackageModel modelWithDictionary:array[i]];
    //                    [list addObject:model];
    //                    [titles addObject:model.name];
    //                }
    //                self.packageArray = list;
    //                [self.buyView addPackage:titles];
    //            }
    //        } else {
    //            NSLog(@"—————————请求失败—————————");
    //        }
    //    }];
    NSString *url = [NSString stringWithFormat:@"%@%@?solutionId=875",DOMAIN_NAME,API_GET_SLOUTION_PACKAGE];
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        NSArray *arr = [dict objectForKey:@"solutionPkgs"];
        
        NSMutableArray *list = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        
        for (NSDictionary *dic in arr) {
            BuyPackageModel *model = [BuyPackageModel modelWithDictionary:dic];
            [list addObject:model];
            [titles addObject:model.name];
        }
        self.packageArray = list;
        [self.buyView addPackage:titles];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"3—————————请求失败—————————%@",error.userInfo);
    }];
}

// 购买,业务下单
- (void)order:(NSString *)packageId number:(NSInteger)number {
    NSString *userId = @"201";
    
    NSString *url = API_GET_SLOUTION_BUY;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = @875;//self.id;
    params[@"pkgId"] = packageId;
    params[@"userId"] = userId;
    params[@"num"] = [NSString stringWithFormat:@"%zd", number];
    NSLog(@"%@",params);
    
    [self loadingAddCountToView:self.buyView];
    AINetworkEngine *netWork = [AINetworkEngine sharedClient];
    netWork.responseSerializer = [AFJSONResponseSerializer serializer];
    netWork.requestSerializer = [AFHTTPRequestSerializer serializer];
    [netWork postWithApi:url parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self loadingSubtractCount];
        if (result) {
            if ([result getCode] == 1000) {
                NSDictionary *dict = [result getDataObj];
                self.orderModel = [OrderModel modelWithDictionary:dict];
                [self.buyView removeFromSuperview];
                ChoosePaymentViewController *vc = [[ChoosePaymentViewController alloc] init];
                vc.id  = self.id;
                //                vc.unitPrice = self.jieJueModel.price.floatValue;
                vc.count = number;
                vc.orderModel = self.orderModel;
                [self pushControllerHiddenTabbar:vc];
            } else {
                NSLog(@"nonononono~~~~~~");
            }
        } else {
            NSLog(@"4—————————请求失败—————————");
        }
    }];
    
    //微信支付================
}

// 刷新
- (void)refresh {
    self.buyButton.backgroundColor = MainColor;
    self.buyButton.enabled = YES;
    self.cycleView.imageURLStringsGroup = _simpleModel.coverImg;
    [self.baseInfoView refresh:_detailsModel.name
                        source:@"" orderCount:_simpleModel.orderCount.stringValue
                       comment:_simpleModel.goodsCount.stringValue
                complaintCount:_simpleModel.badsCount.stringValue
                    isFavorite:_simpleModel.isCollent.boolValue];
    [_collectionView reloadData];
    //    [_webView loadRequest:[self getHtmlURL]];
    
}


#pragma mark - addSubView
- (void)addSubView {
    [self.view    addSubview:self.scrollView];
//    [self.view    addSubview:self.buyButton];
//    [self.view    addSubview:self.watchOnlineButton];
//    [self.view    addSubview:self.previewButton];
    [self addBottomView];
    [self.scrollView addSubview:self.firsePageScrollView];
    
    [self.scrollView  addSubview:self.twoPageView];
    [self.twoPageView addSubview:self.webView];
    [self.twoPageView addSubview:self.goodsDetailButton];
    [self.firsePageScrollView addSubview:self.cycleView];
    [self.firsePageScrollView addSubview:self.collectionView];
    
    [self.firsePageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT - kSTATUSBAR_NAVIGATION_HEIGHT - kTOOLHEIGHT);
    }];
    
    __weak typeof(self) weakSelf = self;
    _baseInfoView = [DetailsBaseInfoView createToSuperView:self.firsePageScrollView];
    [_baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(SCREEN_WIDTH*234/375);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    _baseInfoView.pingLunBlock = ^(NSString *type) {
        [weakSelf evaluateSolutionWithType:type];
    };
    _baseInfoView.favoriteBlock = ^{
        if (weakSelf.simpleModel.isCollent.boolValue) {
            [weakSelf cancelFavorite];
        } else {
            [weakSelf favorite];
        }
    };
    _middleView = [DetailsMiddleView createToSuperView:self.firsePageScrollView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_baseInfoView.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_middleView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(140.f);
        make.bottom.mas_equalTo(-10);
    }];
    
    _middleView.allCaseBlock = ^() {
        RelateProductViewController *vc = [[RelateProductViewController alloc] init];
        vc.id = weakSelf.id;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)configureRefresh {
    // 动画时间
    CGFloat duration = 0.3f;
    
    // 1.设置 UITableView 上拉显示商品详情
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.height);
        } completion:^(BOOL finished) {
            [self.firsePageScrollView.mj_footer endRefreshing];
        }];
    }];
    footer.automaticallyHidden = NO; // 关闭自动隐藏(若为YES，cell无数据时，不会执行上拉操作)
    [footer setTitle:@"上拉查看图文详情" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStatePulling];
    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStateRefreshing];
    self.firsePageScrollView.mj_footer = footer;
    
    
    // 2.设置 WebView 下拉显示商品详情
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //设置动画效果
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            //结束加载
            [self.webView.scrollView.mj_header endRefreshing];
        }];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置文字、颜色、字体
    [header setTitle:@"下拉，返回商品简介" forState:MJRefreshStateIdle];
    [header setTitle:@"释放，返回商品简介" forState:MJRefreshStatePulling];
    [header setTitle:@"释放，返回商品简介" forState:MJRefreshStateRefreshing];
    self.webView.scrollView.mj_header = header;
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PDFDEMOURL]]];//PDFDEMOURL
}


#pragma mark - Lazy Methods
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kSTATUSBAR_NAVIGATION_HEIGHT - kTOOLHEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT - kSTATUSBAR_NAVIGATION_HEIGHT) * 2);
        _scrollView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (UIScrollView *)firsePageScrollView {
    if (!_firsePageScrollView) {
        _firsePageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kSTATUSBAR_NAVIGATION_HEIGHT - kTOOLHEIGHT)];
        _firsePageScrollView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
    return _firsePageScrollView;
}

#pragma mark - Lazy Methods 轮播图
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*234/375) delegate:self placeholderImage:[UIImage imageNamed:@"详情大图默认图"]];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
    }
    return _cycleView;
}

- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.frame = CGRectMake((SCREEN_WIDTH-45)/3*2+30, 5, (SCREEN_WIDTH-45)/3, 40);
        _buyButton.backgroundColor = MainColor;
        _buyButton.enabled = false;
        _buyButton.titleLabel.numberOfLines = 0;
        _buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *price = [NSString stringWithFormat:@"完整版购买\n(%.2f元)", _price];
        [_buyButton setTitle:price forState:UIControlStateNormal];//购买方案
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _buyButton.layer.cornerRadius = 2;
        _buyButton.clipsToBounds = true;
        //        _buyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_buyButton addTarget:self
                       action:@selector(buyClick)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(150.f, 100.f);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.webView.frame collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

#pragma -mark collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _simpleModel.pkgModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PKCCollectionCell *cell = [PKCCollectionCell createNibCell:collectionView indexPath:indexPath];
    [cell configWithPKG:_simpleModel.pkgModels[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.5];
        return;
    }
    
    KeyProjectDetailsViewController *vc = [[KeyProjectDetailsViewController alloc] init];
    vc.keyProjectId = [[_simpleModel.pkgModels[indexPath.row] id] stringValue];
    vc.solutionId = _id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:true];
    
//    ChanPinDetailsViewController *vc = [[ChanPinDetailsViewController alloc] init];
//    JieJueModel *model = self.productArray[indexPath.row];
//    vc.id = model.id.stringValue;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:true];
}

#pragma -mark 购买方案点击
-(void)buyClick{
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.5];
        return;
    }
    [self loadProtocol];
//    [self buySloutionOrder];
}

- (void)loadProtocol {
    [self showLoadingToView:App_Delegate.window];
    NSString *url = API_GET_BUY_SOLUTION_PROTOCOL;
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
                UIAlertAction *buyAction = [UIAlertAction actionWithTitle:@"同意协议并购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self buySloutionOrder];
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


// 用户余额检查，余额足，购买不足跳转充值页
-(void)checkUserBalance:(BuyPackageModel *)package buyCount:(NSInteger)buyCount {
    if (![UserModel isLogin]) return;
    [self loadingAddCountToView:self.buyView];
    NSString *url = [NSString stringWithFormat:@"%@v1/user/getUsers?id=%@",DOMAIN_NAME,[UserModel sharedModel].userId];
    NSLog(@"%@",url);
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                dic = [NSDictionary changeType:dic];
                UserBaseInfoModel *model = [UserBaseInfoModel modelWithDictionary:dic];
                if (model.wallet.floatValue > package.price.floatValue*buyCount) {
                    // 下单
                    [self order:package.id.stringValue number:buyCount];
                } else {
                    [self popChargeController];
                }
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2];
            }
        }else{
            [self showError:self.view message:@"请求失败" afterHidden:2];
        }
        [self loadingSubtractCount];
    }];
}

// 跳转到充值页
- (void)popChargeController {
    ChargeViewController *chargeVC = [[ChargeViewController alloc] init];
    chargeVC.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:chargeVC animated:true];
}

#pragma -mark lazy 购买视图
- (DetailsBuyView *)buyView {
    if (!_buyView) {
        _buyView = [DetailsBuyView createToSuperView:[[UIApplication sharedApplication] keyWindow]];
        _buyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
#pragma mark 弹出购买视图后，点击立即购买响应
        __weak JieJueDetailShuoMingViewController *weakSelf = self;
        /**
         *  @param packageIndex 套餐序号, 从0开始
         *  @param buyCount     购买数量
         */
        _buyView.buyBlock = ^(NSInteger packageIndex, NSInteger buyCount){
            NSLog(@"%zd, %zd", packageIndex, buyCount);
            
            if (weakSelf.packageArray == nil || weakSelf.packageArray.count == 0) {
                [weakSelf showError:weakSelf.buyView message:@"请先选择套餐" afterHidden:2];
            } else {
                BuyPackageModel *model = weakSelf.packageArray[packageIndex];
                [weakSelf checkUserBalance:model buyCount:buyCount];
            }
        };
    }
    return  _buyView;
}

- (UIButton *)watchOnlineButton {
    if (!_watchOnlineButton) {
        _watchOnlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _watchOnlineButton.frame = CGRectMake((SCREEN_WIDTH-45)/3+22.5, 5, (SCREEN_WIDTH-45)/3, 40);
        _watchOnlineButton.backgroundColor = UIColorFromRGB(0xF6F6F6);
        [_watchOnlineButton setTitle:@"完整版解决方案" forState:UIControlStateNormal];//在线查看
        [_watchOnlineButton setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
        _watchOnlineButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _watchOnlineButton.layer.cornerRadius = 2;
        _watchOnlineButton.clipsToBounds = true;
//        _watchOnlineButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_watchOnlineButton addTarget:self
                               action:@selector(watchOnlineClick)
                     forControlEvents:UIControlEventTouchUpInside];
//        _watchOnlineButton.layer.borderColor =UIColorFromRGB(0x989898).CGColor;
//        _watchOnlineButton.layer.borderWidth = .3f;
        
    }
    return _watchOnlineButton;
}
#pragma -mark 在线查看点击
-(void)watchOnlineClick{
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.5];
        return;
    }
    NSString *url = API_POST_COMPLETE_SLOUTION_PDF;
    [self showLoadingToView:self.view];
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithCapacity:2];
    muDict[@"userId"] = [[UserModel sharedModel] userId];
    muDict[@"solutionId"] = _id;
    [[AINetworkEngine sharedClient] postWithApi:url parameters:muDict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                NSArray *PDFs = [result getDataObj];
                NSDictionary *dict = [PDFs firstObject];
                if ([dict.allKeys containsObject:@"pdfPath"]) {
                    WatchOnlineViewController *vc = [[WatchOnlineViewController alloc] init];
                    vc.url = dict[@"pdfPath"];
                    vc.hidesBottomBarWhenPushed = true;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        } else {
            
        }
        [self hiddenLoading];
    }];
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _infoView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIView *whiteView = [[UIView alloc]init];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 4;
        whiteView.backgroundColor = [UIColor whiteColor];
        [_infoView addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_infoView.mas_centerX);
            make.centerY.mas_equalTo(_infoView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, SCREEN_WIDTH/2));
        }];
        
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [whiteView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(whiteView.mas_top);
            make.left.mas_equalTo(whiteView.mas_left);
            make.right.mas_equalTo(whiteView.mas_right);
            make.height.mas_equalTo(60);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"信息";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16];
        [topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.left.mas_equalTo(topView.mas_left).offset(10);
        }];
        
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"选择付款人？";
        label1.textColor = [UIColor grayColor];
        label1.font = [UIFont systemFontOfSize:16];
        [whiteView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).offset(20);
            make.left.mas_equalTo(whiteView.mas_left).offset(10);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = UIColorFromRGB(0xD71629);;
        [btn setTitle:@"自己付款" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        [btn addTarget:self action:@selector(clickPayByMyselfBtn) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(whiteView.mas_centerX).offset(-10);
            make.bottom.mas_equalTo(whiteView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
        
        UIButton *btn1 = [[UIButton alloc]init];
        btn1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [btn1 setTitle:@"方案商付款" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        btn1.layer.masksToBounds = YES;
        btn1.layer.cornerRadius = 4;
        [btn1 addTarget:self action:@selector(clickPayByBuyerBtn) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(whiteView.mas_centerX).offset(10);
            make.bottom.mas_equalTo(whiteView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
        
    }
    return _infoView;
}
//选择自己付款
- (void)clickPayByMyselfBtn {
    [self.infoView removeFromSuperview];
}
//选择方案商付款
- (void)clickPayByBuyerBtn {
    [self.infoView removeFromSuperview];
}

- (void)addBottomView {
    UIView *boView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), SCREEN_WIDTH, kTOOLHEIGHT)];
    boView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:boView];
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    sepLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [boView addSubview:sepLine];
    [boView addSubview:self.previewButton];
    [boView addSubview:self.watchOnlineButton];
    [boView addSubview:self.buyButton];
}

- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.frame = CGRectMake(15, 5, (SCREEN_WIDTH-45)/3, 40);
        _previewButton.backgroundColor = UIColorFromRGB(0xF6F6F6);
        [_previewButton setTitle:@"简版解决方案" forState:UIControlStateNormal];//方案预览
        [_previewButton setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _previewButton.layer.cornerRadius = 2;
        _previewButton.clipsToBounds = true;
//        _previewButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_previewButton addTarget:self
                           action:@selector(previewClick)
                 forControlEvents:UIControlEventTouchUpInside];
//        _previewButton.layer.borderColor =UIColorFromRGB(0x989898).CGColor;
//        _previewButton.layer.borderWidth = .3f;
    }
    return _previewButton;
}

#pragma -mark 方案预览点击
-(void)previewClick{
    NSString *url = [NSString stringWithFormat:@"%@?solutionId=%@", API_GET_SIMPLE_SLOUTION_PDF, _id];
    [self showLoadingToView:self.view];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                NSArray *PDFs = [result getDataObj];
                NSDictionary *dict = [PDFs firstObject];
                if ([dict.allKeys containsObject:@"jpdfPath"]) {
                    PreviewViewController *vc = [[PreviewViewController alloc]init];
                    vc.url = dict[@"jpdfPath"];
                    vc.hidesBottomBarWhenPushed = true;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        } else {
            
        }
        [self hiddenLoading];
    }];
}

#pragma mark - 第二页
- (UIView *)twoPageView {
    if (!_twoPageView) {
        _twoPageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.height, self.scrollView.width, self.scrollView.height)];
    }
    return _twoPageView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsDetailButton.frame), self.scrollView.width, self.scrollView.height - self.goodsDetailButton.height) configuration:[WKWebViewConfiguration new]];
        _webView.backgroundColor =[UIColor whiteColor];
        _webView.navigationDelegate = self;
    }
    return _webView;
}


#pragma mark - 第二页 WebView 加载本地模板
// webView加载完后执行脚本

#pragma -mark js回调
//js回调函数



//通知新类容页面的html格式化模板加载
#pragma -mark 通知新类容页面的html格式化模板加载
- (NSURLRequest *) getHtmlURL
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"news_detail" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    return urlRequest;
}
#pragma -mark JS脚本

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
