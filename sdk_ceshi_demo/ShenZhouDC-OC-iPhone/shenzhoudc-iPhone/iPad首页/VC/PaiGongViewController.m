//
//  PaiGongViewController.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PaiGongViewController.h"
#import "PaiModel.h"

@interface PaiGongViewController ()//<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) UITableView *tableView;

@end

@implementation PaiGongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)loadData{
    [self loadingAddCountToView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@%@?screen=1",DOMAIN_NAME,API_GET_ASSIGN];
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



@end
