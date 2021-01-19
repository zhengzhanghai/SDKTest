//
//  NothingViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "NothingViewController.h"

@interface NothingViewController ()

@property(nonatomic ,strong)UIView *pushView;//弹出视图
@property (nonatomic, strong) UIButton *comb;//选择的那个套餐按钮
@property (nonatomic, assign) int purchaseCount;//购买数量
@property (nonatomic, strong) NSMutableArray *buttonArray;//所有套餐按钮所在的数组
@property (nonatomic, strong) UILabel *buyCount;//购买数量

@end

@implementation NothingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试页面";
    self.purchaseCount = 0;
    
    UIButton *butn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT/2-40, 80, 80)];
    butn.backgroundColor = [UIColor blueColor];
    [butn addTarget:self action:@selector(cliclBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butn];
    
}
-(void)cliclBtn{
        NSArray *comboArray = @[@"套餐一",@"套餐二",@"套餐三",@"套餐四",@"套餐五",@"套餐六",@"套餐七",@"套餐八",@"套餐九"];
        [self makePushViewWithIcon:[UIImage imageNamed:@"all_placeholder"] andPrice:@"999" andArray:comboArray andNumber:@"3834897"];
}

-(NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
-(void)makePushViewWithIcon:(UIImage *)image andPrice:(NSString *)price andArray:(NSArray *)comboArray andNumber:(NSString *)num {
    
    self.purchaseCount = 0;
    
    float rows = comboArray.count%4>0 ? (comboArray.count/4+1):comboArray.count/4;
    
    self.pushView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.pushView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.pushView];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.pushView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pushView.mas_left);
        make.bottom.mas_equalTo(self.pushView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, LandscapeNumber(235)+rows*LandscapeNumber(47)));
    }];
    
    UIImageView *productImg = [[UIImageView alloc]init];
    productImg.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    productImg.layer.borderWidth = 1;
    productImg.image = image;
    [backView addSubview:productImg];
    [productImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_top).with.offset(-LandscapeNumber(18));
        make.left.mas_equalTo(backView.mas_left).with.offset(9);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(100), LandscapeNumber(100)));
    }];
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = UIColorFromRGB(0xD61F1F);
    priceLabel.font = [UIFont systemFontOfSize:20];
    priceLabel.text = [NSString stringWithFormat:@"¥%@",price];
    [backView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_top).with.offset(LandscapeNumber(35));
        make.left.mas_equalTo(productImg.mas_right).with.offset(LandscapeNumber(18));
    }];
    
    UILabel *unitLabel = [[UILabel alloc]init];
    unitLabel.textColor = UIColorFromRGB(0x848689);
    unitLabel.font = [UIFont systemFontOfSize:20];
    unitLabel.text = @"/套";
    [backView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_top);
        make.left.mas_equalTo(priceLabel.mas_right);
    }];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = UIColorFromRGB(0x848689);
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.text = @"商品编号：";
    [backView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).with.offset(2);
        make.left.mas_equalTo(priceLabel.mas_left);
    }];
    
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.textColor = UIColorFromRGB(0x848689);
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.text = num;
    [backView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailLabel.mas_top);
        make.left.mas_equalTo(detailLabel.mas_right);
    }];
    
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeTheView) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).with.offset(-10);
        make.top.mas_equalTo(backView.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(30), LandscapeNumber(30)));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [backView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(productImg.mas_bottom).with.offset(LandscapeNumber(17));
        make.right.mas_equalTo(backView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *buyLabel = [[UILabel alloc]init];
    buyLabel.textColor = UIColorFromRGB(0x6C6C6C);
    buyLabel.font = [UIFont systemFontOfSize:13];
    buyLabel.text = @"购买方式";
    [backView addSubview:buyLabel];
    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).with.offset(7);
        make.left.mas_equalTo(productImg.mas_left);
    }];
    
    
    UIView *middowView = [[UIView alloc]init];
    middowView.userInteractionEnabled = YES;
    middowView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:middowView];
    [middowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(buyLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, LandscapeNumber(47)*rows));
    }];
    
    float b_x = 10;
    float b_y = 10;
    
    float width = 70;
    float height = 27;
    
    for (int i = 0; i < comboArray.count; i++) {
        if (i % 4 == 0 && i != 0) {
            b_x = 10;
            b_y += height+10;
        }
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
        [button setTitle:comboArray[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x484848) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xD61F1F) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = i;
        [button addTarget:self action:@selector(clickTheComboBtn:) forControlEvents:UIControlEventTouchUpInside];
        [middowView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(middowView.mas_left).with.offset(b_x);
            make.top.mas_equalTo(middowView.mas_top).with.offset(b_y);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        if (button.tag == 0) {
            button.selected = YES;
            button.layer.borderWidth = 1;
            self.comb = button;
            button.layer.borderColor = UIColorFromRGB(0xD71629).CGColor;
        }
        
        b_x = b_x + width + 15;
        [self.buttonArray addObject:button];
    }
    
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = UIColorFromRGB(0xECECEC);
    [backView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middowView.mas_bottom);
        make.left.mas_equalTo(line1.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.textColor = UIColorFromRGB(0x6C6C6C);
    countLabel.font = [UIFont systemFontOfSize:13];
    countLabel.text = @"购买数量";
    [backView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).with.offset(LandscapeNumber(15));
        make.left.mas_equalTo(buyLabel.mas_left);
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0x0F0F0F) forState:UIControlStateNormal];
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    [addBtn addTarget:self action:@selector(addNum) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).with.offset(-10);
        make.centerY.mas_equalTo(countLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(31), LandscapeNumber(27)));
    }];
    
    self.buyCount = [[UILabel alloc]init];
    self.buyCount.text = [NSString stringWithFormat:@"%d",self.purchaseCount];
    self.buyCount.layer.borderWidth = 1;
    self.buyCount.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    self.buyCount.textColor = UIColorFromRGB(0x0F0F0F);
    self.buyCount.font = [UIFont systemFontOfSize:16];
    self.buyCount.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.buyCount];
    [self.buyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(countLabel.mas_centerY);
        make.right.mas_equalTo(addBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(40), LandscapeNumber(27)));
    }];
    
    UIButton *subBtn = [[UIButton alloc]init];
    [subBtn setTitle:@"-" forState:UIControlStateNormal];
    [subBtn setTitleColor:UIColorFromRGB(0x0F0F0F) forState:UIControlStateNormal];
    subBtn.layer.borderWidth = 1;
    subBtn.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    [subBtn addTarget:self action:@selector(subNum) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.buyCount.mas_left);
        make.centerY.mas_equalTo(countLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(31), LandscapeNumber(27)));
    }];
    
    UIButton *buyBtn = [[UIButton alloc]init];
    buyBtn.backgroundColor = UIColorFromRGB(0xD71629);
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [buyBtn addTarget:self action:@selector(goBuyNow) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview: buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(addBtn.mas_bottom).with.offset(LandscapeNumber(11));
        make.bottom.mas_equalTo(backView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
}
//关闭弹窗
-(void)closeTheView {
    [self.pushView removeFromSuperview];
}
//选择套餐
-(void)clickTheComboBtn:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.selected = NO;
        sender.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    }else{
        sender.selected = YES;
        self.comb = sender;
        [self reloadUI];
    }
    
}
-(void)reloadUI {
    for (UIButton *btn in self.buttonArray) {
        btn.selected = NO;
        btn.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    }
    self.comb.selected = YES;
    self.comb.layer.borderColor = UIColorFromRGB(0xD61F1F).CGColor;
}
//增加按钮
-(void)addNum {
    
    self.purchaseCount++;
    self.buyCount.text = [NSString stringWithFormat:@"%d",self.purchaseCount];
    
}
//减号按钮
-(void)subNum {
    if (self.purchaseCount <= 0) {
        return;
    }
    self.purchaseCount --;
    self.buyCount.text = [NSString stringWithFormat:@"%d",self.purchaseCount];
    
}
//立即购买
-(void)goBuyNow {
    
    
}



@end
