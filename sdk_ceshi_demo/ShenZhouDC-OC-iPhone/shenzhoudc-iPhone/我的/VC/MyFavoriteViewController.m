//
//  MyFavoriteViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "FavoriteTableViewCell.h"
#import "FavoriteModel.h"
#import "JieJueDetailsViewController.h"
#import "ProductDetailsController.h"
#import "FavoriteTextTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface MyFavoriteViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic)   NSMutableArray *dataSource;
@property (assign, nonatomic) int loadPage;
@property (assign, nonatomic) int pageSize;
@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    _loadPage = 1;
    _pageSize = 20;
    [self makeTableView];
    [self loadList];
}

- (void)loadList {
    NSString *url = [NSString stringWithFormat:@"%@?userId=%@&pageNumber=%d&pageSize=%d", API_GET_MY_FAVORITE, [[UserModel sharedModel] userId], _loadPage, _pageSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (result.isSucceed) {
            NSDictionary *dict = result.getDataObj;
            NSArray *list = dict[@"data"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
            for (NSUInteger i = 0; i < list.count; i++) {
                [array addObject:[FavoriteModel modelWithDictionary:list[i]]];
            }
            if (_loadPage == 1) {
                _dataSource = array;
            } else {
                for (NSInteger i = 0; i < array.count; i++) {
                    [_dataSource addObject:array[i]];
                }
            }
            [_tableView reloadData];
            if (array.count < 20) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_tableView.mj_header endRefreshing];
            }
        }
    }];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader *mjHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.loadPage = 1;
        [self loadList];
    }];
    _tableView.mj_header = mjHeader;
    
    MJRefreshBackGifFooter *mjFooter = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        weakSelf.loadPage += 1;
        [self loadList];
    }];
    _tableView.mj_footer = mjFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteModel *model =  _dataSource[indexPath.row];
    if (model.image == nil || [model.image isEqualToString:@""]) {
        FavoriteTextTableViewCell *cell = [FavoriteTextTableViewCell create:tableView indexPath:indexPath];
        cell.model = model;
        return cell;
    } else {
        FavoriteTableViewCell *cell = [FavoriteTableViewCell create:tableView indexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    FavoriteModel *model = _dataSource[indexPath.row];
    switch (model.goosType.intValue) {
        case 1:
        {
            JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc] init];
            vc.id = model.goodsid.stringValue;
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 2:
            
            break;
        case 3:
        {
            ProductDetailsController *vc = [[ProductDetailsController alloc] init];
            vc.productId = model.goodsid.stringValue;
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 4:
            
            break;
    }
}

@end
