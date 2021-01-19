//
//  SZJieJueViewController.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SZJieJueViewController.h"
#import "HomeCollectionViewCell.h"
#import "JieJueDetailsViewController.h"
#import "JieJueModel.h"

@interface SZJieJueViewController ()

@end

@implementation SZJieJueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadJieJueList:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [HomeCollectionViewCell homeCell:collectionView indexPath:indexPath];
    [cell fillTheCellWithModel:self.dataSourse[indexPath.row]];
    return cell;
}
- ( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadJieJueList:(NSString *)type {
    [self loadingAddCountToView:self.view];
    NSString *url =  [NSString stringWithFormat:@"%@?screen=%@", API_GET_SOLUTION, type];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>> %@",result);
//        [self.tableView.mj_header endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    JieJueModel *model = [JieJueModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.dataSourse = list;
//                [self.tableView reloadData];
                [self.collectionView reloadData];
            }
        } else {
            NSLog(@"请求失败");
        }
        [self loadingSubtractCount];
    }];
}



@end
