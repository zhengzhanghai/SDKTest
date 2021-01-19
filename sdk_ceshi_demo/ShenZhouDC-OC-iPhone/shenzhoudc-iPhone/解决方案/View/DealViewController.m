//
//  DealViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DealViewController.h"
#import "ParticipateViewController.h"
#import "JoinInViewController.h"
#import "DealRecordCell.h"
#import <WebKit/WebKit.h>

@interface DealViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation DealViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    self.title = @"服务详情";
    [self loadRequese];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DealRecordCell" bundle:nil] forCellReuseIdentifier:@"DealRecordCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 80;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH+30)];
    headView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    
    _webView = [[WKWebView alloc]init];
    _webView.backgroundColor = [UIColor greenColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%ld",DOMAIN_NAME_H5,H5_CONTENT,(long)self.id]]]];
    [headView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left);
        make.top.mas_equalTo(headView.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = self.headerTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_webView.mas_bottom);
        make.left.mas_equalTo(headView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    _tableView.tableHeaderView = headView;
  
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    
    UIButton *participateBtn = [[UIButton alloc]init];
    participateBtn.backgroundColor = MainColor;
    participateBtn.layer.masksToBounds = YES;
    participateBtn.layer.cornerRadius = 4;
    [participateBtn setTitle:@"点击报名" forState:UIControlStateNormal];
    [participateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    participateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [participateBtn addTarget:self action:@selector(clickParticipateBtn) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:participateBtn];
    [participateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footView.mas_centerX);
        make.centerY.mas_equalTo(footView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 40));
    }];
    _tableView.tableFooterView = footView;
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;//self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealRecordCell" forIndexPath:indexPath];
    return cell;
}
- (void)clickParticipateBtn {
    
    UserModel *model = [UserModel sharedModel];
//    if ([model.userType isEqualToString:@"1"]) {
        //当前用户身份是达人
        JoinInViewController *vc = [[JoinInViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
//    }else if ([model.userType isEqualToString:@"2"]) {
//        //当前用户身份是访客
//        //跳转到达人身份认证页面，认证为技术达人后才能报名接单
//    }else {
//        [self showError:self.view message:@"您目前没有权限报名" afterHidden:3];
//    }
    
    
}
- (void)loadRequese {
    //获取服务详情的展示url
    
}

//加载交易记录列表数据
- (void)loadDealRecordRequest {
    
    //加载后的数组赋值给_dealVC.dataArray数组
    //刷新[_dealVC.tableView reloadData];
    
}
@end
