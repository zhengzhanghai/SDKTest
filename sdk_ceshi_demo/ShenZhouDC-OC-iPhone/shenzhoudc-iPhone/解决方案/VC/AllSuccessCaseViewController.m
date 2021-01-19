//
//  AllSuccessCaseViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "AllSuccessCaseViewController.h"
#import "JieJueTableViewCell.h"
#import "SuccessCaseDetailWebViewController.h"

@interface AllSuccessCaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView         *tableView;

@end

@implementation AllSuccessCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.tableView.mj_header endRefreshing];
}

- (void)pullLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

//MARK: _____________tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
//    [cell refreshCell:self.dataSourse[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SuccessCaseDetailWebViewController *vc = [[SuccessCaseDetailWebViewController alloc] init];
    vc.id = @"";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
