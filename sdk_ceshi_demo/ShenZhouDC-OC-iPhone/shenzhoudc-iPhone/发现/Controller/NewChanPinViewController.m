//
//  NewChanPinViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "NewChanPinViewController.h"
#import "NetAPI.h"
#import "JieJueModel.h"
#import "ChanPinDetailsViewController.h"
#import "ADSModel.h"
#import "ChanPinTableViewCell.h"

@interface NewChanPinViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) UITableView *tableView;
//@property (strong, nonatomic) NSMutableArray *dataSourse;

@end

@implementation NewChanPinViewController

//-(NSMutableArray *)dataSourse {
//    if (!_dataSourse) {
//        _dataSourse = [NSMutableArray array];
//    }
//    return _dataSourse;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"产品";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadProductList:@"1"];
    
    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//产品列表
- (void)loadProductList:(NSString *)type {
    NSString *url = API_GET_PRODUCT;//[NSString stringWithFormat:@"%@?screen=%@", API_GET_PRODUCT, type];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    JieJueModel *model = [JieJueModel modelWithDictionary:array[i]];
                    //                    JieJueModel *model = [[JieJueModel alloc] initWithDictionary:array[i] error:nil];
                    [list addObject:model];
                }
                self.dataSourse = list;
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSourse.count;
////    return  5;
//}
//MARK: 重写父类的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinDetailsViewController *vc = [[ChanPinDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinTableViewCell *cell = [ChanPinTableViewCell cell:self.tableView indexPath:indexPath];
    [cell refresh:self.dataSourse[indexPath.row]];
    return cell;
}


@end
