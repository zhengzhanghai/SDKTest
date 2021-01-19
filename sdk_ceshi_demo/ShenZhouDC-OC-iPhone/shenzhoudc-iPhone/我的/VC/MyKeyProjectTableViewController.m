//
//  MyKeyProjectTableViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyKeyProjectTableViewController.h"
#import "MyKeyProjectModel.h"
#import "MyKeyProjectTableViewCell.h"
#import "WaitReveiceOrderViewController.h"
#import "KeyProjectSurePassController.h"
#import "MyKeyProjectOperateTableViewCell.h"
#import "KeyProjectSureFinishWorkViewController.h"
#import "KeyProjectDetailsViewController.h"
#import "MyKeyProjectImageTableViewCell.h"
#import "MyKeyProjectOperateImageTableViewCell.h"

@interface MyKeyProjectTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic)   NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger loadPage;
@property (assign, nonatomic) NSInteger loadSize;
@end

@implementation MyKeyProjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadPage = 1;
    _loadSize = 20;
    _dataSource = @[].mutableCopy;
    [self makeTableView];
    [self loadKeyProjectList];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP-40) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (weakSelf.loadPage>1) {
            weakSelf.loadPage--;
        }
        [weakSelf loadKeyProjectList];
    }];
    _tableView.mj_header = header;
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        weakSelf.loadPage++;
        [weakSelf loadKeyProjectList];
    }];
    [self.view addSubview:_tableView];
}

- (void)loadKeyProjectList {
    NSString *url = nil;
    if (_type == KeyProjectTableTypePublish) {
        url = API_GET_KEY_PROJECT_PUBLISH_LIST;
    } else {
        url = API_GET_KEY_PROJECT_BUY_LIST;
    }
    url = [NSString stringWithFormat:@"%@?pageNumber=%zd&pageSize=%zd", url, _loadPage, _loadSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (result.isSucceed) {
            NSDictionary *dict = result.getDataObj;
            if (dict[@"data"]) {
                NSArray *list = dict[@"data"];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
                for (NSUInteger i = 0; i < list.count; i++) {
                    if (_type == KeyProjectTableTypeBuy) {
                        [array addObject:[MyKeyProjectBuyModel modelWithDictionary:list[i]]];
                    } else {
                        [array addObject:[MyKeyProjectModel modelWithDictionary:list[i]]];
                    }
                }
                if (_loadPage == 1) {
                    _dataSource = array;
                } else {
                    for (NSUInteger i = 0; i < array.count; i++) {
                        [_dataSource addObject:array[i]];
                    }
                }
                [_tableView reloadData];
            }
        }
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)surePay:(MyKeyProjectBuyModel *)model {
    [self showLoadingToView:App_Delegate.window];
    NSString *url = API_POST_KEY_PROJECT_SURE_PAY;
    NSDictionary *dict = @{@"pakId": model.pkgId.stringValue, @"buyerId": [UserModel sharedModel].userId};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result) {
            if (result.isSucceed) {
                [self loadKeyProjectList];
            }
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}

- (void)startWork:(MyKeyProjectModel *)model {
    [self showLoadingToView:App_Delegate.window];
    NSString *url = API_POST_KEY_PROJECT_START_WORK;
    NSDictionary *dict = @{@"pakId": model.id.stringValue, @"userId": [UserModel sharedModel].userId};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result) {
            if (result.isSucceed) {
                [self loadKeyProjectList];
            }
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == KeyProjectTableTypeBuy) {
        MyKeyProjectBuyModel *model = _dataSource[indexPath.row];
        if (model.status.integerValue == 4) {
            if (model.image == nil || [model.image isEqualToString:@""]) {
                MyKeyProjectOperateTableViewCell *cell = [MyKeyProjectOperateTableViewCell createCellWithTableView:tableView indexPath:indexPath];
                cell.buyModel = model;
                cell.clickBtnBlock = ^{
                    [self surePay:model];
                };
                return cell;
            } else {
                MyKeyProjectOperateImageTableViewCell *cell = [MyKeyProjectOperateImageTableViewCell createCellWithTableView:tableView indexPath:indexPath];
                cell.buyModel = model;
                cell.clickBtnBlock = ^{
                    [self surePay:model];
                };
                return cell;
            }
            
        } else {
            if (model.image == nil || [model.image isEqualToString:@""]) {
                MyKeyProjectTableViewCell *cell = [MyKeyProjectTableViewCell createCellWithTableView:tableView];
                [cell configWithBuyModel:model];
                return cell;
            } else {
                MyKeyProjectImageTableViewCell *cell = [MyKeyProjectImageTableViewCell createCellWithTableView:tableView];
                [cell configWithBuyModel:model];
                return cell;
            }
        }
    } else {
        MyKeyProjectModel *model = _dataSource[indexPath.row];
        if (model.status.integerValue == 6) {
            if (model.image == nil || [model.image isEqualToString:@""]) {
                MyKeyProjectOperateTableViewCell *cell = [MyKeyProjectOperateTableViewCell createCellWithTableView:tableView indexPath:indexPath];
                cell.model = model;
                cell.clickBtnBlock = ^{
                    [self startWork:model];
                };
                return cell;
            } else {
                MyKeyProjectOperateImageTableViewCell *cell = [MyKeyProjectOperateImageTableViewCell createCellWithTableView:tableView indexPath:indexPath];
                cell.model = model;
                cell.clickBtnBlock = ^{
                    [self startWork:model];
                };
                return cell;
            }
            
        } else {
            if (model.image == nil || [model.image isEqualToString:@""]) {
                MyKeyProjectTableViewCell *cell = [MyKeyProjectTableViewCell createCellWithTableView:tableView];
                [cell configWithModel:model];
                return cell;
            } else {
                MyKeyProjectImageTableViewCell *cell = [MyKeyProjectImageTableViewCell createCellWithTableView:tableView];
                [cell configWithModel:model];
                return cell;
            }
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (_type == KeyProjectTableTypePublish) {
        MyKeyProjectModel *model = _dataSource[indexPath.row];
        if (model.status.integerValue == 1) {
            WaitReveiceOrderViewController *vc = [[WaitReveiceOrderViewController alloc] init];
            vc.pkgId = model.id.stringValue;
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        } else if (model.status.integerValue == 3) {
            KeyProjectSurePassController *vc = [[KeyProjectSurePassController alloc] init];
            vc.id = model.id.stringValue;
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        } else if (model.status.integerValue == 7) {
            KeyProjectSureFinishWorkViewController *vc = [[KeyProjectSureFinishWorkViewController alloc] init];
            vc.keyProjectId = model.id.stringValue;
            vc.sureString = @"确认完工";
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        } else {
            KeyProjectDetailsViewController *vc = [[KeyProjectDetailsViewController alloc] init];
            vc.keyProjectId = model.id.stringValue;
            vc.solutionId = model.solutionId.stringValue;
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        }
    } else {
        MyKeyProjectBuyModel *model = _dataSource[indexPath.row];
        if (model.status.integerValue == 8) {
            KeyProjectSureFinishWorkViewController *vc = [[KeyProjectSureFinishWorkViewController alloc] init];
            vc.keyProjectId = model.pkgId.stringValue;
            vc.sureString = @"确认验收";
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        } else {
            KeyProjectDetailsViewController *vc = [[KeyProjectDetailsViewController alloc] init];
            vc.keyProjectId = model.pkgId.stringValue;
            vc.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
