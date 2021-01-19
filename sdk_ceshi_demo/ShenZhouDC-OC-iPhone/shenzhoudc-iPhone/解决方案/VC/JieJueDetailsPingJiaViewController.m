//
//  JieJueDetailsPingJiaViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueDetailsPingJiaViewController.h"
#import "PingJiaTableViewCell.h"
#import "SolutionCommentTableViewCell.h"
#import "SolutionCommentModel.h"
#import "SolutionCommentCell.h"

@interface JieJueDetailsPingJiaViewController ()

@end

@implementation JieJueDetailsPingJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadPage = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadPingLunList:LoadListWayDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifationRefresh) name:@"commentSuccess" object:nil];
}

/**
 *  当评论成功后，通知刷新该页面
 */
- (void)notifationRefresh {
    self.loadPage = 1;
    [self loadPingLunList:LoadListWayDefault];
}

- (void)loadPingLunList:(LoadListWay)loadWay {
    NSString *url = [NSString stringWithFormat:@"%@%@?solutionId=%@&pageNumber=%zd&pageSize=%d", DOMAIN_NAME, API_GET_SOLUTION_COMMENT_LIST, self.id, self.loadPage, LoadSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSDictionary *dict = result.getDataObj;
                NSMutableArray *list = [NSMutableArray array];
                if ([dict.allKeys containsObject:@"data"]) {
                    NSArray *array = dict[@"data"];
                    for (int i = 0; i < array.count; i++) {
                        SolutionCommentModel *model = [SolutionCommentModel modelWithDictionary:array[i]];
                        [list addObject:model];
                    }
                    [self dealWithListDataAndRefresh:loadWay listData:list];
                }
            }
        } else {
            NSLog(@"请求失败");
            if (self.loadPage > 1) {
                self.loadPage--;
            }
        }
    }];

}

#pragma mark 重写父类的方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SolutionCommentCell *cell = [SolutionCommentCell cell:tableView indexPath:indexPath];
//    SolutionCommentTableViewCell *cell = [SolutionCommentTableViewCell createCell:tableView indexPath:indexPath];
    cell.model = self.dataSourse[indexPath.row];
    return cell;
}
// 下拉刷新
- (void)pullRefresh {
    [super pullRefresh];
    [self loadPingLunList:LoadListWayRefresh];
}

// 上拉加载
- (void)pullLoadMore {
    [super pullLoadMore];
    [self loadPingLunList:LoadListWayMore];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
