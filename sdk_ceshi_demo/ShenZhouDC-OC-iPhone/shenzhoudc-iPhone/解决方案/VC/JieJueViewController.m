//
//  JieJueViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueViewController.h"
#import "SDCycleScrollView.h"
#import "JieJueMoreViewController.h"
#import "JieJueDetailsViewController.h"
#import "AINetworkEngine.h"
#import "JieJueTableViewCell.h"
#import "NetAPI.h"
#import "JieJueModel.h"
#import "ADSModel.h"
//导入头文件
#import "ScanViewController.h"
#import "LBXScanViewController.h"
#import "PlanModel.h"
#import "SearchViewController.h"
#import "TestView.h"

//#import "SubLBXScanViewController.h"


@interface JieJueViewController ()
@property (weak, nonatomic)   UITextView *textV;
@property (assign, nonatomic) NSInteger index;

@end

@implementation JieJueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [TestView showToWindow];
    
    
        
    self.index = 1;
    [self loadJieJueList:@"1" loadWay:LoadListWayDefault];
    [self loadADSList];
    [self makeSearchBtn];
    [self makeScanBtn];
    
    
}

/** 导航栏搜索按钮 */
- (void)makeSearchBtn {
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 45, 30);
    [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)clickSearchBtn {
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = true;
    [self pushControllerHiddenTabbar:vc];
}

/** 导航栏扫码按钮 */
- (void)makeScanBtn {
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn setImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = item;
}
//扫码
-(void)scanClick{
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:2];
        return;
    }
    
    
    ScanViewController *vc = [ScanViewController new];
    vc.style = [JieJueViewController ZhiFuBaoStyle];
    vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
//    LBXScanViewController *vc = [[LBXScanViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    

}
#pragma mark --模仿支付宝
+ (LBXScanViewStyle*)ZhiFuBaoStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
//    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    style.animationImage = imgFullNet;
    
    return style;
}

- (void)loadJieJueList:(NSString *)type loadWay:(LoadListWay)loadWay{
    [self loadingAddCountToView:self.view];
    NSString *url =  [NSString stringWithFormat:@"%@?type=%@", API_GET_SOLUTION_LIST, type];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
//        [self.tableView.mj_header endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *dict = [result getDataObj];
                NSArray *array = dict[@"data"];
                for (int i = 0; i < array.count; i++) {
                    PlanModel *model = [PlanModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.dataSourse = list;
//                [self.tableView reloadData];
                [self.collectionView reloadData];
            }
        } else {
            NSLog(@"请求失败");
        }
        [self loadingSubtractCount];
    }];
}

// 获取广告列表
- (void)loadADSList {
    NSString *url = [NSString stringWithFormat:@"%@?type=1", API_GET_ADS_LIST];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *models = [NSMutableArray array];
                NSMutableArray *titles = [NSMutableArray array];
                NSMutableArray *images = [NSMutableArray array];
                NSArray *ads = [result getDataObj];
                for (int i = 0; i < ads.count; i++) {
                    ADSModel *model = [ADSModel modelWithDictionary:ads[i]];
                    [models addObject:model];
                    [titles addObject:model.title];
                    [images addObject:model.image];
                }
                self.adsArray = models;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            } else {
                
            }
        } else {
//            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}

//MARK: 重写父类的方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
    [cell refreshWithPlan:self.dataSourse[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    vc.price = model.price.floatValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pullRefresh {
    [self loadJieJueList:[NSString stringWithFormat:@"%zd", (long)self.index] loadWay:LoadListWayRefresh];
}

//点击头部标题响应事件
- (void)headerAction:(NSInteger)index {
    NSLog(@"方案----%ld", (long)index);
    self.index = index+1;
    [self loadJieJueList:[NSString stringWithFormat:@"%zd", self.index] loadWay:LoadListWayMore];
    
}

- (NSArray *)headerTitles {
    return @[@"最新方案" , @"推荐方案",  @"热门方案"];
}

- (NSString *)footerTitle {
    return @"更多方案";
}

- (void)moreClick {
    JieJueMoreViewController *vc = [[JieJueMoreViewController alloc]init];
    vc.type = @"1";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
