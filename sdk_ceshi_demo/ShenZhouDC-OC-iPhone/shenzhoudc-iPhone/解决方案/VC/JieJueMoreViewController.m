//
//  JieJueMoreViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueMoreViewController.h"
#import "CommonItemModel.h"
#import "SideSlipCommonTableViewCell.h"
#import "NetAPI.h"
//#import "JieJueModel.h"
#import "JieJueDetailsViewController.h"
#import "CommonItemModel.h"
#import "PlanModel.h"
#import "JieJueTableViewCell.h"
#import "CategoryModel.h"
#import "CollectionViewCell.h"

#define NOT_INDUSTRY_ID @"notInsdustryId"
#define ROW_CELL_COUNT  (IS_IPAD ? 4 : 2)
#define CELL_MARGIN     10

@interface JieJueMoreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 筛选行业id */
@property (copy, nonatomic)   NSString *industryId;
@property (copy, nonatomic)   NSArray *industryCategoryArray;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation JieJueMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.title = @"更多";
    [self configData];
    [self loadListData:LoadListWayDefault];
    [self makeCollectionView];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self pullRefresh];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _collectionView.mj_header = header;
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self pullLoadMore];
    }];
    footer.automaticallyHidden = NO;
    self.collectionView.mj_footer = footer;
    [self.view addSubview:_collectionView];
}

- (void)configData {
    _industryId = NOT_INDUSTRY_ID;
    self.headTitles = @[@"行业分类"];
//    1航天业  2房地产业  3餐饮业  4服装业  5服务业
    NSArray *array = @[@{@"id": @1, @"name": @"航天业"},
                       @{@"id": @2, @"name": @"房地产业"},
                       @{@"id": @3, @"name": @"餐饮业"},
                       @{@"id": @4, @"name": @"服装业"},
                       @{@"id": @5, @"name": @"服务业"}];
    NSMutableArray *industryArray = [NSMutableArray arrayWithCapacity:array.count];
    NSMutableArray *industryCategorys = [NSMutableArray arrayWithCapacity:array.count];
    for (NSUInteger i = 0; i < array.count; i++) {
        [industryArray addObject:[CategoryModel modelWithDictionary:array[i]]];
        [industryCategorys addObject:[CommonItemModel createModel:array[i] andKeyWord:@"行业分类"]];
    }
    _industryCategoryArray = industryArray;
    self.industryCategorys = industryCategorys;
    self.isPopScreen = true;
    [self makeZYSide];
}

// 加载列表数据
- (void)loadListData:(LoadListWay)loadWay {
    NSString *url =  [NSString stringWithFormat:@"%@?type=%@&pageNumber=%zd&pageSize=%d", API_GET_SOLUTION_LIST, _type, self.loadPage, LoadSize];
    if (![_industryId isEqualToString:NOT_INDUSTRY_ID]) {
        url = [NSString stringWithFormat:@"%@&industryId=%@", url, _industryId];
    }
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
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
                [self dealWithListDataAndRefresh:loadWay listData:list];
            }
        } else {
            NSLog(@"请求失败");
        }
        [self loadingSubtractCount];
    }];
}

- (void)dealWithListDataAndRefresh:(LoadListWay)loadWay listData:(NSArray *)list {
    switch (loadWay) {
        case LoadListWayDefault:
        case LoadListWayRefresh:
            self.dataSourse = [NSMutableArray arrayWithArray:list];
            break;
        case LoadListWayMore:
            [self.dataSourse addObjectsFromArray:list];
            break;
    }
    if (list.count < LoadSize) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        //上拉加载，如果已经通知没有更多数据，此方法可以重置上拉加载
        [self.collectionView.mj_footer endRefreshing];
    }
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [CollectionViewCell create:collectionView indexPath:indexPath];
    cell.model = self.dataSourse[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT,
                      (SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT*126/166+60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.2];
        return;
    }
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.price = model.price.floatValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 重写父类的方法

// 下拉刷新
- (void)pullRefresh {
    [super pullRefresh];
    [self loadListData:LoadListWayRefresh];
}

// 上拉加载
- (void)pullLoadMore {
    [super pullLoadMore];
    [self loadListData:LoadListWayMore];
}

// 重写父类tableview的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc] init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:true];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
    [cell refreshWithPlan:self.dataSourse[indexPath.row]];
    return cell;
}

// 点击提交后响应
- (void)commit:(NSArray<CommonItemModel *> *)screens {
    _industryId = NOT_INDUSTRY_ID;
    if (screens && screens.count > 0) {
        CommonItemModel *model = [screens firstObject];
        if ([model.keyWord isEqualToString:@"行业分类"]) {
            _industryId = model.itemId;
        }
    }
    self.loadPage = 1;
    [self loadListData:LoadListWayDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
