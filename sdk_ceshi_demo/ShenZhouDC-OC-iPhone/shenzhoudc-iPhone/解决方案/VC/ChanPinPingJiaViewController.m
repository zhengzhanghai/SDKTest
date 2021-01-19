//
//  ChanPinPingJiaViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinPingJiaViewController.h"

@interface ChanPinPingJiaViewController ()

@end

@implementation ChanPinPingJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadPage = 1;
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
    NSString *url = [NSString stringWithFormat:@"%@?resourceType=%@&resourceId=%@&page=%zd&size=%d", API_GET_COMMENT,@"1", self.id, self.loadPage, LoadSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    CommentModel *model = [CommentModel modelWithDictionary:array[i]];
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
