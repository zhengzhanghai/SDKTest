//
//  DetailsRelateBaseViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DetailsRelateBaseViewController.h"
#import "JieJueTableViewCell.h"
#import "JieJueModel.h"

@interface DetailsRelateBaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DetailsRelateBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.title = @"更多";
    self.loadPage = 1;
    
    [self makeTable];
    [self configureRefresh];
}

- (void)makeTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)configureRefresh {
    //  下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self pullRefresh];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字、颜色、字体
    //    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    //    [header setTitle:@"正在加载" forState:MJRefreshStatePulling];
    //    [header setTitle:@"加载完成" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    
    // 1.上拉加载更多
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self pullLoadMore];
    }];
    footer.automaticallyHidden = NO; // 关闭自动隐藏(若为YES，cell无数据时，不会执行上拉操作)
    //    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    //    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStatePulling];
    //    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
}

- (void)pullRefresh {
    self.loadPage = 1;
}

- (void)pullLoadMore {
    if (self.dataSourse.count == 0) {
        self.loadPage = 1;
    } else {
        self.loadPage++;
    }
}

//MARK: _____________tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
    [cell refreshCell:self.dataSourse[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark 对从服务器上的列表数据进行处理，并刷新tableview
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
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
