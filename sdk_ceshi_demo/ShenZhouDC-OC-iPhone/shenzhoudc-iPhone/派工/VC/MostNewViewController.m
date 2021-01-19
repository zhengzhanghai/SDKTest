//
//  MostNewViewController.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MostNewViewController.h"
#import "AINetworkEngine.h"
#import "CommonMacro.h"
#import "PaiModel.h"
@interface MostNewViewController ()
//@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) MBProgressHUD *showError;
@property (nonatomic,assign) NSInteger page;
@end

@implementation MostNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self loadData];
    __weak typeof(self)weakSelf = self;
    self.baseRefreshBlcok = ^(){
        [weakSelf loadData];
    };
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        _page = 1;
    }];
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        _page += 1;
//        [self loadData];
//        
//    }];
//    _showError =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)loadData{
   [self loadingAddCountToView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@%@?screen=1&page=%zd&size=20",DOMAIN_NAME,API_GET_ASSIGN,_page];
    NSLog(@"URL=%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    PaiModel *model = [PaiModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.dataSourse = list;
                [self.tableView reloadData];

            }
        } else {
            NSLog(@"请求失败");
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
       [self loadingSubtractCount];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
