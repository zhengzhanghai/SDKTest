//
//  ListBaseTableViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface ListBaseTableViewController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (nonatomic, strong) UIButton *moreButton;

@property (strong, nonatomic) NSMutableArray *adsArray;

@property (nonatomic, strong) NSArray *headerTitles;
@property (nonatomic, copy)   NSString *footerTitle;
    
@property (strong, nonatomic) UICollectionView *collectionView;

// 点击table底部更多
-(void)moreClick;
@end
