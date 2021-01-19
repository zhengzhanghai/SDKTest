//
//  MoreITServiceViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "AppDelegate.h"
#import "MoreITServiceViewController.h"
//#import "ServiceDetailViewController.h"
#import "DealViewController.h"
#import "ITServiceModel.h"
#import "ITServiceCell.h"
#import "ServiceDetailViewController.h"
#import "ITServiceModel.h"
#import "PaiGongCell.h"
#import "PaiGongPulldownView.h"
#import "PopMenuView.h"
#import "ITServiceCategoryModel.h"
#import "ITSearviceViewCell.h"
#define NOT_SELECTED_CATEGORY @"notSelectedCategory"

#define MENU_HEIGHT (IS_IPAD ? 54 : 44)

@interface MoreITServiceViewController ()
@property (strong, nonatomic) PaiGongPulldownView *screenHeaderView;
@property (strong, nonatomic) PopMenuView *popMenuView;
@property (copy, nonatomic)   NSArray *serviceTypeArray;
@property (copy, nonatomic)   NSArray *technicalDirectionArray;
@property (copy, nonatomic)   NSArray *serviceAdressArray;
@property (copy, nonatomic)   NSString *serviceTypeId;
@property (copy, nonatomic)   NSString *technicalDirectionId;
@property (copy, nonatomic)   NSString *serviceAdressId;
@end

@implementation MoreITServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
    self.navigationItem.title = @"IT服务";
    [self addHeaderView];
    [self makeTable];
    [self.view addSubview:self.tableView];
    self.tableView.y = MENU_HEIGHT+TOPBARHEIGHT;
    self.tableView.height = CONTENTHEIGHT_NOTAB_NOTOP - MENU_HEIGHT;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self loadAllProductListRequest:LoadListWayMore];
    [self loadServiceAddress];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)configData {
    self.headTitles = @[@"服务类型", @"技术方向", @"服务地点"];
    _serviceTypeId = NOT_SELECTED_CATEGORY;
    _technicalDirectionId = NOT_SELECTED_CATEGORY;
    _serviceAdressId = NOT_SELECTED_CATEGORY;
    //        1.安装、2.调试、3.巡检、4.故障处理、5.培训、6.售前交流、7.测试、8.其它
    NSArray *serviceTypes = @[@{@"id": @(-1011), @"name": @"全部"},
                              @{@"id": @1, @"name": @"安装"},
                              @{@"id": @2, @"name": @"调试"},
                              @{@"id": @3, @"name": @"巡检"},
                              @{@"id": @4, @"name": @"故障处理"},
                              @{@"id": @5, @"name": @"培训"},
                              @{@"id": @6, @"name": @"售前交流"},
                              @{@"id": @7, @"name": @"测试"},
                              @{@"id": @8, @"name": @"其它"}];
    NSMutableArray *typeArray = [NSMutableArray arrayWithCapacity:serviceTypes.count];
    NSMutableArray *typeCategorys = [NSMutableArray arrayWithCapacity:serviceTypes.count];
    for (NSUInteger i = 0; i < serviceTypes.count; i++) {
        [typeArray addObject:[ITServiceCategoryModel modelWithDictionary:serviceTypes[i]]];
        [typeCategorys addObject:[CommonItemModel createModel:serviceTypes[i] andKeyWord:@"服务类型"]];
    }
    _serviceTypeArray = typeArray;
    self.serviceCategorys = typeCategorys;
    
//    1.网络类、2.安全类、3.服务器类、4.开发类、5.软件类、6.存储类、7.其它
    NSArray *technicals =   @[@{@"id": @(-1011), @"name": @"全部"},
                              @{@"id": @1, @"name": @"网络类"},
                              @{@"id": @2, @"name": @"安全类"},
                              @{@"id": @3, @"name": @"服务器类"},
                              @{@"id": @4, @"name": @"开发类"},
                              @{@"id": @5, @"name": @"软件类"},
                              @{@"id": @6, @"name": @"存储类"},
                              @{@"id": @7, @"name": @"其它"}];
    NSMutableArray *technicalArray = [NSMutableArray arrayWithCapacity:technicals.count];
    NSMutableArray *technicalCategorys = [NSMutableArray arrayWithCapacity:technicals.count];
    for (NSUInteger i = 0; i < technicals.count; i++) {
        [technicalArray addObject:[ITServiceCategoryModel modelWithDictionary:technicals[i]]];
        [technicalCategorys addObject:[CommonItemModel createModel:technicals[i] andKeyWord:@"技术方向"]];
    }
    _technicalDirectionArray = technicalArray;
    self.techialCategorys = technicalCategorys;
}

- (void)addHeaderView {
    _screenHeaderView = [[PaiGongPulldownView alloc] initWithFrame:CGRectMake(0.f, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, MENU_HEIGHT) Titles:@[@"服务类型", @"技术方向", @"服务地点"]];
    _screenHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_screenHeaderView];
    
    __weak typeof(self) weakSelf = self;
    _screenHeaderView.clickItemBlick = ^(NSInteger index) {
        NSLog(@"----- %zd", index);
        [weakSelf addPopMenuView:index];
    };
}

- (void)addPopMenuView:(NSInteger)index {
    if (index == 2) {
        if (!_serviceAdressArray || _serviceAdressArray.count == 0) {
            [self loadServiceAddress];
            return;
        }
    }
    CGFloat menuWidth = 130.f;
    CGPoint point = [self.screenHeaderView itemCenterWithIndex:index];
    CGPoint origin = [self popMenuViewOrigin:point menuWidth:menuWidth];
    NSArray *titles = [self headerCategoryTitles:index];
    CGFloat popHeight = titles.count*40+10;
    if (popHeight > 350.f) {
        popHeight = 350.f;
    }
    PopMenuView *popView = [[PopMenuView alloc] initWithShapeLayerFrame:CGRectMake(origin.x, NAVBARHEIGHT+STATUSBARHEIGHT+point.y, menuWidth, popHeight) withArrowCenterX:point.x titles:titles];
    [UIApplication.sharedApplication.delegate.window addSubview:popView];
    __weak PopMenuView *weakPop = popView;
    __weak PaiGongPulldownView *weakHeaderView = _screenHeaderView;
    [popView showWithAnimation:0.2 completed:^{
        
    }];
    popView.clickSelfBlock = ^{
        [weakPop hiddenWithAnimation:0.2 completed:^{
            [weakHeaderView setItemSelected:false atIndex:index];
            [weakPop removeFromSuperview];
        }];
    };
    __weak typeof(self) weakSelf = self;
    popView.clickCellBlock = ^(NSInteger cellIndex, NSString *title) {
        NSString *titleStr = title;
        weakSelf.loadPage = 1;
        if (index == 0) {
            ITServiceCategoryModel *model = _serviceTypeArray[cellIndex];
            weakSelf.serviceTypeId = model.id.stringValue;
            if (model.id.integerValue == -1011) {
                weakSelf.serviceTypeId = NOT_SELECTED_CATEGORY;
                titleStr = @"服务类型";
            }
        } else if (index == 1) {
            ITServiceCategoryModel *model = _technicalDirectionArray[cellIndex];
            weakSelf.technicalDirectionId = model.id.stringValue;
            if (model.id.integerValue == -1011) {
                weakSelf.technicalDirectionId = NOT_SELECTED_CATEGORY;
                titleStr = @"技术方向";
            }
        } else if (index == 2) {
            ITServiceCategoryModel *model = _serviceAdressArray[cellIndex];
            weakSelf.serviceAdressId = model.name;
            if (model.id.integerValue == -1011) {
                weakSelf.serviceAdressId = NOT_SELECTED_CATEGORY;
                titleStr = @"服务地点";
            }
        }
        [weakSelf loadAllProductListRequest:LoadListWayDefault];
        [weakPop hiddenWithAnimation:0.2 completed:^{
            [weakPop removeFromSuperview];
            [weakHeaderView setTitle:titleStr index:index];
            [weakHeaderView setItemSelected:false atIndex:index];
        }];
    };
}

- (NSArray *)headerCategoryTitles:(NSInteger)index {
    NSArray *titles = nil;
    if (index == 0) {
        NSMutableArray *serviceTypeTitles = [NSMutableArray arrayWithCapacity:_serviceTypeArray.count];
        for (NSUInteger i = 0; i < _serviceTypeArray.count; i++) {
            ITServiceCategoryModel *model = _serviceTypeArray[i];
            [serviceTypeTitles addObject:model.name];
        }
        titles = serviceTypeTitles;
    } else if (index == 1) {
        NSMutableArray *technicals = [NSMutableArray arrayWithCapacity:_technicalDirectionArray.count];
        for (NSUInteger i = 0; i < _technicalDirectionArray.count; i++) {
            ITServiceCategoryModel *model = _technicalDirectionArray[i];
            [technicals addObject:model.name];
        }
        titles = technicals;
    } else if (index == 2) {
        NSMutableArray *addresses = [NSMutableArray arrayWithCapacity:_serviceAdressArray.count];
        for (NSUInteger i = 0; i < _serviceAdressArray.count; i++) {
            ITServiceCategoryModel *model = _serviceAdressArray[i];
            [addresses addObject:model.name];
        }
        titles = addresses;
    }
    return titles;
}

- (CGPoint)popMenuViewOrigin:(CGPoint)point menuWidth:(CGFloat)menuWidth {
    CGFloat width = 200.f;
    CGFloat originX = 0.f;
    if (point.x - width/2 > 20.f && point.x + width/2 + 20 < SCREEN_WIDTH) {
        originX = point.x - width/2;
    } else if(point.x - width/2 < 20.f) {
        originX = 20.f;
    } else if (point.x + width/2 + 20 > SCREEN_WIDTH) {
        originX = SCREEN_WIDTH-menuWidth-20.f;
    }
    return CGPointMake(originX, point.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    PaiGongCell *cell = [PaiGongCell createCell:tableView indexPath:indexPath];
//    ITServiceModel *model = self.dataSourse[indexPath.row];
//    [cell configWithTitle:model.serviceContent address:model.serviceAddress serviceTime:model.serviceTime technologyType:[model getTechnicalDirectionString]];
//    [cell configWithTitle:@"sdfsfjll" address:@"dhkskjhskfksdg" serviceTime:@"fhjsdhfkjh" technologyType:@"sakjhkjhfksahkasgkashjfa"];
//    return cell;
    ITSearviceViewCell *cell = [ITSearviceViewCell create:tableView indexPath:indexPath];
    cell.serModel = self.dataSourse[indexPath.row];
    return cell;
//    ITServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITServiceCell" forIndexPath:indexPath];
//    [cell makeITServiceCellWithModel:self.dataSourse[indexPath.row]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    return cell;
}

- (void)loadAllProductListRequest:(LoadListWay)loadWay {
    
    NSString *url = [NSString stringWithFormat:@"%@%@?pageNumber=%zd&pagesize=20",DOMAIN_NAME,API_GET_ITSERVER,self.loadPage];
    if (![_serviceTypeId isEqualToString:NOT_SELECTED_CATEGORY]) {
        url = [NSString stringWithFormat:@"%@&businessType=%@", url, _serviceTypeId];
    }
    if (![_technicalDirectionId isEqualToString:NOT_SELECTED_CATEGORY]) {
        url = [NSString stringWithFormat:@"%@&technicalDirection=%@", url, _technicalDirectionId];
    }
    if (![_serviceAdressId isEqualToString:NOT_SELECTED_CATEGORY]) {
        url = [NSString stringWithFormat:@"%@&serviceAddress=%@", url, _serviceAdressId];
    }
    
    NSLog(@"%@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = responseObject[@"data"];
        NSMutableArray *list = [NSMutableArray array];
        
        for (NSDictionary *dic in arr) {
            ITServiceModel *model = [ITServiceModel modelWithDictionary:dic];
            [list addObject:model];
        }
        [self dealWithListDataAndRefresh:loadWay listData:list];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"加载失败  ** %@",error);
    }];
}

- (void)reloadScreenData {
    [self loadServiceAddress];
}

- (void)loadServiceAddress {
    NSString *url = API_GET_DICT_PROVINCE;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSArray *list = [result getDataObj];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
            NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:list.count];
            ITServiceCategoryModel *item = [[ITServiceCategoryModel alloc] init];
            item.id = @(-1011);
            item.name = @"全部";
            [array addObject:item];
            for (NSUInteger i = 0; i < list.count; i++) {
                [array addObject:[ITServiceCategoryModel modelWithDictionary:list[i]]];
                [array1 addObject:[CommonItemModel createModel:list[i] andKeyWord:@"服务地点"]];
            }
            _serviceAdressArray = array;
            self.addressCategorys = array1;
            [self makeZYSide];
            self.isPopScreen = true;
        }
    }];
}

#pragma mark 重写父类的方法
// 下拉刷新
- (void)pullRefresh {
    [super pullRefresh];
    [self loadAllProductListRequest:LoadListWayRefresh];
}

// 上拉加载
- (void)pullLoadMore {
    [super pullLoadMore];
    [self loadAllProductListRequest:LoadListWayMore];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    ITServiceModel *model = self.dataSourse[indexPath.row];
    //追加
    //    DealViewController *vc = [[DealViewController alloc]init];
    //    vc.headerTitle = @"个人交易记录";
    //第一版
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc] init];
    vc.userid = [NSString stringWithFormat:@"%@",model.userid];
    vc.id = [model.id integerValue];
    vc.orderSn = model.orderSn;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 点击提交后响应
- (void)commit:(NSArray<CommonItemModel *> *)screens {
    _serviceTypeId = NOT_SELECTED_CATEGORY;
    _serviceAdressId = NOT_SELECTED_CATEGORY;
    _technicalDirectionId = NOT_SELECTED_CATEGORY;
    [_screenHeaderView setTitle:@"服务类型" index:0];
    [_screenHeaderView setTitle:@"技术方向" index:1];
    [_screenHeaderView setTitle:@"服务地点" index:2];
    for (NSUInteger i = 0; i < screens.count; i++) {
        CommonItemModel *model = [screens objectAtIndex:i];
        if ([model.keyWord isEqualToString:@"服务类型"]) {
            _serviceTypeId = model.itemId;
            if (model.itemId.intValue == -1011) {
                [_screenHeaderView setTitle:@"服务类型" index:0];
            } else {
                [_screenHeaderView setTitle:model.itemName index:0];
            }
        } else if ([model.keyWord isEqualToString:@"技术方向"]) {
            _technicalDirectionId = model.itemId;
            if (model.itemId.intValue == -1011) {
                [_screenHeaderView setTitle:@"技术方向" index:1];
            } else {
                [_screenHeaderView setTitle:model.itemName index:1];
            }
        } else if ([model.keyWord isEqualToString:@"服务地点"]) {
            _serviceAdressId = model.itemName;
            if (model.itemId.intValue == -1011) {
                [_screenHeaderView setTitle:@"服务地点" index:2];
            } else {
                [_screenHeaderView setTitle:model.itemName index:2];
            }
        }
    }
    self.loadPage = 1;
    [self loadAllProductListRequest:LoadListWayDefault];
}

@end
