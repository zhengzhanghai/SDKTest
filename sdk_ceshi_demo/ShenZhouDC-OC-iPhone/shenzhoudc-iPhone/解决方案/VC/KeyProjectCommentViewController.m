//
//  KeyProjectCommentViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectCommentViewController.h"
#import "KeyProjectCommentModel.h"
#import "keyProjectCommentTableViewCell.h"

@interface KeyProjectCommentViewController ()

@end

@implementation KeyProjectCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    self.tableView.height = SCREEN_HEIGHT;
    self.loadPage = 1;
    [self loadPingLunList:LoadListWayDefault];
}

/**
 *  当评论成功后，通知刷新该页面
 */
- (void)notifationRefresh {
    self.loadPage = 1;
    [self loadPingLunList:LoadListWayDefault];
}

- (void)loadPingLunList:(LoadListWay)loadWay {
    NSString *url = [NSString stringWithFormat:@"%@%@/%@?pageNumber=%zd&pageSize=%zd", DOMAIN_NAME, API_GET_KEY_PROJECT_COMMENT_LIST, _keyProjectId, self.loadPage, LoadSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSDictionary *dict = result.getDataObj;
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = dict[@"data"];
                for (int i = 0; i < array.count; i++) {
                    KeyProjectCommentModel *model = [KeyProjectCommentModel modelWithDictionary:array[i]];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    keyProjectCommentTableViewCell *cell = [keyProjectCommentTableViewCell createCell:tableView indexPath:indexPath];
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
