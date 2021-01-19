//
//  ParticipatorDetailInfoViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
// 加"个人交易记录"模块之后的################################################################

#import "ParticipatorDetailInfoViewController.h"
#import "ChoosePaymentViewController.h"
#import "DealRecordCell.h"
#import "NSString+CustomString.h"
#import <WebKit/WebKit.h>

@interface ParticipatorDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *btn;//是否验收人为本人按钮
}
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITextField *name;
@property(nonatomic,strong)UITextField *cellNum;
@property(nonatomic,assign)NSInteger isSelf;//0非本人 1本人

@end

@implementation ParticipatorDetailInfoViewController
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
    self.title = @"报名人详情";
    [self loadData];
    self.isSelf = 0;

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
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
    _webView.backgroundColor = [UIColor greenColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [headView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left);
        make.top.mas_equalTo(headView.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"报名人历史交易记录";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_webView.mas_bottom);
        make.left.mas_equalTo(headView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    _tableView.tableHeaderView = headView;
    
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LandscapeNumber(280))];
    footView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"确定验收人";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [footView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footView.mas_centerX);
        make.top.mas_equalTo(footView.mas_top).with.offset(15);
        make.height.mas_equalTo(20);
    }];
    
    
    btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"not_select"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickSelf:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UILabel *annotateLabel = [[UILabel alloc]init];
    annotateLabel.text = @"验收人是否是本人？";
    annotateLabel.textAlignment = NSTextAlignmentCenter;
    annotateLabel.textColor = [UIColor darkGrayColor];
    annotateLabel.font = [UIFont boldSystemFontOfSize:15];
    [footView addSubview:annotateLabel];
    [annotateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btn.mas_centerY);
        make.left.mas_equalTo(btn.mas_right).with.offset(10);
    }];
    
    UILabel *starLabel = [[UILabel alloc]init];
    starLabel.text = @"*";
    starLabel.textAlignment = NSTextAlignmentLeft;
    starLabel.textColor = MainColor;
    starLabel.font = [UIFont boldSystemFontOfSize:15];
    [footView addSubview:starLabel];
    [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_left);
        make.top.mas_equalTo(btn.mas_bottom).with.offset(10);
    }];
    
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.text = @"如验收人非本人，则必须填写验收人信息";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = [UIColor darkGrayColor];
    infoLabel.font = [UIFont systemFontOfSize:15];
    [footView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(starLabel.mas_right).with.offset(2);
        make.centerY.mas_equalTo(starLabel.mas_centerY);
    }];
    
    
    NSString *str = @"验证人姓名：";
    CGFloat width = [str getWidthWithContent:str height:18 font:15];
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = str;
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont systemFontOfSize:15];
    [footView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoLabel.mas_bottom).with.offset(25);
        make.left.mas_equalTo(10.f);
    }];
    
    _name = [[UITextField alloc]init];
    _name.textColor = [UIColor darkGrayColor];
    _name.font = [UIFont systemFontOfSize:16];
    _name.borderStyle = UITextBorderStyleRoundedRect;
    _name.clearButtonMode = UITextFieldViewModeAlways;
    [footView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label1.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-width-LandscapeNumber(40));
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"验收人电话：";
    label2.textColor = [UIColor darkGrayColor];
    label2.font = [UIFont systemFontOfSize:15];
    [footView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_name.mas_bottom).with.offset(20);
        make.left.mas_equalTo(10.f);
    }];
    
    _cellNum = [[UITextField alloc]init];
    _cellNum.textColor = [UIColor darkGrayColor];
    _cellNum.font = [UIFont systemFontOfSize:16];
    _cellNum.borderStyle = UITextBorderStyleRoundedRect;
    _cellNum.clearButtonMode = UITextFieldViewModeAlways;
    [footView addSubview:_cellNum];
    [_cellNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label2.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-width-LandscapeNumber(40));
        make.height.mas_equalTo(40);
    }];
    
    
    
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
        make.top.mas_equalTo(_cellNum.mas_bottom).with.offset(15);
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
- (void)clickSelf:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        self.isSelf = 0;
    }else {
        sender.selected = YES;
        self.isSelf = 1;
    }
}

- (void)loadData {
    //从服务器获取加载报名者信息的H5页面URL
    
    
}
- (void)clickParticipateBtn {
    
    //进入付款页面
    [self showSuccess:self.view message:@"进入支付页面，进行支付" afterHidden:3];
    ChoosePaymentViewController *vc = [[ChoosePaymentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


//加载交易记录列表数据
- (void)loadDealRecordRequest {
    
    //加载后的数组赋值给_dealVC.dataArray数组
    //刷新[_dealVC.tableView reloadData];
    
}

@end
