//
//  BaseCollectionViewController.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "HomeCollectionViewCell.h"

@interface BaseCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadPage = 1;
    
    self.view.frame = CGRectMake(375, 0, SCREEN_WIDTH-375, SCREEN_HEIGHT-54);
    [self makeCollectionView];
    [self configureRefresh];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH*0.7-50)/4, ((SCREEN_WIDTH*0.7-50)/4-16)*162/216+136);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
}

#pragma mark collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [HomeCollectionViewCell homeCell:collectionView indexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 10, 10);
}

- (void)configureRefresh {
    //  下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self pullRefresh];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字、颜色、字体
    //    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    //    [header setTitle:@"正在加载" forState:MJRefreshStatePulling];
    //    [header setTitle:@"加载完成" forState:MJRefreshStateRefreshing];
    self.collectionView.mj_header = header;
    
    
    // 1.上拉加载更多
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self pullLoadMore];
    }];
    footer.automaticallyHidden = NO; // 关闭自动隐藏(若为YES，cell无数据时，不会执行上拉操作)
    //    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    //    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStatePulling];
    //    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStateRefreshing];
    self.collectionView.mj_footer = footer;
}

- (void)pullRefresh {
    self.loadPage = 1;
}

- (void)pullLoadMore {
    if (self.dataSourse.count == 0) {
        self.loadPage = 1;
    } else {
        self.loadPage++;
    }
}


#pragma mark 对从服务器上的列表数据进行处理，并刷新tableview
- (void)dealWithListDataAndRefresh:(LoadListWay)loadWay listData:(NSArray *)list {
    switch (loadWay) {
        case LoadListWayDefault:
        case LoadListWayRefresh:
            self.dataSourse = [NSMutableArray arrayWithArray:list];
            break;
        case LoadListWayMore:
            [self.dataSourse addObjectsFromArray:list];
            break;
    }
    if (list.count < LoadSize) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        //上拉加载，如果已经通知没有更多数据，此方法可以重置上拉加载
        [self.collectionView.mj_footer endRefreshing];
    }
    [self.collectionView reloadData];
}

#pragma mark 懒加载dataSource
- (NSMutableArray *)dataSourse {
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return _dataSourse;
}

@end
