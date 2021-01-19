//
//  MoreBaseViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "CommonItemModel.h"

/** m每页加载的数量 */
#define LoadSize 20

@interface MoreBaseViewController : BaseViewController
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourse;

/** 是否可以弹出筛选框（筛选中的选项是从服务器获取，当用户点击筛选但数据还没加载出来时，不能弹出筛选框） */
@property (assign, nonatomic) BOOL isPopScreen;
/** 筛选中大标题 */
@property (strong, nonatomic) NSArray<NSString *> *headTitles;
/** 筛选中方案厂商小标题(解决方案、产品有用到) */
@property (strong, nonatomic) NSArray<CommonItemModel *> *firms;
/** 筛选中行业分类小标题(解决方案、产品有用到)*/
@property (strong, nonatomic) NSArray<CommonItemModel *> *categorys;
/** 筛选中项目类别小标题(需求有用到) */
@property (strong, nonatomic) NSArray<CommonItemModel *> *projectCategorys;
/** 筛选中实施地区小标题(需求有用到) */
@property (strong, nonatomic) NSArray<CommonItemModel *> *implementAras;
/** 筛选中是否认证小标题(需求有用到) */
@property (strong, nonatomic) NSArray<CommonItemModel *> *isAuthentications;
/** 产品筛选用到 */
@property (strong, nonatomic) NSArray<CommonItemModel *> *chanPinCategorys;
/** IT服务筛选用到 服务类型*/
@property (strong, nonatomic) NSArray<CommonItemModel *> *serviceCategorys;
/** IT服务筛选用到 技术方向*/
@property (strong, nonatomic) NSArray<CommonItemModel *> *techialCategorys;
/** IT服务筛选用到 服务地点*/
@property (strong, nonatomic) NSArray<CommonItemModel *> *addressCategorys;
/** 更多方案里 行业分类地点*/
@property (strong, nonatomic) NSArray<CommonItemModel *> *industryCategorys;

/** 加载页数 */
@property (assign, nonatomic) NSInteger loadPage;

/** 初始化筛选框 */
-(void)makeZYSide;

/** 下拉刷新 */
- (void)pullRefresh;
/** 上拉加载 */
- (void)pullLoadMore;

/** 对从服务器上的列表数据进行处理，并刷新tableview */
- (void)dealWithListDataAndRefresh:(LoadListWay)loadWay listData:(NSArray *)list;

/** 筛选提交,子类去重写此方法 */
- (void)commit:(NSArray<CommonItemModel *> *)screens;

/** 重新加载筛选的分类 */
- (void)reloadScreenData;


- (void)makeTable;
@end
