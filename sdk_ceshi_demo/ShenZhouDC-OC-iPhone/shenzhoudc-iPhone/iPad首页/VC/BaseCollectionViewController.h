//
//  BaseCollectionViewController.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

#define LoadSize 20


@interface BaseCollectionViewController : BaseViewController

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSourse;

/** 加载页数 */
@property (assign, nonatomic) NSInteger loadPage;

/** 下拉刷新 */
- (void)pullRefresh;
/** 上拉加载 */
- (void)pullLoadMore;

/** 对从服务器上的列表数据进行处理，并刷新tableview */
- (void)dealWithListDataAndRefresh:(LoadListWay)loadWay listData:(NSArray *)list;

@end
