//
//  MyRequireMentViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MyRequireMentViewController.h"
#import "JieJueTableViewCell.h"
#import "JieJueModel.h"
#import "RequirementDetailViewController.h"


@interface MyRequireMentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *leftBtn;
    UIButton *rightBtn;
}
@property(nonatomic , copy) NSNumber *dispatchType;//派工类型 0.我发布的 1.我参与的
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourse;
@end

@implementation MyRequireMentViewController
-(NSMutableArray *)dataSourse {
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return  _dataSourse;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的需求";
    [self makeUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dispatchType = @1;//默认为1
    if (leftBtn) {
        leftBtn.selected = YES;
    }
    [self loadData];
    [self loadingAddCountToView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *)makeHeadView {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LandscapeNumber(65))];
    headView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, LandscapeNumber(30)));
    }];
    
    leftBtn = [[UIButton alloc]init];
    [leftBtn setTitle:@"已参与" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(line.mas_left);
    }];
    
    
    rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"已发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(line.mas_right);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [headView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(headView.mas_bottom);
    }];
    
    
    
    return headView;
}
//点击 我的参与
-(void)clickLeftBtn:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        rightBtn.selected = NO;
        self.dispatchType = @1;
        [self loadData];
        [self loadingAddCountToView:self.view];
    }
    NSLog(@"%@",self.dispatchType);
}
//点击 我的发布
-(void)clickRightBtn :(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        leftBtn.selected = NO;
        self.dispatchType = @0;
        [self loadData];
        [self loadingAddCountToView:self.view];
    }
    NSLog(@"%@",self.dispatchType);
    
}

-(void)makeUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 117;
    [self.view addSubview:self.tableView];
    if (self.type == 1){
        self.tableView.tableHeaderView = [self makeHeadView];
    }
}
//MARK: UITableViewDelegate ----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyRequirementCell *cell = [MyRequirementCell makeMyRequirementCell:tableView WithIndexPath:indexPath];
////    JieJueModel *model = self.dataSourse[indexPath.row];
//    [cell makeMyRequirementCellWithModel:nil];
    
    JieJueTableViewCell *cell = [JieJueTableViewCell jieJueCell:tableView indexPath:indexPath];
    [cell refreshCell:self.dataSourse[indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JieJueModel *model = self.dataSourse[indexPath.row];
    RequirementDetailViewController *vc = [[RequirementDetailViewController alloc]init];
    vc.id = [NSString stringWithFormat:@"%@",model.id];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadData {

        NSString *url = [NSString stringWithFormat:@"%@?userId=%@",API_GET_MY_NEED,[UserBaseInfoModel sharedModel].id];
    
        [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
             [self loadingSubtractCount];
            if (result != nil) {
                if ([result isSucceed]) {
                    
                    NSMutableArray *list = [NSMutableArray array];
                    NSArray *array = [result getDataObj];
                    for (int i = 0; i < array.count; i++) {
                        JieJueModel *model = [JieJueModel modelWithDictionary:array[i]];
                        [list addObject:model];
                    }
                    self.dataSourse = list;
                    [self.tableView reloadData];
                }
            } else {
                NSLog(@"请求失败");
            }
        }];
  
}

@end
