//
//  AuthenticationViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "TechnicallyLiterateInfoViewController.h"
#import "ManufacturerInfoViewController.h"
#import "NSString+CustomString.h"
#import "TechnicianDetailsViewController.h"
#import "UserAuthViewController.h"

@interface AuthenticationViewController ()
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    
    UIImageView *img1;
    UIImageView *img2;
    UIImageView *img3;
    UIImageView *img4;
    UIImageView *img5;
    
}
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) NSInteger chosedID; //选择的认证用户类型

@end

@implementation AuthenticationViewController

-(NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"认证";
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
    [self makeUI];
    self.chosedID = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    
    UIButton *nextBtn = [[UIButton alloc]init];
    nextBtn.backgroundColor = MainColor;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.clipsToBounds = true;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 40);
    }];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(nextBtn.mas_top).offset(-10);
    }];
    
    
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, 76)];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn1];
    btn1.backgroundColor = [UIColor whiteColor];
    
    
    img1 = [[UIImageView alloc]initWithFrame:CGRectMake(16, NAVBARHEIGHT+STATUSBARHEIGHT+16, 16, 16)];
    img1.tag = 1;
    img1.image = [UIImage imageNamed:@"auth_selected"];
    [scrollView addSubview:img1];
    [self.btnArray addObject:img1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img1.frame)+12, 18, 120, 20)];
    label1.text = @"公司用户";
    label1.centerY = img1.centerY;
    label1.textColor = UIColorFromRGB(0x1e1e1e);
    label1.font = [UIFont systemFontOfSize:16];
    [scrollView addSubview:label1];
    
    
    NSString *str1 = @"可发布方案、购买方案、方案定价、发布/购买派工";
    CGFloat w1 = [str1 getHeightWithContent:str1 width:SCREEN_WIDTH-68 font:13];
    UILabel *despLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img1.frame)+12, CGRectGetMaxY(label1.frame)+12, SCREEN_WIDTH-68, w1)];
    despLabel1.text = str1;
    despLabel1.numberOfLines = 0;
    despLabel1.textColor = UIColorFromRGB(0x888888);
    despLabel1.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:despLabel1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(despLabel1.frame)+16, SCREEN_WIDTH, 1)];
    line1.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [scrollView addSubview:line1];
    
    btn4 = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), SCREEN_WIDTH, 76)];
    btn4.tag = 4;
    [btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn4];
    btn4.backgroundColor = [UIColor whiteColor];
    
    
    img4 = [[UIImageView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(line1.frame)+16, 16, 16)];
    img4.tag = 4;
    img4.image = [UIImage imageNamed:@"auth_normal"];
    [scrollView addSubview:img4];
    [self.btnArray addObject:img4];
    
  
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img4.frame)+12, CGRectGetMaxY(line1.frame)+18, 80, 20)];
    label4.text = @"普通用户";//技术达人
    label4.centerY = img4.centerY;
    label4.textColor = UIColorFromRGB(0x1e1e1e);
    label4.font = [UIFont systemFontOfSize:16];
    [scrollView addSubview:label4];
    
    NSString *str4 = @"可购买方案、发布派工、发布方案需求";
    CGFloat w4 = [str4 getHeightWithContent:str4 width:SCREEN_WIDTH-68 font:13];
    UILabel *despLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img4.frame)+12, CGRectGetMaxY(label4.frame)+12, SCREEN_WIDTH-68, w4)];
    despLabel4.text = str4;
    despLabel4.numberOfLines = 0;
    despLabel4.textColor = UIColorFromRGB(0x888888);
    despLabel4.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:despLabel4];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(despLabel4.frame)+16, SCREEN_WIDTH, 1)];
    line4.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [scrollView addSubview:line4];
    
    
    btn5 = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line4.frame), SCREEN_WIDTH, 76)];
    btn5.tag = 5;
    [btn5 addTarget:self action:@selector(clickBtnFive) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn5];
    btn5.backgroundColor = [UIColor whiteColor];
    
    
    img5 = [[UIImageView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(line4.frame)+16, 16, 16)];
    img5.tag = 5;
    img5.image = [UIImage imageNamed:@"auth_normal"];
    [scrollView addSubview:img5];
    [self.btnArray addObject:img5];
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img5.frame)+12, CGRectGetMaxY(line4.frame)+18, 80, 20)];
    label5.text = @"技术达人";
    label5.centerY = img5.centerY;
    label5.textColor = UIColorFromRGB(0x1e1e1e);
    label5.font = [UIFont systemFontOfSize:16];
    [scrollView addSubview:label5];
    
    
    NSString *str5 = @"可购买方案、发布/应标派工";
    CGFloat w5 = [str4 getHeightWithContent:str4 width:SCREEN_WIDTH-68 font:13];
    UILabel *despLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img5.frame)+12, CGRectGetMaxY(label5.frame)+12, SCREEN_WIDTH-68, w5)];
    despLabel5.text = str5;
    despLabel5.numberOfLines = 0;
    despLabel5.textColor = UIColorFromRGB(0x888888);
    despLabel5.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:despLabel5];
//    
//    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(despLabel5.frame)+16, SCREEN_WIDTH, 1)];
//    line5.backgroundColor = UIColorFromRGB(0xECECEC);
//    [scrollView addSubview:line5];
    

    
}
- (void)clickBtn1 {
    img1.image = [UIImage imageNamed:@"auth_selected"];
    self.chosedID = img1.tag;
    for (UIImageView* btn in self.btnArray) {
        if (btn.tag != img1.tag) {
            btn.image = [UIImage imageNamed:@"auth_normal"];
        }
    }
}
- (void)clickBtn2 {
    img2.image = [UIImage imageNamed:@"auth_selected"];
    self.chosedID = img2.tag;
    for (UIImageView* btn in self.btnArray) {
        if (btn.tag != img2.tag) {
            btn.image = [UIImage imageNamed:@"auth_normal"];
        }
    }

    
}
- (void)clickBtn3 {
    img3.image = [UIImage imageNamed:@"auth_selected"];
    self.chosedID = img3.tag;
    for (UIImageView* btn in self.btnArray) {
        if (btn.tag != img3.tag) {
            btn.image = [UIImage imageNamed:@"auth_normal"];
        }
    }
    
}
- (void)clickBtn4 {
    img4.image = [UIImage imageNamed:@"auth_selected"];
    self.chosedID = img4.tag;
    for (UIImageView* btn in self.btnArray) {
        if (btn.tag != img4.tag) {
            btn.image = [UIImage imageNamed:@"auth_normal"];
        }
    }
    
}
- (void)clickBtnFive {
    img5.image = [UIImage imageNamed:@"auth_selected"];
    self.chosedID = img5.tag;
    for (UIImageView* btn in self.btnArray) {
        if (btn.tag != img5.tag) {
            btn.image = [UIImage imageNamed:@"auth_normal"];
        }
    }
}

- (void)clickNextBtn {
    
    NSLog(@"🌸🌸🌸--->>> %ld",self.chosedID);
    if (self.chosedID == 0 ) {
        [self showError:self.view message:@"请选择认证身份" afterHidden:3];
        return;
    }
    if (self.chosedID == 5) {
        
//    TechnicallyLiterateInfoViewController *vc = [[TechnicallyLiterateInfoViewController alloc]init];
        TechnicianDetailsViewController *vc = [[TechnicianDetailsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.chosedID == 1 || self.chosedID == 2 || self.chosedID == 3 ) {
        
        ManufacturerInfoViewController *vc = [[ManufacturerInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ( self.chosedID == 4) {
        UserAuthViewController *vc = [[UserAuthViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}




@end
