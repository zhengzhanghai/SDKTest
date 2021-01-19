//
//  MoreBaseViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MoreBaseViewController.h"
#import "JieJueTableViewCell.h"
#import "ZYSideSlipFilterController.h"
#import "ZYSideSlipFilterRegionModel.h"
#import "SideSlipCommonTableViewCell.h"


@interface MoreBaseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) ZYSideSlipFilterController *filterController;

@end

@implementation MoreBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.loadPage = 1;

//    [self makeTable];
    [self makeNavRight];
//    [self configureRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

-(void)viewDidDisappear:(BOOL)animated
{
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}
- (void)makeTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
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
    self.tableView.mj_header = header;

    
    // 1.上拉加载更多
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self pullLoadMore];
    }];
    footer.automaticallyHidden = NO; // 关闭自动隐藏(若为YES，cell无数据时，不会执行上拉操作)
//    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
//    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStatePulling];
//    [footer setTitle:@"松开，即可查看图文详情" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
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

//MARK: _____________tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
    [cell refreshCell:self.dataSourse[indexPath.row]];
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 116;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)makeZYSide{
    self.filterController = [[ZYSideSlipFilterController alloc] initWithSponsor:self
                                                                     resetBlock:^(NSArray *dataList) {
                                                                         //重置
                                                                         [self reSetScreen:dataList];
                                                                     }                                                               commitBlock:^(NSArray *dataList) {
                                                                         //提交
                                                                         [self commitScreen:dataList];
                                                                         [_filterController dismiss];
                                                                     }];
    _filterController.navigationController.interactivePopGestureRecognizer.enabled = false;
    _filterController.animationDuration = .3f;
    _filterController.sideSlipLeading = 0.15*[UIScreen mainScreen].bounds.size.width;
    _filterController.dataList = [self packageDataList];
    //need navigationBar?
    [_filterController.navigationController setNavigationBarHidden:false];
    [_filterController setTitle:@"筛选"];
}

// 重置筛选框
- (void)reSetScreen:(NSArray<ZYSideSlipFilterRegionModel *> *)array {
    for (int i = 0; i < array.count; i++) {
        ZYSideSlipFilterRegionModel *regionModel = array[i];
        NSArray *items = regionModel.itemList;
        for (int j = 0; j < items.count; j++) {
            CommonItemModel *itemModel = items[j];
            itemModel.selected = NO;
        }
         regionModel.selectedItemList = nil;
    }
    [_filterController reloadData];
}

// 筛选提交
- (void)commitScreen:(NSArray<ZYSideSlipFilterRegionModel *> *)array {
    NSMutableArray *screenList = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        ZYSideSlipFilterRegionModel *regionModel = array[i];
        NSArray *items = regionModel.itemList;
        for (int j = 0; j < items.count; j++) {
            CommonItemModel *itemModel = items[j];
            if (itemModel.selected) {
                [screenList addObject:itemModel];
            }
        }
    }
    [self commit:screenList];
}

/** 筛选提交,子类去重写此方法 */
- (void)commit:(NSArray<CommonItemModel *> *)screens {
    
}

-(void)makeNavRight{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 28, 28);
    [btn setImage:[UIImage imageNamed:@"solution_filtrate"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navRightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)navRightClick{
    if (self.isPopScreen) {
        [_filterController show];
    } else {
        [self reloadScreenData];
        [self showError:self.view message:@"加载中，请稍等" afterHidden:2.0];
    }
}

- (void)reloadScreenData {
    // 子类中去实现
}

#pragma 筛选相关
#pragma mark - 筛选大标题
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    if (self.headTitles.count >= 1) {
        [dataArray addObject:[self commonFilterRegionModelWithKeyword:self.headTitles[0] selectionType:BrandTableViewCellSelectionTypeSingle]];
    }
    if (self.headTitles.count >= 2)  {
        [dataArray addObject:[self commonFilterRegionModelWithKeyword:self.headTitles[1] selectionType:BrandTableViewCellSelectionTypeSingle]];
    }
    if (self.headTitles.count >= 3 ) {
        [dataArray addObject:[self commonFilterRegionModelWithKeyword:self.headTitles[2] selectionType:BrandTableViewCellSelectionTypeSingle]];
    }
    return [dataArray mutableCopy];
}

- (ZYSideSlipFilterRegionModel *)commonFilterRegionModelWithKeyword:(NSString *)keyword selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipCommonTableViewCell";
    model.regionTitle = keyword;
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    if ([keyword isEqualToString:@"方案厂商"]) {
        model.itemList = self.firms;
    }else if ([keyword isEqualToString:@"项目类别"]) {
        model.itemList = self.projectCategorys;
    } else if ([keyword isEqualToString:@"实施地区"]) {
        model.itemList = self.implementAras;
    } else if ([keyword isEqualToString:@"是否认证"]) {
        model.itemList = self.isAuthentications;
    } else if ([keyword isEqualToString:@"产品类别"]) {
        model.itemList = self.chanPinCategorys;
    } else if ([keyword isEqualToString:@"服务类型"]) {
        model.itemList = self.serviceCategorys;
    } else if ([keyword isEqualToString:@"技术方向"]) {
        model.itemList = self.techialCategorys;
    } else if ([keyword isEqualToString:@"服务地点"]) {
        model.itemList = self.addressCategorys;
    } else if ([keyword isEqualToString:@"行业分类"]) {
        model.itemList = self.industryCategorys;
    }
    return model;
}

- (CommonItemModel *)createItemModelWithTitle:(NSString *)itemTitle
                                       itemId:(NSString *)itemId
                                     selected:(BOOL)selected {
    CommonItemModel *model = [[CommonItemModel alloc] init];
    model.itemId = itemId;
    model.itemName = itemTitle;
    model.selected = selected;
    return model;
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
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        //上拉加载，如果已经通知没有更多数据，此方法可以重置上拉加载
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

#pragma mark 懒加载dataSource
- (NSMutableArray *)dataSourse {
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return _dataSourse;
}
@end
