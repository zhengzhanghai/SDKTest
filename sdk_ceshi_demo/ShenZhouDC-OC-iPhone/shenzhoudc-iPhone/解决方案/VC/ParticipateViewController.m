//
//  ParticipateViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ParticipateViewController.h"
#import "NSString+CustomString.h"

@interface ParticipateViewController ()<UITextFieldDelegate>

@property(nonatomic ,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UITextField *name;
@property(nonatomic,strong) UITextField *callNum;
@property(nonatomic,strong) UITextField *workTime;
@property(nonatomic,strong) UITextField *price;
@property(nonatomic,strong) UITextField *province;
@property(nonatomic,strong) UITextField *city;
@property(nonatomic,strong) UITextField *region;
@property(nonatomic,strong) UITextField *recieved;//接单量
@property(nonatomic,strong) UITextField *completed;//完单量
@end

@implementation ParticipateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报名接单";
    [self makeUI];
    ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor whiteColor];//[[UIColor redColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(0.f);
        make.right.mas_equalTo(0.f);
        make.bottom.mas_equalTo(0.f);
    }];
    
    NSString *str2 = @"联系电话：";
    CGFloat width = [str2 getWidthWithContent:str2 height:20 font:16];
    CGFloat textFiledWidth = SCREEN_WIDTH-LandscapeNumber(60)-width;
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"姓名：";
    label1.textAlignment = NSTextAlignmentRight;
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_scrollView.mas_top).with.offset(0);
        make.width.mas_equalTo(width);
    }];
    
    _name = [[UITextField alloc]init];
    _name.textColor = [UIColor darkGrayColor];
    _name.font = [UIFont systemFontOfSize:16];
    _name.borderStyle = UITextBorderStyleRoundedRect;
    _name.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label1.mas_centerY);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label11 = [[UILabel alloc]init];
    label11.text = @"*";
    label11.textColor = MainColor;
    label11.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:label11];
    [label11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_name.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_name.mas_centerY);
    }];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = str2;
    label2.textColor = [UIColor darkGrayColor];
    label2.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_name.mas_bottom).with.offset(20);
        make.width.mas_equalTo(width);
    }];
    
    _callNum = [[UITextField alloc]init];
    _callNum.textColor = [UIColor darkGrayColor];
    _callNum.font = [UIFont systemFontOfSize:16];
    _callNum.keyboardType = UIKeyboardTypeNumberPad;
    _callNum.borderStyle = UITextBorderStyleRoundedRect;
    _callNum.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_callNum];
    [_callNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label2.mas_centerY);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label22 = [[UILabel alloc]init];
    label22.text = @"*";
    label22.textColor = MainColor;
    label22.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:label22];
    [label22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_callNum.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_callNum.mas_centerY);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"工作年限：";
    label3.textColor = [UIColor darkGrayColor];
    label3.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_callNum.mas_bottom).with.offset(20);
        make.width.mas_equalTo(width);
    }];
    
    _workTime = [[UITextField alloc]init];
    _workTime.textColor = [UIColor darkGrayColor];
    _workTime.font = [UIFont systemFontOfSize:16];
    _workTime.keyboardType = UIKeyboardTypeNumberPad;
    _workTime.borderStyle = UITextBorderStyleRoundedRect;
    _workTime.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_workTime];
    [_workTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label3.mas_centerY);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label33 = [[UILabel alloc]init];
    label33.text = @"年";
    label33.textColor = [UIColor darkGrayColor];
    label33.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label33];
    [label33 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_workTime.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_workTime.mas_centerY);
    }];
    
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"价格：";
    label4.textAlignment = NSTextAlignmentRight;
    label4.textColor = [UIColor darkGrayColor];
    label4.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_workTime.mas_bottom).with.offset(20);
        make.width.mas_equalTo(width);
    }];
    
    _price = [[UITextField alloc]init];
    _price.textColor = [UIColor darkGrayColor];
    _price.font = [UIFont systemFontOfSize:16];
    _price.keyboardType = UIKeyboardTypeNumberPad;
    _price.borderStyle = UITextBorderStyleRoundedRect;
    _price.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label4.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label4.mas_centerY);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label44 = [[UILabel alloc]init];
    label44.text = @"元";
    label44.textColor = [UIColor darkGrayColor];
    label44.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label44];
    [label44 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_price.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_price.mas_centerY);
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"地区：";
    label5.textAlignment = NSTextAlignmentRight;
    label5.textColor = [UIColor darkGrayColor];
    label5.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_price.mas_bottom).with.offset(20);
        make.width.mas_equalTo(width);
    }];
    
    _province = [[UITextField alloc]init];
    _province.textColor = [UIColor darkGrayColor];
    _province.font = [UIFont systemFontOfSize:16];
    _province.keyboardType = UIKeyboardTypeDefault;
    _province.borderStyle = UITextBorderStyleRoundedRect;
    _province.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_province];
    [_province mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label5.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label5.mas_centerY);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label55 = [[UILabel alloc]init];
    label55.text = @"省";
    label55.textColor = [UIColor darkGrayColor];
    label55.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label55];
    [label55 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_province.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_province.mas_centerY);
    }];
    
    _city = [[UITextField alloc]init];
//    _city.backgroundColor = [UIColor greenColor];
    _city.textColor = [UIColor darkGrayColor];
    _city.font = [UIFont systemFontOfSize:16];
    _city.keyboardType = UIKeyboardTypeDefault;
    _city.borderStyle = UITextBorderStyleRoundedRect;
    _city.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_city];
    [_city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_province.mas_left);
        make.top.mas_equalTo(_province.mas_bottom).with.offset(10);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label555 = [[UILabel alloc]init];
    label555.text = @"市";
    label555.textColor = [UIColor darkGrayColor];
    label555.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label555];
    [label555 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_city.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_city.mas_centerY);
    }];

    _region = [[UITextField alloc]init];
//    _region.backgroundColor = [UIColor redColor];
    _region.textColor = [UIColor darkGrayColor];
    _region.font = [UIFont systemFontOfSize:16];
    _region.keyboardType = UIKeyboardTypeDefault;
    _region.borderStyle = UITextBorderStyleRoundedRect;
    _region.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_region];
    [_region mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_city.mas_left);
        make.top.mas_equalTo(_city.mas_bottom).with.offset(10);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];

    UILabel *label5555 = [[UILabel alloc]init];
    label5555.text = @"区/县";
    label5555.textColor = [UIColor darkGrayColor];
    label5555.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label5555];
    [label5555 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_region.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_region.mas_centerY);
    }];
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"接单量：";
    label6.textAlignment = NSTextAlignmentRight;
    label6.textColor = [UIColor darkGrayColor];
    label6.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_region.mas_bottom).with.offset(20);
        make.width.mas_equalTo(width);
    }];
    
    _recieved = [[UITextField alloc]init];
    _recieved.textColor = [UIColor darkGrayColor];
    _recieved.font = [UIFont systemFontOfSize:16];
    _recieved.keyboardType = UIKeyboardTypeDefault;
    _recieved.borderStyle = UITextBorderStyleRoundedRect;
    _recieved.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_recieved];
    [_recieved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label6.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label6.mas_centerY);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label66 = [[UILabel alloc]init];
    label66.text = @"*";
    label66.textColor = MainColor;
    label66.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:label66];
    [label66 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_recieved.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_recieved.mas_centerY);
    }];
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"成单量：";
    label7.textAlignment = NSTextAlignmentRight;
    label7.textColor = [UIColor darkGrayColor];
    label7.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_recieved.mas_bottom).with.offset(20);
        make.width.mas_equalTo(width);
    }];
    
    _completed = [[UITextField alloc]init];
    _completed.textColor = [UIColor darkGrayColor];
    _completed.font = [UIFont systemFontOfSize:16];
    _completed.keyboardType = UIKeyboardTypeDefault;
    _completed.borderStyle = UITextBorderStyleRoundedRect;
    _completed.clearButtonMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_completed];
    [_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label7.mas_right).with.offset(0);
        make.centerY.mas_equalTo(label7.mas_centerY);
        make.width.mas_equalTo(textFiledWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label77 = [[UILabel alloc]init];
    label77.text = @"*";
    label77.textColor = MainColor;
    label77.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:label77];
    [label77 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_completed.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_completed.mas_centerY);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"*为必填项";
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_completed.mas_bottom).with.offset(20);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = MainColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).with.offset(10);
        make.top.mas_equalTo(label.mas_bottom).with.offset(35);
        make.width.mas_equalTo(SCREEN_WIDTH-LandscapeNumber(20));
        make.bottom.mas_equalTo(_scrollView.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(40.f);
    }];
    
}
- (void)clickBtn {
    
    
    
}
@end
