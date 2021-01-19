//
//  ProductListController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductListController.h"
#import "NetAPI.h"
#import "ChanPinTableViewCell.h"
#import "ChanPinModel.h"
#import "ChanPinDetailsWEBController.h"
#import "ProductDetailsController.h"
#import "ProductFiltrateView.h"
#import "VideoPlayViewController.h"
#import "AppDelegate.h"
#import "CollectionViewCell.h"
#import "ProductCollectionCell.h"
#import "ProductScreenView.h"

#define ROW_CELL_COUNT  (IS_IPAD ? 4 : 2)
#define CELL_MARGIN     10

@interface ProductListController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) ProductFiltrateView *filtrateView;
@property (copy, nonatomic)   NSString *filtrateId;
@property (copy, nonatomic)   NSString *filtrateName;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *screenBtn;
@end

@implementation ProductListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _categoryName;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self makeTable];
//    [self.view addSubview:self.tableView];
    [self makeCollectionView];
    [self makeFiltrateBtn];
    [self loadAllProductListRequest:LoadListWayDefault];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self pullRefresh];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _collectionView.mj_header = header;
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self pullLoadMore];
    }];
    footer.automaticallyHidden = NO;
    self.collectionView.mj_footer = footer;
    [self.view addSubview:_collectionView];
}

- (void)makeFiltrateBtn {
    _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _screenBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _screenBtn.clipsToBounds = true;
    _screenBtn.layer.cornerRadius = 46;
    [_screenBtn addTarget:self action:@selector(clickFiltrateBtn) forControlEvents:UIControlEventTouchUpInside];
    [_screenBtn setImage:[UIImage imageNamed:@"product_screen_icon"] forState:UIControlStateNormal];
    [self.view addSubview:_screenBtn];
    [_screenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
        make.width.height.mas_equalTo(92);
    }];
    self.navigationItem.rightBarButtonItem = nil;
    
//    UIButton *filtrateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    filtrateBtn.frame = CGRectMake(0, 0, 50, 30);
//    [filtrateBtn setTitle:@"筛选" forState:UIControlStateNormal];
//    [filtrateBtn setTitleColor:MainColor forState:UIControlStateNormal];
//    [filtrateBtn addTarget:self action:@selector(clickFiltrateBtn) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *filtrateItem = [[UIBarButtonItem alloc] initWithCustomView:filtrateBtn];
//    self.navigationItem.rightBarButtonItem = filtrateItem;
}

- (void)clickFiltrateBtn {
    _screenBtn.userInteractionEnabled = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _screenBtn.userInteractionEnabled = true;
    });
    ProductScreenView *screenView = [[ProductScreenView alloc] initWithFrame:CGRectMake(0, CONTENTHEIGHT_NOTOP, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP)];
    screenView.didSelectedBlock = ^(NSUInteger index) {
        _filtrateId = [NSString stringWithFormat:@"%zd", index+1];
        _filtrateName = nil;
        self.loadPage = 1;
        [self loadAllProductListRequest:LoadListWayDefault];
        NSLog(@"99999----%zd", index);
    };
    [self.view addSubview:screenView];
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.window.rootViewController.view addSubview:self.filtrateView];
//    [_filtrateView showWithAnimated:true];
}

- (void)loadAllProductListRequest:(LoadListWay)loadWay {
    NSString *url = [NSString stringWithFormat:@"%@%@%@", DOMAIN_NAME,API_GETFILETYPE, _categoryId];
    url = [NSString stringWithFormat:@"%@?pageNumber=%zd&pageSize=%zd", url, self.loadPage, LoadSize];
    if (_filtrateId && ![_filtrateId isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"%@&dataType=%@", url, _filtrateId];
    }
    if (_filtrateName && ![_filtrateName isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"%@&dataTitle=%@", url, _filtrateName];
    }
    
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *dict = [result getDataObj];
                NSArray *array = dict[@"data"];
                for (int i = 0; i < array.count; i++) {
                    ChanPinModel *model = [ChanPinModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                [self dealWithListDataAndRefresh:loadWay listData:list];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}

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

- (void)dianZanOrCai:(NSIndexPath *)indexPath type:(int)type {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:2.f];
        [self setCellBtnUserInteractionEnabled:indexPath type:type];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", DOMAIN_NAME, API_POST_SOURCE_DIANZAN];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ChanPinModel *model = self.dataSourse[indexPath.row];
    params[@"id"] = model.id.stringValue;
    if (type == 0) {
        params[@"type"] = @"2";
    } else {
        params[@"type"] = @"1";
    }
    params[@"userId"] = [[UserModel sharedModel] userId];
    [[AINetworkEngine sharedClient] postWithApi:url parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                [self loadAllProductListRequest:LoadListWayDefault];
            } else {
                [self setCellBtnUserInteractionEnabled:indexPath type:type];
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        } else {
            [self showError:self.view message:@"点赞或踩失败" afterHidden:2];
            [self setCellBtnUserInteractionEnabled:indexPath type:type];
        }
    }];
}

- (void)setCellBtnUserInteractionEnabled:(NSIndexPath *)indexPath type:(int)type {
    ProductCollectionCell *cell = (ProductCollectionCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    if (type == 0) {
        cell.badBtn.userInteractionEnabled = true;
    } else {
        cell.priseBtn.userInteractionEnabled = true;
    }
}

//- (void)dianZanOrCai:(NSString *)sourceId type:(NSString *)type {
//    if (![UserModel isLogin]) {
//        [self showError:self.view message:@"请先登录" afterHidden:2.f];
//        return;
//    }
//    NSString *url = [NSString stringWithFormat:@"%@%@", DOMAIN_NAME, API_POST_SOURCE_DIANZAN];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"id"] = sourceId;
//    params[@"type"] = type;
//    params[@"userId"] = [[UserModel sharedModel] userId];
//    
//    [[AINetworkEngine sharedClient] postWithApi:url parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
//        if (result) {
//            if (result.isSucceed) {
//                [self loadAllProductListRequest:LoadListWayDefault];
//            } else {
//                [self showError:self.view message:result.getMessage afterHidden:2.f];
//            }
//        } else {
//            
//        }
//    }];
//}

- (ProductFiltrateView *)filtrateView {
    if (!_filtrateView) {
        _filtrateView = [[ProductFiltrateView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _filtrateView.finishFiltrateBlock = ^(NSString *filtrateId, NSString *filtrateName) {
            if (filtrateId && ![filtrateId isEqualToString:@""]) {
                weakSelf.filtrateId = filtrateId;
                weakSelf.loadPage = 1;
                weakSelf.filtrateName = nil;
                [weakSelf loadAllProductListRequest:LoadListWayDefault];
            }
        };
        _filtrateView.finishFiltrateWithNameBlock = ^(NSString *filtrateName) {
            if (filtrateName && ![filtrateName isEqualToString:@""]) {
                weakSelf.filtrateName = filtrateName;
                weakSelf.loadPage = 1;
                weakSelf.filtrateId = nil;
                [weakSelf loadAllProductListRequest:LoadListWayDefault];
            }
        };
    }
    return _filtrateView;
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
    ChanPinModel *model = self.dataSourse[indexPath.row];
    if (model.dataType.integerValue == 3) {
        ProductDetailsController *vc = [[ProductDetailsController alloc] init];
        vc.productId = model.id.stringValue;
        vc.dataURL = model.dataUrl;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if ([model.dataUrl rangeOfString:@".mp3"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".pdf"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".jpg"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".png"].location != NSNotFound) {
            ChanPinDetailsWEBController *vc = [[ChanPinDetailsWEBController alloc]init];
            vc.loadURLString = model.dataUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
            vc.videoURL = [NSURL URLWithString:model.dataUrl];
            vc.titleTxt = model.dataTitle;
            vc.downloadUrlStr = model.dataUrl;
            vc.downloadIcon = model.dataIcon;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinTableViewCell *cell = [ChanPinTableViewCell cell:tableView indexPath:indexPath];
    [cell config:self.dataSourse[indexPath.row]];
    cell.clickZanOrCaiBlock = ^(NSString *sourceId, NSString *type) {
//        [self dianZanOrCai:sourceId type:type];
    };
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCollectionCell *cell = [ProductCollectionCell create:collectionView indexPath:indexPath];
    cell.productModel = self.dataSourse[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.clickItemBlock = ^(int type, NSIndexPath *inPath) {
        [weakSelf dianZanOrCai:indexPath type:type];
        NSLog(@"  %d  ----  %zd", type, inPath.row);
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT,
                      (SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT*126/166+60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChanPinModel *model = self.dataSourse[indexPath.row];
    if (model.dataType.integerValue == 3) {
        ProductDetailsController *vc = [[ProductDetailsController alloc] init];
        vc.productId = model.id.stringValue;
        vc.dataURL = model.dataUrl;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if ([model.dataUrl rangeOfString:@".mp3"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".pdf"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".jpg"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".png"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".gif"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".bmp"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".jpeg"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".tiff"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".psd"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".swf"].location != NSNotFound
            || [model.dataUrl rangeOfString:@".svg"].location != NSNotFound) {
            ChanPinDetailsWEBController *vc = [[ChanPinDetailsWEBController alloc]init];
            vc.loadURLString = model.dataUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
            vc.videoURL = [NSURL URLWithString:model.dataUrl];
            vc.titleTxt = model.dataTitle;
            vc.downloadUrlStr = model.dataUrl;
            vc.downloadIcon = model.dataIcon;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
