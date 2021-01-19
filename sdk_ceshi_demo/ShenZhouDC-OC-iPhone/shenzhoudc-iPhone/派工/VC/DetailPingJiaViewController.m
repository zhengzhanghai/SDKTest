//
//  DetailPingJiaViewController.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DetailPingJiaViewController.h"
#import "PingJiaTableViewCell.h"
#import "PaiModel.h"
#import "CommentModel.h"
@interface DetailPingJiaViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger page;
@end

@implementation DetailPingJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:@"commentSuccess" object:nil];
    [self makeTable];
    [self loadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page+=1;
        [self loadData];
        
    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
//- (void)footerRefresh{
//    _page+=1;
//    [self loadData];
//}


- (void)refreshList{
    _page = 1;
    [self loadData];
}
- (void)loadData{
    
    [self loadingAddCountToView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@?resourceId=%d&resourceType=4&page=%zd&size=20",API_GET_COMMENT,_ID,_page];
    NSLog(@"派工评论列表....URL=%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"%@",[result getMessage]);
                NSArray *arr = [result getDataObj];
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                 
                  [arrM addObject:[CommentModel modelWithDictionary:dict]];
                }
                if (_page == 1) {
                    self.dataArr = arrM;
                    NSLog(@"下拉刷新出%zd条数据",arrM.count);
                }else{
                    NSLog(@"上拉加载更多%zd条数据",arrM.count);
                    for (CommentModel *model in arrM) {
                        [self.dataArr addObject:model];
                    }
                }
                
                [self.tableView reloadData];
                
            }else{
            
                NSLog(@"%@",[result getMessage]);
                
            }
        }else{
                NSLog(@"请求失败");
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self loadingSubtractCount];
    }];
    
}
- (void)makeTable{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT) style: UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.estimatedRowHeight = 120;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

//MARK: ____________ tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PingJiaTableViewCell *cell = [PingJiaTableViewCell pingJiaCell:tableView indexPath:indexPath];
    CommentModel *model = _dataArr[indexPath.row];
    [cell refreshCell:model];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
