//
//  MyPlanViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MyPlanViewController.h"
#import "JieJueTableViewCell.h"
#import "JieJueDetailsViewController.h"
#import "IssueSolutionStatusViewController.h"
#import "SolutionBuyModel.h"
#import "SolutionPublishModel.h"
#import "BuySolutionCell.h"
#import "PublishSolutionCell.h"
#import "PublishSolutionOperateCell.h"
#import "ChargeViewController.h"
#import "MeChooseMenuView.h"

@interface MyPlanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *leftBtn;
    UIButton *rightBtn;
}
@property(nonatomic , assign) int planType;//派工类型 0.我购买的 1.我发布的
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *buySolutionList;
@property (strong, nonatomic) NSMutableArray *publishSolutionList;
@property (assign, nonatomic) NSInteger buyLoadPage;
@property (assign, nonatomic) NSInteger publishLoadPage;
@property (assign, nonatomic) NSInteger loadSize;
@end

@implementation MyPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的方案";
    _buySolutionList = @[].mutableCopy;
    _publishSolutionList = @[].mutableCopy;
    _buyLoadPage = 1;
    _publishLoadPage = 1;
    _loadSize = 20;
    [self makeUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.planType = 0;
    if (leftBtn) {
        leftBtn.selected = YES;
    }
    [self loadBuySolutionList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [leftBtn setTitle:@"已购买" forState:UIControlStateNormal];
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
//点击 我的购买
-(void)clickLeftBtn:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        rightBtn.selected = NO;
        _planType = 0;
        [_tableView reloadData];
        if (!_buySolutionList || _buySolutionList.count == 0) {
            [self loadBuySolutionList];
        }
    }
    NSLog(@"%d",_planType);
}
//点击 我的发布
-(void)clickRightBtn :(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        leftBtn.selected = NO;
        _planType = 1;
        [_tableView reloadData];
        if (!_publishSolutionList || _publishSolutionList.count == 0) {
            [self loadPublishSolutionList];
        }
    }
    NSLog(@"%d", _planType);
    
}

-(void)makeUI {
    
    MeChooseMenuView *menuView = [[MeChooseMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) titles:@[@"已购买", @"已发布"]];
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(IS_IPAD ? 55 : 45);
        
    }];
    menuView.clickItemBlock = ^(NSUInteger index) {
        _planType = (int)index;
        if (_planType == 0) {
            if (!_buySolutionList || _buySolutionList.count == 0) {
                [self loadBuySolutionList];
            }
        } else {
            if (!_publishSolutionList || _publishSolutionList.count == 0) {
                [self loadPublishSolutionList];
            }
        }
        [_tableView reloadData];
    };

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45+TOPBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-45)];
    self.tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 117;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(menuView.mas_bottom);
    }];
    if (self.type == 1){
//        self.tableView.tableHeaderView = [self makeHeadView];
    }
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadPageSetOne:weakSelf.planType];
        [weakSelf loadBuyOrPublishList];
    }];
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf increaseLoadPage:weakSelf.planType];
        [weakSelf loadBuyOrPublishList];
    }];
}

- (void)loadPageSetOne:(int)type {
    if(type == 0) {
        _buyLoadPage = 1;
    } else {
        _publishLoadPage = 1;
    }
}

- (void)increaseLoadPage:(int)type {
    if(type == 0) {
        ++_buyLoadPage;
    } else {
        ++_publishLoadPage;
    }
}

- (void)subtractLoadPage:(int)type {
    if(type == 0) {
        if (_buyLoadPage > 1) {
            --_buyLoadPage;
        }
    } else {
        if (_publishLoadPage > 1) {
            --_publishLoadPage;
        }
    }
}

- (void)loadBuyOrPublishList {
    if (_planType == 0) {
        [self loadBuySolutionList];
    } else {
        [self loadPublishSolutionList];
    }
}

//MARK: UITableViewDelegate ----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_planType == 0) {
        return _buySolutionList.count;
    }
    return _publishSolutionList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_planType == 0) {
        BuySolutionCell *cell = [BuySolutionCell createCellWithTableView:tableView];
        cell.buyModel = _buySolutionList[indexPath.row];
        return cell;
    } else {
        SolutionPublishModel *model = _publishSolutionList[indexPath.row];
        if (model.checkStatus.intValue == 1) {
            PublishSolutionOperateCell *cell = [PublishSolutionOperateCell createWithTableView:tableView indexPath:indexPath];
            cell.publishModel = model;
            cell.clickBtnBlock = ^(SolutionPublishModel *publishModel) {
                [self surePay:publishModel];
            };
            return cell;
        } else {
            PublishSolutionCell *cell = [PublishSolutionCell createWithTableView:tableView indexPath:indexPath];
            cell.publishModel = model;
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_planType == 1) {
        SolutionPublishModel *model = _publishSolutionList[indexPath.row];
        if (model.checkStatus.intValue == 1) {
            return 148;
        } else {
            return 108;
        }
    }
    return 108;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (_planType == 1) {
        JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc]init];
        SolutionPublishModel *model = _publishSolutionList[indexPath.row];
        vc.id = model.id.stringValue;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_planType == 0) {
        SolutionBuyModel *model = _buySolutionList[indexPath.row];
        if (model.type.intValue == 1) { // 完整版方案
            JieJueDetailsViewController *vc = [[JieJueDetailsViewController alloc]init];
            vc.id = model.id.stringValue;
            vc.isShowEvaluate = true;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (model.type.intValue == 2) { // 交钥匙方案
            
        }
    }
}

- (void)loadBuySolutionList {
    NSLog(@"--- 购买");
    NSLog(@"购买 %zd， 发布 %zd", _buyLoadPage, _publishLoadPage);
    
    [[AINetworkEngine sharedClient] setRequestHeaderValue:[UserModel sharedModel].userId headerKey:@"userId"];
    NSString *url = [NSString stringWithFormat:@"%@?pageNumber=%zd&pageSize=%zd", API_GET_BUY_SLOUTION_LIST, _buyLoadPage, _loadSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result.isSucceed) {
            NSMutableArray *list = [NSMutableArray array];
            NSDictionary *dict = [result getDataObj];
            if ([dict.allKeys containsObject:@"data"]) {
                NSArray *array = dict[@"data"];
                for (int i = 0; i < array.count; i++) {
                    SolutionBuyModel *model = [SolutionBuyModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                if (_buyLoadPage == 1) {
                    self.buySolutionList = list;
                } else {
                    for (NSUInteger i = 0; i < list.count; i++) {
                        [_buySolutionList addObject:list[i]];
                    }
                }
                
                [self.tableView reloadData];
            }
        } else {
            [self subtractLoadPage:0];
        }
    }];
}

- (void)loadPublishSolutionList {
    NSLog(@"--- 发布");
    NSLog(@"购买 %zd， 发布 %zd", _buyLoadPage, _publishLoadPage);
    [[AINetworkEngine sharedClient] setRequestHeaderValue:[UserModel sharedModel].userId headerKey:@"userId"];
    NSString *url = [NSString stringWithFormat:@"%@?pageNumber=%zd&pageSize=%zd", API_GET_PUBLISH_SLOUTION_LIST, _publishLoadPage, _loadSize];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result.isSucceed) {
            NSMutableArray *list = [NSMutableArray array];
            NSDictionary *dict = [result getDataObj];
            if ([dict.allKeys containsObject:@"data"]) {
                NSArray *array = dict[@"data"];
                for (int i = 0; i < array.count; i++) {
                    SolutionPublishModel *model = [SolutionPublishModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                if (_buyLoadPage == 1) {
                    self.publishSolutionList = list;
                } else {
                    for (NSUInteger i = 0; i < list.count; i++) {
                        [_publishSolutionList addObject:list[i]];
                    }
                }
                [self.tableView reloadData];
            }
        } else {
            [self subtractLoadPage:1];
        }
    }];
}

- (void)surePay:(SolutionPublishModel *)model {
    [self showLoadingToView:self.view];
    [[AINetworkEngine sharedClient] setRequestHeaderValue:[UserModel sharedModel].userId headerKey:@"userId"];
    [[AINetworkEngine sharedClient] setRequestHeaderValue:model.id.stringValue headerKey:@"solutionId"];
    [[AINetworkEngine sharedClient] postWithApi:API_POST_SOLUTION_CONFIRM_PAYMENT parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result) {
            [self showSuccess:self.view message:result.getMessage afterHidden:2];
            if (result.isSucceed) {
                [self showSuccess:self.view message:result.getMessage afterHidden:2];
                [self loadPublishSolutionList];
            } else if (result.getCode == 1002) {
                [self showError:self.view message:result.getMessage afterHidden:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ChargeViewController *vc = [[ChargeViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = true;
                    [self.navigationController pushViewController:vc animated:true];
                });
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}

@end
