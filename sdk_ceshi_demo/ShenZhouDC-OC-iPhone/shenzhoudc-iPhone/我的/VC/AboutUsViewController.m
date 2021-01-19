//
//  AboutUsViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/30.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "AboutUsViewController.h"
#import "CommentViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeUI {
    
    UIImageView *logo = [[UIImageView alloc]init];
    logo.image = [UIImage imageNamed:@"logoyun"];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(SCREEN_WIDTH/6+LandscapeNumber(64));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*16/75, SCREEN_WIDTH*16/75));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"神州方案云";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = UIColorFromRGB(0xD71629);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(logo.mas_bottom).offset(LandscapeNumber(15));
    }];
    
    UILabel *verson = [[UILabel alloc]init];
    verson.text = @"v 1.0";
    verson.font = [UIFont systemFontOfSize:16];
    verson.textColor = UIColorFromRGB(0xD71629);
    [self.view addSubview:verson];
    [verson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(LandscapeNumber(15));
    }];
    
    
    
//    UIButton *btn = [[UIButton alloc]init];
//    btn.backgroundColor = [UIColor yellowColor];
//    [btn addTarget:self action:@selector(cliclbtyn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.top.equalTo(verson.mas_bottom).offset(LandscapeNumber(20));
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"Copyright ©2017 神州方案云 版权所有";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColorFromRGB(0x999999);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-LandscapeNumber(16));
        make.width.mas_equalTo(LandscapeNumber(249));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.equalTo(label.mas_top).offset(-LandscapeNumber(16));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 1));
    }];
    
    
    
}
- (void)cliclbtyn {
    CommentViewController *vc = [[CommentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
