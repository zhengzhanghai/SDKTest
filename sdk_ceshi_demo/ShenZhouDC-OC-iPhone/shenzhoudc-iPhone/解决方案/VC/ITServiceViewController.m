//
//  ITServiceViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ITServiceViewController.h"
#import "MoreITServiceViewController.h"
#import "ServiceDetailViewController.h"
#import "DealViewController.h"
#import "ITServiceModel.h"
#import "ITServiceCell.h"

@interface ITServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *allServiceArray;
@property (nonatomic,assign) NSInteger page;


@end

@implementation ITServiceViewController
- (NSMutableArray *)allServiceArray {
    if (!_allServiceArray) {
        _allServiceArray = [NSMutableArray array];
    }
    return _allServiceArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.page = 1;
    [self loadAllServiceListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];//-TABBARHEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT-33
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ITServiceCell" bundle:nil] forCellReuseIdentifier:@"ITServiceCell"];
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    moreBtn.backgroundColor = MainColor;
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = moreBtn;
    
    [self.view addSubview:_tableView];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 80;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadAllServiceListRequest];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page+=1;
        [self loadAllServiceListRequest];
        
    }];

    
}
//点击 尾部视图的更多按钮
- (void)clickMoreBtn {
    
    MoreITServiceViewController *vc = [[MoreITServiceViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allServiceArray.count;  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITServiceCell" forIndexPath:indexPath];
    
    ITServiceModel *model = self.allServiceArray[indexPath.row];
    [cell makeITServiceCellWithModel:model];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ITServiceModel *model = self.allServiceArray[indexPath.row];
    //追加
    //    DealViewController *vc = [[DealViewController alloc]init];
    //    vc.headerTitle = @"个人交易记录";
    //第一版
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc]init];
    vc.userid = [NSString stringWithFormat:@"%@",model.userid];
    vc.id = [model.id integerValue];
    vc.orderSn = model.orderSn;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadAllServiceListRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@?pageNumber=%zd&pagesize=20", API_GET_ITSERVER,_page];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *models = [NSMutableArray array];
           
                NSArray *ads = [result getDataObj];
                for (int i = 0; i < ads.count; i++) {
                    ITServiceModel *model = [ITServiceModel modelWithDictionary:ads[i]];
                    [models addObject:model];
                    
                }
//                self.allServiceArray = models;
                if (_page == 1) {
                    self.allServiceArray = models;
                    NSLog(@"下拉刷新出%zd条数据",models.count);
                }else{
                    NSLog(@"上拉加载更多%zd条数据",models.count);
                    for (ITServiceModel *model in models) {
                        [self.allServiceArray addObject:model];
                    }
                    
                }
                [self.tableView reloadData];
               
            } else {
                
            }
        } else {
                        [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self loadingSubtractCount];
        
    }];

}

@end
