//
//  RelateSolutionViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "RelateSolutionViewController.h"
#import "JieJueDetailsViewController.h"
#import "JieJueModel.h"

@interface RelateSolutionViewController ()

@end

@implementation RelateSolutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相关解决方案";
    [self loadListData:LoadListWayDefault];
}

- (void)loadListData:(LoadListWay)loadWay {
    NSString *url = [NSString stringWithFormat:@"%@?solutionId=%@&page=%zd&size=%zd", API_GET_SLOUTION_ABOUT_PROFUCT, self.id, self.loadPage, LoadSize];
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
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc] init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
