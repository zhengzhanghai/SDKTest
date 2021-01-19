//
//  ListBaseTableViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ListBaseTableViewController.h"
#import "JieJueDetailsViewController.h"
#import "JieJueMoreViewController.h"
#import "JieJueTableViewCell.h"
#import "HomeTabaleHeaderView.h"
#import "CollectionViewCell.h"
#import "SolutionCollectionHeaderView.h"
#import "SolutionCollectionFooterView.h"
#import "SolutionCollectionCycleCell.h"

#define ROW_CELL_COUNT  (IS_IPAD ? 4 : 2)
#define CELL_MARGIN     10

@interface ListBaseTableViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) HomeTabaleHeaderView *tableViewHeaderView;
@end

@implementation ListBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeCollectionView];
}

/**
 *  创建列表
 */
-(void)makeTable{
    //height:  SCREEN_HEIGHT-TABBARHEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT-33
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style: UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
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
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*117/375) delegate:self placeholderImage:[UIImage imageNamed:@"轮播默认图"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    tableView.tableHeaderView = cycleScrollView;
}

    
- (void)pullRefresh {
    
}

/**
 *  更多按钮
 */
-(void)makeMoreBtn{
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake(0, 450, SCREEN_WIDTH, 65);
    more.backgroundColor = MainColor;
    [more setTitle:@"更多" forState:UIControlStateNormal];
    [more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:more];
}

//MARK: ____________ tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
    [cell refreshCell:self.dataSourse[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.2];
        return;
    }
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableViewHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return IS_IPAD ? 55 :40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.moreButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//MARK: tableView 头视图
- (HomeTabaleHeaderView *)tableViewHeaderView {
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[HomeTabaleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) andTitles:self.headerTitles];
        __weak ListBaseTableViewController *weakSelf = self;
        _tableViewHeaderView.titleBlpck = ^(NSInteger index) {
            [weakSelf headerAction:index];
        };
    }
    return _tableViewHeaderView;
}

// 点击tableview头视图标题响应事件， 子类中去重写
- (void)headerAction:(NSInteger)index {
    
}

- (NSArray *)headerTitles {
    if (!_headerTitles) {
        _headerTitles = @[@"最新方案" , @"推荐方案",  @"热门方案"];
    }
    return _headerTitles;
}

- (NSString *)footerTitle {
    if (!_footerTitle) {
        _footerTitle = @"更多方案";
    }
    return _footerTitle;
}

- (UIButton *)moreButton {
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    more.backgroundColor = MainColor;
    [more setTitle:self.footerTitle forState:UIControlStateNormal];
    [more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    return more;
}

-(void)moreClick{
    JieJueMoreViewController *vc = [[JieJueMoreViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[SolutionCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SolutionCollectionHeaderView"];
    [_collectionView registerClass:[SolutionCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SolutionCollectionFooterView"];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self pullRefresh];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _collectionView.mj_header = header;
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (_adsArray && _adsArray.count > 0) {
            return 1;
        } else {
            return 0;
        }
    }
    return _dataSourse.count;
}
    
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SolutionCollectionCycleCell *cell = [SolutionCollectionCycleCell create:collectionView indexPath:indexPath];
        cell.adsArray = _adsArray;
        return cell;
    } else {
        CollectionViewCell *cell = [CollectionViewCell create:collectionView indexPath:indexPath];
        cell.model = _dataSourse[indexPath.row];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*117/375);
    }
    return CGSizeMake((SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT,
                      (SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT*126/166+60);
}
    
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.2];
        return;
    }
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc]init];
    JieJueModel *model = self.dataSourse[indexPath.row];
    vc.price = model.price.floatValue;
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, IS_IPAD ? 55 : 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, IS_IPAD ? 55 : 40);
}
    
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--------- %zd", indexPath.section);
    __weak typeof(self) weakSelf = self;
    if (kind == UICollectionElementKindSectionHeader) {
        SolutionCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SolutionCollectionHeaderView" forIndexPath:indexPath];
        header.titleBlpck = ^(NSInteger index) {
            [weakSelf headerAction:index];
        };
        return header;
    } else {
        SolutionCollectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SolutionCollectionFooterView" forIndexPath:indexPath];
        footer.clickMoreBlock = ^{
            [weakSelf moreClick];
        };
        return footer;
    }
}
@end
