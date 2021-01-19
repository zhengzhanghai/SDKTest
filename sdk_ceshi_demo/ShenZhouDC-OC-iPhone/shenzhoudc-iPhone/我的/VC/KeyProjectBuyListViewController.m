//
//  KeyProjectBuyListViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectBuyListViewController.h"
#import "KeyProjectBuyerCell.h"
#import "KeyProjectBuyerDetailsViewController.h"
#import "KeyProjectBuyerModel.h"

@interface KeyProjectBuyListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic)   NSArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation KeyProjectBuyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeTableView];
    [self loadBuyerList];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
}

- (void)loadBuyerList {
    NSString *url = [NSString stringWithFormat:@"%@?pakId=%@", API_GET_KEY_PROJECT_BUYER_LIST, _pkgId];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                NSDictionary *dict = result.getDataObj;
                NSArray *list = dict[@"data"];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
                for (NSUInteger i = 0; i < list.count; i++) {
                    [array addObject:[KeyProjectBuyerModel modelWithDictionary:list[i]]];
                }
                _dataSource = array;
                [_tableView reloadData];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:1.5];
            }
        } else {
            
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyProjectBuyerCell *cell = [KeyProjectBuyerCell createCellWithTableView:tableView];
    KeyProjectBuyerModel *model = _dataSource[indexPath.row];
    [cell configWithTitle:model.buyerName time:model.createTime];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    KeyProjectBuyerDetailsViewController *vc = [[KeyProjectBuyerDetailsViewController alloc] init];
    vc.buyerModel = _dataSource[indexPath.row];
    vc.pkgId = _pkgId;
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
