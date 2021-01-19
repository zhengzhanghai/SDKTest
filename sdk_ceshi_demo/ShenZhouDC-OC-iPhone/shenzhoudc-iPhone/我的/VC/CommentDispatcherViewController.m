//
//  CommentDispatcherViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "CommentDispatcherViewController.h"
#import "CommentStarView.h"
#import <WebKit/WebKit.h>

@interface CommentDispatcherViewController ()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *commentTextView;
@property (nonatomic, strong) CommentStarView *commentView;

@property (nonatomic, assign) int starCount; //评论的星数

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,assign) CGFloat webViewHeight;
@property(nonatomic,strong)UIView *commentDetailView;


@end

@implementation CommentDispatcherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价派单人";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self loadData];
    

    
    self.starCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(0.f);
        make.right.mas_equalTo(0.f);
        make.bottom.mas_equalTo(0.f);
    }];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [_scrollView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.mas_equalTo(0.f);
        make.right.mas_equalTo(-0.f);
        make.height.mas_equalTo(_webViewHeight);
    }];
    
    _commentView = [[UIView alloc]init];
    [_scrollView addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.mas_equalTo(_webView.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-0.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    
    
    
    
    
    
    
}
- (void)loadData {
    
}

@end
