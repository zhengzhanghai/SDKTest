//
//  XuQiuMoreViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "XuQiuMoreViewController.h"
#import "NetAPI.h"
#import "JieJueModel.h"
#import "RequirementDetailViewController.h"
#import "ChanPinTableViewCell.h"

@interface XuQiuMoreViewController ()
/** 筛选项目分类id */
@property (copy, nonatomic)   NSString *projectId;
/** 筛选实施地区id */
@property (copy, nonatomic)   NSString *areaId;
/** 筛选是否认证id */
@property (copy, nonatomic)   NSString *authenticationId;
@end

@implementation XuQiuMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headTitles = @[@"行业分类", @"需求时间", @"投标情况"];
    [self loadListData:LoadListWayDefault];
    [self loadFirm];
    [self loadCategory];
}

- (void)loadListData:(LoadListWay)loadWay {
     NSString *url = [NSString stringWithFormat:@"%@?page=%zd&size=%zd&screen=0", API_GET_DEMAND, self.loadPage, LoadSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    JieJueModel *model = [JieJueModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                [self dealWithListDataAndRefresh:loadWay listData:list];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}

// 获取筛选中方案厂商
- (void)loadFirm {
    NSString *url = API_GET_COMMPANY;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    CommonItemModel *model = [CommonItemModel createModel:array[i] andKeyWord:@"方案厂商"];
                    [list addObject:model];
                }
                self.firms = list;
                if (self.categorys) {
                    [self makeZYSide];
                }
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}

// 获取筛选中行业分类
- (void)loadCategory {
    NSString *url = [NSString stringWithFormat:@"%@?type=2", API_GET_CATEGORY];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    CommonItemModel *model = [CommonItemModel createModel:array[i] andKeyWord:@"方案厂商"];
                    [list addObject:model];
                }
                self.categorys = list;
                if (self.firms) {
                    [self makeZYSide];
                }
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RequirementDetailViewController *vc = [[RequirementDetailViewController alloc] init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:true];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinTableViewCell *cell = [ChanPinTableViewCell cell:tableView indexPath:indexPath];
    [cell refresh:self.dataSourse[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
