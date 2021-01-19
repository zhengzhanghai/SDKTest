//
//  SearchViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SearchViewController.h"
#import "JieJueTableViewCell.h"
#import "JieJueDetailsViewController.h"
#import "SolutionSearchCategoryModel.h"
#import "PlanModel.h"
#import "CollectionViewCell.h"
#define TOP_HEIGHT 64
#define ROW_CELL_COUNT  (IS_IPAD ? 4 : 2)
#define CELL_MARGIN     10

@interface SearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UITableView *searchResultTableView;
@property (strong, nonatomic) UICollectionView *searchResultCollectionView;
@property (strong, nonatomic) NSMutableArray *resultArray;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *searchTableView;
@property (copy, nonatomic)   NSArray *priceSortBtnArr;
@property (copy, nonatomic)   NSArray *searchCategoryArr;
@property (copy, nonatomic)   NSString *searchSortStr;
@property (copy, nonatomic)   NSString *searchCategoryId;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSearchView];
    [self makeSearchContentView];
    [self makeTableView];
    [self loadSearchCategory];
}

- (void)loadSearchCategory {
    NSString *url = API_GET_SOLUTION_SEARCH_CATEGORY;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSArray *list = result.getDataObj;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
            for (NSUInteger i = 0; i < list.count; i++) {
                [array addObject:[SolutionSearchCategoryModel modelWithDictionary:list[i]]];
            }
            _searchCategoryArr = array;
            [_searchTableView reloadData];
        }
    }];
    
}

- (void)addSearchView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_HEIGHT)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIView *bottomLine = [[UIView alloc] init];
    [topView addSubview:bottomLine];
    bottomLine.frame = CGRectMake(0, TOP_HEIGHT-0.5, SCREEN_WIDTH, 0.5);
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(15, 25, 30, 30);
    [cancelBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 25, SCREEN_WIDTH-65, 30)];
    _searchBar.placeholder = @"请输入名称";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [topView addSubview:_searchBar];
}

- (void)makeSearchContentView {
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP) style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.tableFooterView = [[UIView alloc] init];
    _searchTableView.tag = 1011;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_searchTableView];
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    tableHeader.backgroundColor = [UIColor whiteColor];
    _searchTableView.tableHeaderView = tableHeader;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 40, 30)];
    priceLabel.text = @"价格";
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    [tableHeader addSubview:priceLabel];
    
    
    NSArray *sortTitles = @[@"升序", @"降序"];
    NSMutableArray *btnAr = [NSMutableArray arrayWithCapacity:sortTitles.count];
    for (NSUInteger i = 0; i < sortTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(65+i*(70+30), 10, 70, 30);
        button.tag = i;
        button.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        button.layer.borderWidth = 0.5;
        button.clipsToBounds = true;
        button.layer.cornerRadius = 6;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:sortTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
        [tableHeader addSubview:button];
        [btnAr addObject:button];
    }
    _priceSortBtnArr = btnAr;
}

- (void)clickSortButton:(UIButton *)button {
    button.selected = true;
    if (button.tag == 0) {
        [self priceBtnSetSelected:_priceSortBtnArr[0]];
        [self priceBtnSetDisSelected:_priceSortBtnArr[1]];
        _searchSortStr = @"0";
    } else {
        [self priceBtnSetSelected:_priceSortBtnArr[1]];
        [self priceBtnSetDisSelected:_priceSortBtnArr[0]];
        _searchSortStr = @"1";
    }
}

- (void)priceBtnSetSelected:(UIButton *)button {
    button.selected = true;
    button.backgroundColor = MainColor;
    button.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)priceBtnSetDisSelected:(UIButton *)button {
    button.selected = false;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
}

- (void)makeTableView {
    _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP) style:UITableViewStylePlain];
    _searchResultTableView.delegate = self;
    _searchResultTableView.dataSource = self;
    _searchResultTableView.tag = 1010;
    _searchResultTableView.tableFooterView = [[UIView alloc] init];
    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

// 搜索
- (void)search {
    NSString *url = [NSString stringWithFormat:@"%@", API_GET_SOLUTION_LIST];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_searchCategoryId && ![_searchCategoryId isEqualToString:@""]) {
        params[@"industryId"] = _searchCategoryId;
    }
    if (_searchSortStr && ![_searchSortStr isEqualToString:@""]) {
        params[@"price"] = _searchSortStr;
    }
    if (![_searchBar.text isEqualToString:@""]) {
        params[@"input"] = _searchBar.text;
    }
    [[AINetworkEngine sharedClient] getWithApi:url parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSDictionary *dict = [result getDataObj];
            if ([dict.allKeys containsObject:@"data"]) {
                NSArray *list = dict[@"data"];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
                for (int i = 0; i < list.count; i++) {
                    PlanModel *model = [PlanModel modelWithDictionary:list[i]];
                    [array addObject:model];
                }
                self.resultArray = array;
//                [_searchResultTableView reloadData];
                [self.searchResultCollectionView reloadData];
            }
        }
    }];
}

// 取消点击
- (void)clickCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[UIApplication sharedApplication].delegate.window endEditing:true];
    _resultArray = @[].mutableCopy;
    _searchCategoryId = @"";
    [self.view addSubview:self.searchResultCollectionView];
    [self.searchResultCollectionView reloadData];
    [self search];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addSubview:_searchTableView];
}

#pragma mark: tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1011) {
        return _searchCategoryArr.count;
    }
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1011) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"searchIdentifier"];
        }
        cell.textLabel.text = [_searchCategoryArr[indexPath.row] tradeType];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        return cell;
    }
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
    [cell refreshWithPlan:self.resultArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1011) {
        return 50;
    }
    return 116.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication].delegate.window endEditing:true];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (tableView.tag == 1011) {
        SolutionSearchCategoryModel *model = _searchCategoryArr[indexPath.row];
        _searchCategoryId = model.id.stringValue;
        _searchBar.text = @"";
        _resultArray = @[].mutableCopy;
        [self.searchResultCollectionView reloadData];
        [self.view addSubview:self.searchResultCollectionView];
        [self search];
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1011) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 70, 20)];
    priceLabel.text = @"类型";
    priceLabel.textColor = UIColorFromRGB(0x787878);
    priceLabel.font = [UIFont boldSystemFontOfSize:14];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:priceLabel];
    return view;
}

- (UICollectionView *)searchResultCollectionView {
    if (!_searchResultCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT,
                                         (SCREEN_WIDTH-(ROW_CELL_COUNT+1)*CELL_MARGIN)/ROW_CELL_COUNT*126/166+60);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _searchResultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP) collectionViewLayout:flowLayout];
        _searchResultCollectionView.backgroundColor = [UIColor whiteColor];
        _searchResultCollectionView.delegate = self;
        _searchResultCollectionView.dataSource = self;
    }
    return _searchResultCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _resultArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [CollectionViewCell create:collectionView indexPath:indexPath];
    cell.model = _resultArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.2];
        return;
    }
    JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc] init];
    JieJueModel *model = _resultArray[indexPath.row];
    vc.price = model.price.floatValue;
    vc.id = model.id.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushControllerHiddenTabbar:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
