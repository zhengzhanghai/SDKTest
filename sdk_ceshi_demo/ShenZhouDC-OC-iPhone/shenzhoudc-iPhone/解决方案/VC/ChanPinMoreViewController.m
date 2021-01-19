//
//  ChanPinMoreViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinMoreViewController.h"
#import "NetAPI.h"
#import "JieJueModel.h"
#import "ChanPinDetailsViewController.h"
#import "ChanPinTableViewCell.h"
#import "ChanPinModel.h"
//#import "ChanPinDetailsWEBController.h"

#define NOT_EXIST_CATEGORY_STRING @"notExistCategoryId"

@interface ChanPinMoreViewController ()
/** 筛选行业分类id */
@property (copy, nonatomic) NSString *categoryId;
@end

@implementation ChanPinMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品列表";
    
    self.tableView.mj_footer = nil;
    _categoryId = NOT_EXIST_CATEGORY_STRING;
    self.headTitles = @[@"产品类别"];
    self.tableView.mj_footer = nil;
    [self loadAllProductListRequest:LoadListWayDefault];
    [self loadScreenCategory];
}

- (void)loadAllProductListRequest:(LoadListWay)loadWay {
    NSString *url = [NSString stringWithFormat:@"%@%@%d", DOMAIN_NAME,API_GETFILETYPE, 3];
    if (![_categoryId isEqualToString:NOT_EXIST_CATEGORY_STRING]) {
        url = [NSString stringWithFormat:@"%@?catagoryId=%@", url, _categoryId];
    }
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *dict = [result getDataObj];
                NSArray *array = dict[@"data"];
                for (int i = 0; i < array.count; i++) {
                    ChanPinModel *model = [ChanPinModel modelWithDictionary:array[i]];
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

// 获取筛选里产品类别
- (void)loadScreenCategory {
    NSString *url = API_GET_SCREEN_CHANPIN_CATEGORY;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *data = [result getDataObj];
                NSArray *array = data[@"data"];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *dict = array[i];
                    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
                    if ([dict.allKeys containsObject:@"id"]) {
                        muDict[@"id"] = dict[@"id"];
                    }
                    if ([dict.allKeys containsObject:@"dataCategoryContent"]) {
                        muDict[@"name"] = dict[@"dataCategoryContent"];
                    }
                    CommonItemModel *model = [CommonItemModel createModel:muDict andKeyWord:@"产品类别"];
                    [list addObject:model];
                }
                self.chanPinCategorys = list;
                if (self.chanPinCategorys) {
                    [self makeZYSide];
                    self.isPopScreen = YES;
                }
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}

- (void)dianZanOrCai:(NSString *)sourceId type:(NSString *)type {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:2.f];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", DOMAIN_NAME, API_POST_SOURCE_DIANZAN];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = sourceId;
    params[@"type"] = type;
    params[@"userId"] = [[UserModel sharedModel] userId];
    
    [[AINetworkEngine sharedClient] postWithApi:url parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                [self loadAllProductListRequest:LoadListWayDefault];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        } else {
            
        }
        
    }];
}

#pragma mark 重写父类的方法
// 下拉刷新
- (void)pullRefresh {
    [super pullRefresh];
    [self loadAllProductListRequest:LoadListWayRefresh];
    
}

// 上拉加载
- (void)pullLoadMore {
    [super pullLoadMore];
    [self loadAllProductListRequest:LoadListWayMore];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ChanPinDetailsWEBController *vc = [[ChanPinDetailsWEBController alloc]init];
//    ChanPinModel *model = self.dataSourse[indexPath.row];
//    vc.loadURLString = model.dataUrl;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinTableViewCell *cell = [ChanPinTableViewCell cell:tableView indexPath:indexPath];
    [cell config:self.dataSourse[indexPath.row]];
    cell.clickZanOrCaiBlock = ^(NSString *sourceId, NSString *type) {
        [self dianZanOrCai:sourceId type:type];
    };
    return cell;
}

// 点击提交后响应
- (void)commit:(NSArray<CommonItemModel *> *)screens {
    switch (screens.count) {
        case 0:
        {
            self.categoryId = NOT_EXIST_CATEGORY_STRING;
        }
            break;
        case 1:
        {
            CommonItemModel *model = screens[0];
            _categoryId = model.itemId;
        }
            break;
    }
    self.loadPage = 1;
    [self loadAllProductListRequest:LoadListWayDefault];
}

- (void)reloadScreenData {
    if (!self.dataSourse || self.dataSourse.count == 0) {
        [self loadScreenCategory];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
