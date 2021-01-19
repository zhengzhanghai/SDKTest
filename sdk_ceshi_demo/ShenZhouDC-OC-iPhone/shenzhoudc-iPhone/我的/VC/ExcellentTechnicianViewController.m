//
//  ExcellentTechnicianViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ExcellentTechnicianViewController.h"

@interface ExcellentTechnicianViewController ()

@end

@implementation ExcellentTechnicianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优秀技术达人";
    self.view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeUI {
    //标签数组
    NSArray *array = @[@"标签1",@"标签1",@"标签1"];
    float rows = array.count%3>0 ? (array.count/3+1):array.count/3;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT,SCREEN_WIDTH, LandscapeNumber(151)+LandscapeNumber(24)*rows)];
    headView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:headView];
    
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = LandscapeNumber(60)/2;
    headImg.userInteractionEnabled = YES;
    headImg.image = [UIImage imageNamed:@"user_icon"];
    [headView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(headView.mas_top).with.offset(LandscapeNumber(12));
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(60), LandscapeNumber(60)));
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = UIColorFromRGB(0x484848);
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"怪盗一枝梅";
    [headView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(headImg.mas_bottom).with.offset(10);
    }];
    
    UIImageView *identifierIcon = [[UIImageView alloc]init];
    identifierIcon.image = [UIImage imageNamed:@"idenrifier_icon"];
    [headView addSubview:identifierIcon];
    [identifierIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.left.mas_equalTo(nameLabel.mas_right).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(11, 12));
    }];
    

    UIView *middowView = [[UIView alloc]init];//WithFrame:CGRectMake(SCREEN_WIDTH/4, CGRectGetMaxY(nameLabel.frame)+ 10, SCREEN_WIDTH/3, LandscapeNumber(47)*rows)
    middowView.userInteractionEnabled = YES;
    middowView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:middowView];
    [middowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(nameLabel.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, LandscapeNumber(24)*rows));
    }];
    
    
    float b_x = 10;
    float b_y = 10;
    
    float width = LandscapeNumber(42);
    float height = LandscapeNumber(14);
    
    for (int i = 0; i < array.count; i++) {
        if (i % 3 == 0 && i != 0) {
            b_x = 10;
            b_y += height+10;
        }
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0x4990E2).CGColor;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x4990E2) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        button.tag = i;
        [middowView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(middowView.mas_left).with.offset(b_x);
            make.top.mas_equalTo(middowView.mas_top).with.offset(b_y);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        b_x = b_x + width + 10;
    }
    

    UILabel *label = [[UILabel alloc]init];
    label.textColor = UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"北京 | 成交10笔 ";
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(middowView.mas_bottom).with.offset(10);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(headView.mas_bottom).with.offset(8);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    UILabel *registerLabel = [[UILabel alloc]init];
    registerLabel.textColor = UIColorFromRGB(0x3D4245);
    registerLabel.font = [UIFont systemFontOfSize:16];
    registerLabel.text = @"注册时间";
    [bottomView addSubview:registerLabel];
    [registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView.mas_left).with.offset(16);
        make.top.mas_equalTo(bottomView.mas_top).with.offset(12);
    }];
    
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = UIColorFromRGB(0xB5B5B5);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = @"2016-12-29";
    [bottomView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(registerLabel.mas_centerY);
        make.right.mas_equalTo(bottomView.mas_right).with.offset(-16);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [bottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(registerLabel.mas_bottom).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    
}

@end
