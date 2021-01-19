//
//  PingJiaBaseViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "PingJiaTableViewCell.h"
#import "CommentModel.h"
/** m每页加载的数量 */
#define LoadSize 20

@interface PingJiaBaseViewController : BaseViewController
@property (copy, nonatomic)   NSString *id;
@property (strong, nonatomic) NSMutableArray *dataSourse;
/** 加载页数 */
@property (assign, nonatomic) NSInteger loadPage;
@property (nonatomic, strong) UITableView         *tableView;

/** 下拉刷新 */
- (void)pullRefresh;
/** 上拉加载 */
- (void)pullLoadMore;
/** 对从服务器上的列表数据进行处理，并刷新tableview */
- (void)dealWithListDataAndRefresh:(LoadListWay)loadWay listData:(NSArray *)list;
@end
