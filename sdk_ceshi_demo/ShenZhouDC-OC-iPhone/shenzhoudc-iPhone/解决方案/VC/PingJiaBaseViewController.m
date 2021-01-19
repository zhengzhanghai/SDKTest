//
//  PingJiaBaseViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PingJiaBaseViewController.h"

@interface PingJiaBaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PingJiaBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeTable];
    [self configureRefresh];
    [self loadPingLunList];
}

- (void)loadPingLunList {
    
}

- (void)makeTable{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT) style: UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.estimatedRowHeight = 120;
    tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView = tableView;
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


//MARK: ____________ tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PingJiaTableViewCell *cell = [PingJiaTableViewCell pingJiaCell:tableView indexPath:indexPath];
    [cell refreshCell:self.dataSourse[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
    } else {
        //上拉加载，如果已经通知没有更多数据，此方法可以重置上拉加载
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

#pragma mark 懒加载dataSource
- (NSMutableArray *)dataSourse {
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return _dataSourse;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
