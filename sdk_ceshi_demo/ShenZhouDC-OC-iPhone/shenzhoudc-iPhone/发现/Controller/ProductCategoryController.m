//
//  ProductCategoryController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductCategoryController.h"
#import "ProductCategoryModel.h"
#import "ProductCategoryCell.h"
#import "ProductListController.h"
@interface ProductCategoryController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic)   NSArray *dataSource;
@end

@implementation ProductCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeTableVeiw];
    [self loadCategory];
}

- (void)makeTableVeiw {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               SCREEN_WIDTH,
                                                               SCREEN_HEIGHT)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 60.f;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

// 获取筛选里产品类别
- (void)loadCategory {
    NSString *url = API_GET_SCREEN_CHANPIN_CATEGORY;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *data = [result getDataObj];
                NSArray *array = data[@"data"];
                for (int i = 0; i < array.count; i++) {
                    [list addObject:[ProductCategoryModel modelWithDictionary:array[i]]];
                }
                self.dataSource = list;
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}


#pragma mark -----  UITableViewDelegate, UITableViewDataSource 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCategoryCell *cell = [ProductCategoryCell createWithTableView:tableView indexPath:indexPath];
    ProductCategoryModel *model = self.dataSource[indexPath.row];
    [cell configWIthIcon:model.dataCategoryImage title:model.dataCategoryContent];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListController *vc = [[ProductListController alloc] init];
    ProductCategoryModel *model = self.dataSource[indexPath.row];
    vc.categoryId = model.id.stringValue;
    vc.categoryName = model.dataCategoryContent;
    [self pushControllerHiddenTabbar:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
