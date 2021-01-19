//
//  ComplainViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ComplainViewController.h"

@interface ComplainViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;

@end

@implementation ComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投诉";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
}
- (void)makeUI {
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"请填写投诉原因，投诉请求将提交到我们后台处理，我们会在7个工作日内给您答复，感谢您的理解与支持，谢谢！";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT+15);
        make.right.mas_equalTo(-10.f);
    }];
    
    _textView = [[UITextView alloc]init];
    _textView.delegate = self;
    _textView.layer.borderColor = UIColorFromRGB(0xEAEAEA).CGColor;
    _textView.layer.borderWidth = 1;
    _textView.textColor = [UIColor darkGrayColor];
    _textView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, LandscapeNumber(80)));
    }];
    
    
    _placeHolderLabel = [[UILabel alloc]init];
    _placeHolderLabel.text = @"请输入评价内容...";
    _placeHolderLabel.textColor = UIColorFromRGB(0xEAEAEA);
    _placeHolderLabel.font = [UIFont systemFontOfSize:13];
    [_textView addSubview:_placeHolderLabel];
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_textView.mas_left).with.offset(8);
        make.top.mas_equalTo(_textView.mas_top).with.offset(8);
    }];
    
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.backgroundColor = MainColor;
    makeSureBtn.layer.masksToBounds = YES;
    makeSureBtn.layer.cornerRadius = 4;
    [makeSureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [makeSureBtn addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeSureBtn];
    [makeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(_textView.mas_bottom).with.offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(40.f);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickCommitBtn {
    
    
    
}

#pragma mark  UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    _placeHolderLabel.hidden = YES;
    if ([textView.text isEqualToString:@""]) {
        _placeHolderLabel.hidden = NO;
    }
    
    
}

@end
