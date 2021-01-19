//
//  ChanPinViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinViewController.h"
#import "SDCycleScrollView.h"
#import "NetAPI.h"
#import "JieJueModel.h"
#import "ChanPinMoreViewController.h"
#import "ChanPinDetailsViewController.h"
#import "ADSModel.h"
#import "ChanPinTableViewCell.h"

@interface ChanPinViewController ()<SDCycleScrollViewDelegate>
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *adsArray;
@end

@implementation ChanPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 1;
    [self loadProductList:@"1"];
    [self loadADSList];
}

- (void)loadProductList:(NSString *)type {
    NSString *url = [NSString stringWithFormat:@"%@?screen=%@", API_GET_PRODUCT, type];
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

// 获取广告列表
- (void)loadADSList {
    NSString *url = [NSString stringWithFormat:@"%@?type=3", API_GET_BANNER];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *models = [NSMutableArray array];
                NSMutableArray *titles = [NSMutableArray array];
                NSMutableArray *images = [NSMutableArray array];
                NSArray *ads = [result getDataObj];
                for (int i = 0; i < ads.count; i++) {
                    ADSModel *model = [ADSModel modelWithDictionary:ads[i]];
                    [models addObject:model];
                    [titles addObject:model.title];
                    [images addObject:model.image];
                }
                self.adsArray = models;
                self.cycleScrollView.titlesGroup = titles;
                self.cycleScrollView.imageURLStringsGroup = images;
            } else {
                
            }
        } else {
            //            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}


//MARK: 重写父类的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinDetailsViewController *vc = [[ChanPinDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinTableViewCell *cell = [ChanPinTableViewCell cell:tableView indexPath:indexPath];
    [cell refresh:self.dataSourse[indexPath.row]];
    return cell;
}

- (void)pullRefresh {
    [self loadProductList:[NSString stringWithFormat:@"%zd", self.index]];
}

//点击头部标题响应事件
- (void)headerAction:(NSInteger)index {
    NSLog(@"方案----%ld", (long)index);
    self.index = index+1;
    [self loadProductList:[NSString stringWithFormat:@"%d", self.index]];
}

- (NSArray *)headerTitles {
    return @[@"最新产品" , @"推荐产品",  @"热门产品"];
}

- (NSString *)footerTitle {
    return @"更多产品";
}

-(void)moreClick{
    ChanPinMoreViewController *vc = [[ChanPinMoreViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
