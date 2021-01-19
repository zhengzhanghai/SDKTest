//
//  MenuView.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"

@interface MenuView()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@property (copy,   nonatomic) NSArray *titles;
@property (copy,   nonatomic) NSArray *iconNors;
@property (copy,   nonatomic) NSArray *iconSelects;
@property (strong, nonatomic) NSIndexPath *selectIndexPath;
@end

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ([super initWithFrame:frame style:UITableViewStylePlain]) {
        [self initData];
        [self makeSelf];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initData];
        [self makeSelf];
    }
    return self;
}

- (void)initData {
    self.titles = @[@"产品展示", @"派工", @"解决方案", @"报价工具", @"视频中心", @"下载管理"];
    self.iconNors = @[@"", @"", @"", @"", @"", @""];
    self.iconSelects = @[@"", @"", @"", @"", @"", @""];
}

- (void)makeSelf {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectIndexPath = indexPath;
}

#pragma mark  tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [MenuCell menuCell:tableView indexPath:indexPath];
    [cell config:self.titles[indexPath.row] icon:nil];
    if (indexPath.section == _selectIndexPath.section
        && indexPath.row == _selectIndexPath.row) {
        [cell setSelect:self.iconSelects[0]];
        NSLog(@"fghfsdfsdkhvbkl");
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 220;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView cellForRowAtIndexPath:self.selectIndexPath];
    [cell setNorlal:self.iconNors[indexPath.row]];
    MenuCell *seleceCell = [tableView cellForRowAtIndexPath:indexPath];
    [seleceCell setSelect:self.iconSelects[indexPath.row]];
    self.selectIndexPath = indexPath;
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}
@end
