//
//  ChanPinDetailsChanPinController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinDetailsChanPinController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

#import "ChanPinDetailsBaseInfoView.h" 
#import "ChanPinDetailsMiddleVeiw.h"
#import "SuccessCaseCollectionViewCell.h"
#import "AllSuccessCaseViewController.h"
#import "JieJueDetailsViewController.h"
#import "RelateSolutionViewController.h"

#import "JieJueModel.h"
#import "DetailsPictureModel.h"
#import <WebKit/WebKit.h>

// 底部工具条高度
#define kTOOLHEIGHT 50.f
// 导航栏高度 + 状态栏高度
#define kSTATUSBAR_NAVIGATION_HEIGHT (STATUSBARHEIGHT + NAVBARHEIGHT)


@interface ChanPinDetailsChanPinController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate, WKNavigationDelegate>
/** 商品详情整体 */
@property(strong,nonatomic)UIScrollView *scrollView;

/** 第一页背景视图 */
@property(strong,nonatomic)UIScrollView *firsePageScrollView;
/** 轮播图 */
@property (nonatomic, strong)SDCycleScrollView *cycleView;
// 上面基本信息
@property (nonatomic, strong) ChanPinDetailsBaseInfoView *baseInfoView;
// 详细说明全部评价
@property (nonatomic, strong) ChanPinDetailsMiddleVeiw *middleView;

/** 第二页 */
@property (nonatomic, strong) UIView *twoPageView;
/** 网页 */
@property (strong,nonatomic)  WKWebView *webView;

/** 推荐商品视图 */
/** 成功案例 */
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JieJueModel *jieJueModel;
@property (strong, nonatomic) NSMutableArray *solutionArray;
@property (strong, nonatomic) NSMutableArray *topImageArray;
@end

@implementation ChanPinDetailsChanPinController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
    [self configureRefresh];
    [self loadDetails];
    [self loadReleteSolution];
    [self loadPicture];
}

// 从服务器获取解决方案详情
- (void)loadDetails {
    NSString *url = [NSString stringWithFormat:@"%@%@", API_GET_PRODUCT_DETAILS, self.id];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSDictionary *data = [result getDataObj];
                self.jieJueModel = [JieJueModel modelWithDictionary:data];
                [self.baseInfoView refresh:self.jieJueModel.name
                                    source:self.jieJueModel.companyName
                                   bianHao:self.jieJueModel.productNo
                                    huoHao:self.jieJueModel.cargoNo];
                [_webView loadRequest:[self getHtmlURL]];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}

// 获取相关解决方案
- (void)loadReleteSolution {
    NSString *url = [NSString stringWithFormat:@"%@?solutionId=%@", API_GET_SLOUTION_ABOUT_PROFUCT, self.id];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    JieJueModel *model = [JieJueModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.solutionArray = list;
                [self.collectionView reloadData];
            }
        } else {
            NSLog(@"—————————请求失败—————————");
        }
    }];
}

// 获取轮播图
- (void)loadPicture {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@", API_GET_PRODUCT_PICTURE, self.id];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSMutableArray *imageURLs = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    DetailsPictureModel *model = [DetailsPictureModel modelWithDictionary:array[i]];
                    [list addObject:model];
                    [imageURLs addObject:model.image];
                }
                self.topImageArray = list;
                self.cycleView.imageURLStringsGroup = imageURLs;
            }

        } else {
            NSLog(@"—————————轮播图,请求失败—————————");
        }
    }];
}

#pragma mark - addSubView
- (void)addSubView {
    [self.view    addSubview:self.scrollView];
    [self.scrollView addSubview:self.firsePageScrollView];
    [self.scrollView  addSubview:self.twoPageView];
    [self.twoPageView addSubview:self.webView];
    [self.firsePageScrollView addSubview:self.cycleView];
    [self.firsePageScrollView addSubview:self.collectionView];
    
    [self.firsePageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT-kSTATUSBAR_NAVIGATION_HEIGHT);
    }];
    _baseInfoView = [ChanPinDetailsBaseInfoView createToSuperView:self.firsePageScrollView];
    [_baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(SCREEN_WIDTH*234/375);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    _middleView = [ChanPinDetailsMiddleVeiw createToSuperView:self.firsePageScrollView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_baseInfoView.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_middleView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(255);
        make.bottom.mas_equalTo(0);
    }];
    
    __weak ChanPinDetailsChanPinController *weakSelf = self;
    _middleView.allCaseBlock = ^() {
        RelateSolutionViewController *vc = [[RelateSolutionViewController alloc] init];
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
}


#pragma mark - Lazy Methods
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kSTATUSBAR_NAVIGATION_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT - kSTATUSBAR_NAVIGATION_HEIGHT) * 2);
        _scrollView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (UIScrollView *)firsePageScrollView {
    if (!_firsePageScrollView) {
        _firsePageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kSTATUSBAR_NAVIGATION_HEIGHT - kTOOLHEIGHT)];
        _firsePageScrollView.backgroundColor = UIColorFromRGB(0xF8F8F8);
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


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(130, 240);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.webView.frame collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator= NO;
    }
    return _collectionView;
}

#pragma -mark collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.solutionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SuccessCaseCollectionViewCell *cell = [SuccessCaseCollectionViewCell cell:collectionView indexPath:indexPath];
    [cell refreshCell:self.solutionArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc] init];
    JieJueModel *model = self.solutionArray[indexPath.row];
    vc.id = model.id.stringValue;
    [self pushControllerHiddenTabbar:vc];
    NSLog(@"%ld", (long)indexPath.row);
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
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        _webView.backgroundColor =[UIColor whiteColor];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

#pragma mark - 第二页 WebView 加载本地模板
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *content = self.jieJueModel.desp;
    content = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</br>"];
    content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"setTitle('%@')", self.jieJueModel.name] completionHandler:nil];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"setContent(\"%@\")", content] completionHandler:nil];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"setSource('产品来源：%@')" , self.jieJueModel.companyName] completionHandler:nil];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"setPuttime('发布时间：%@')" , self.jieJueModel.createTime] completionHandler:nil];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"setFontSize(%@)" , [[NSUserDefaults standardUserDefaults] valueForKey:@"fontSize"]] completionHandler:nil];
}

#pragma -mark js回调

//通知新类容页面的html格式化模板加载
#pragma -mark 通知新类容页面的html格式化模板加载
- (NSURLRequest *) getHtmlURL
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"news_detail" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    return urlRequest;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
