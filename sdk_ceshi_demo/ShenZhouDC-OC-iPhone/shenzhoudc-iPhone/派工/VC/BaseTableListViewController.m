//
//  BaseTableListViewController.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "BaseTableListViewController.h"
#import "PaiTableViewCell.h"
#import "CommonMacro.h"
#import "MoreViewController.h"
#import "AINetworkEngine.h"
#import "PaiModel.h"
#import "DetailPaiViewControllerView.h"
#import "RequirementDetailViewController.h"
#import "DetailPaiCollectionViewControllerView.h"
#import "DetailAssessViewController.h"
#define BOUND_Width [UIScreen mainScreen].bounds.size.width
#define BOUND_Height [UIScreen mainScreen].bounds.size.height
@interface BaseTableListViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation BaseTableListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUi];
    
}



- (void)setUpUi{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,BOUND_Width , BOUND_Height - 157) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [self creatFooterView];
    [self.view addSubview:_tableView];
   
}

- (UIView*)creatFooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = UIColorFromRGB(0xD71629);
    [btn setTitle:@"更多派工" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(clickMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

- (void)clickMoreEvent:(UIButton*)sender{
//    RequirementDetailViewController *vc = [[RequirementDetailViewController alloc]init];
    MoreViewController *vc = [[MoreViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _dataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaiTableViewCell *cell = [PaiTableViewCell customCellWithTableView:tableView andIndexPath:indexPath];
    cell.model = self.dataSourse[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewLine = [[UIView alloc]init];
    viewLine.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    return viewLine;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaiModel *model = _dataSourse[indexPath.row];
//    DetailPaiViewControllerView *vc = [[DetailPaiViewControllerView alloc]init];
    DetailAssessViewController *vc = [[DetailAssessViewController alloc]init];
    vc.DetailAssessRefreshBlcok = ^(){
        if (_baseRefreshBlcok) {
            _baseRefreshBlcok();
        }
    };
//    vc.refreshBlcok = ^(){
//        if (_baseRefreshBlcok) {
//            _baseRefreshBlcok();
//        }
//    };
    vc.ID = [model.id intValue];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (NSMutableArray *)dataSourse{
//    if (!_dataSourse) {
//        _dataSourse = [NSMutableArray array];
//    }
//    return _dataSourse;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
