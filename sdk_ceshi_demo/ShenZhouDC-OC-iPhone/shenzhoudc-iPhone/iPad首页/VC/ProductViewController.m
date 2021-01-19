//
//  ProductViewController.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductViewController.h"
#import "JieJueModel.h"
#import "HomeCollectionViewCell.h"
#import "ChanPinDetailsViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadAllProductListRequest:LoadListWayDefault];
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
    ChanPinDetailsViewController *vc = [[ChanPinDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)loadAllProductListRequest:(LoadListWay)loadWay {
    
    NSString *url = [NSString stringWithFormat:@"%@%@?pageNum=%zd&pageSize=20",DOMAIN_NAME,API_GET_PRODUCT,self.loadPage];
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSLog(@"加载成功--> %@",responseObject);
        
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        NSArray *arr = dict[@"list"];
        NSMutableArray *list = [NSMutableArray array];
        
        for (NSDictionary *dic in arr) {
            JieJueModel *model = [JieJueModel modelWithDictionary:dic];
            [list addObject:model];
        }
        [self dealWithListDataAndRefresh:loadWay listData:list];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSLog(@"加载失败  ** %@",error);
    }];
    
    
    
}
@end
