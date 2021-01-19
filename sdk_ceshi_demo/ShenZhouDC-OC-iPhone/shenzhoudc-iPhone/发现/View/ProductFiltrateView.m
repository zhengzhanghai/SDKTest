//
//  ProductFiltrateView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductFiltrateView.h"

#define Titles @[@{@"1": @"资源"}, \
                 @{@"2": @"视频"}, \
                 @{@"3": @"产品"}]

@interface ProductFiltrateView ()<UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation ProductFiltrateView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}


- (void)makeUI {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-20, 40)];
    _searchBar.placeholder = @"请输入要查找的名称";
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = true;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    UIView *searBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    [searBGView addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
    _tableView.tableHeaderView = searBGView;
}

- (void)removeFromSuperviewWithAnimated:(BOOL)animated {
    [_searchBar resignFirstResponder];
    self.y = 0;
    [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showWithAnimated:(BOOL)animated {
    self.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
        self.y = 0;
    } completion:^(BOOL finished) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductFiltrateViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductFiltrateViewCell"];
    }
    NSDictionary *dict = Titles[indexPath.row];
    cell.textLabel.text = [dict.allValues firstObject];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_finishFiltrateBlock) {
        _finishFiltrateBlock([[Titles[indexPath.row] allKeys] firstObject], [[Titles[indexPath.row] allValues] firstObject]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self removeFromSuperviewWithAnimated:true];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self removeFromSuperviewWithAnimated:true];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (_finishFiltrateWithNameBlock) {
        _finishFiltrateWithNameBlock(searchBar.text);
    }
    [self removeFromSuperviewWithAnimated:true];
}

@end
