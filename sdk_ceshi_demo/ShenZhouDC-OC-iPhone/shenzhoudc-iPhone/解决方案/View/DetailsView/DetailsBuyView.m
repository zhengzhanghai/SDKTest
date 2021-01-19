//
//  DetailsBuyView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DetailsBuyView.h"
/** 套餐两边的间距 */
#define PackageEdgeMargin 10
/** 套餐之间的间距 */
#define PackageMiddleMargin 10
/** 每行套餐数量 */
#define PackageCountRow 4

#define BaseTag 7485

@interface DetailsBuyView()

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *bianHao;
@property (strong, nonatomic) UIView *packageView;
@property (strong, nonatomic) UILabel *buyCountLabel;

/** 购买数量 */
@property (assign, nonatomic) NSInteger buyCount;
/** 选中的套餐视图 */
@property (strong, nonatomic) UIButton *selectBtn;

@end

@implementation DetailsBuyView

+ (instancetype)createToSuperView:(UIView *)superView {
    DetailsBuyView *buyView = [[DetailsBuyView alloc] init];
    [superView addSubview:buyView];
    [buyView initData];
    [buyView initUI];
    return buyView;
}

- (void)initData {
    _buyCount = 1;
}

- (void)addPackage:(NSArray<NSString *> *)packages {
    CGFloat width = (SCREEN_WIDTH-2*PackageEdgeMargin-(PackageCountRow-1)*PackageMiddleMargin)/PackageCountRow;
    CGFloat height = width*27/70;
    for (int i = 0; i < packages.count; i++) {
        CGFloat btnX = PackageEdgeMargin + (i%PackageCountRow)*(width+PackageMiddleMargin);
        CGFloat btnY = 37 + (i/PackageCountRow)*(height+PackageMiddleMargin);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_packageView addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xD61F1F) forState:UIControlStateSelected];
        [btn setTitle:packages[i] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
        btn.tag = BaseTag + i;
        [btn addTarget:self action:@selector(clickPackageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnX);
            make.top.mas_equalTo(btnY);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            if (i == packages.count-1) {
                make.bottom.mas_equalTo(-13);
            }
        }];
        if (i == 0) {
            [self setSelectedBtn:btn];
            self.selectBtn = btn;
        }
    }
}

- (void)setSelectedBtn:(UIButton *)btn {
    btn.selected = YES;
    btn.layer.borderColor = UIColorFromRGB(0xD61F1F).CGColor;
}

- (void)setNormalBtn:(UIButton *)btn {
    btn.selected = NO;
    btn.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
}

- (void)clickPackageBtn:(UIButton *)btn {
    if (btn == self.selectBtn) {
        return;
    }
    [self setSelectedBtn:btn];
    [self setNormalBtn:self.selectBtn];
    self.selectBtn = btn;
}

- (void)refresh:(NSString *)icon price:(NSString *)price bianHao:(NSString *)bianHao {
    [_icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"image_background"] options:SDWebImageProgressiveDownload];
    _price.text = [NSString stringWithFormat:@"¥%@", price];
    _bianHao.text = [NSString stringWithFormat:@"商品编号:%@", bianHao];
}

//增加按钮
-(void)addNum {
    _buyCount++;
    _buyCountLabel.text = [NSString stringWithFormat:@"%zd", _buyCount];
}
//减号按钮
-(void)subNum {
    _buyCount--;
    if (_buyCount < 1) {
        _buyCount = 1;
    }
    _buyCountLabel.text = [NSString stringWithFormat:@"%zd", _buyCount];
}
//立即购买
-(void)goBuyNow {
    if (self.buyBlock) {
        self.buyBlock(self.selectBtn.tag-BaseTag, self.buyCount);
    }
}

// 从父视图上移除
- (void)cancelBuy {
    [self removeFromSuperview];
}

- (void)initUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    _icon = [[UIImageView alloc]init];
    [bgView addSubview:_icon];
    _icon.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    _icon.layer.borderWidth = 1;
    _icon.image = [UIImage imageNamed:@"image_background"];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-20);
        make.left.mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelBuy) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    _price = [[UILabel alloc]init];
    [bgView addSubview:_price];
    _price.textColor = UIColorFromRGB(0xD61F1F);
    _price.font = [UIFont systemFontOfSize:20];
    _price.text = [NSString stringWithFormat:@"¥"];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(_icon.mas_right).with.offset(18);
    }];
    
    UILabel *unitLabel = [[UILabel alloc]init];
    unitLabel.textColor = UIColorFromRGB(0x848689);
    unitLabel.font = [UIFont systemFontOfSize:20];
    unitLabel.text = @"/套";
    [bgView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_top);
        make.left.mas_equalTo(_price.mas_right);
    }];
    
    _bianHao = [[UILabel alloc]init];
    _bianHao.textColor = UIColorFromRGB(0x848689);
    _bianHao.font = [UIFont systemFontOfSize:12];
    _bianHao.text = @"商品编号：";
    [bgView addSubview:_bianHao];
    [_bianHao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).with.offset(2);
        make.left.mas_equalTo(_price.mas_left);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [bgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_icon.mas_bottom).offset(17);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    _packageView = [[UIView alloc] init];
    [bgView addSubview:_packageView];
    [_packageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(line1.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    UILabel *buyLabel = [[UILabel alloc]init];
    buyLabel.textColor = UIColorFromRGB(0x6C6C6C);
    buyLabel.font = [UIFont systemFontOfSize:13];
    buyLabel.text = @"购买方式";
    [_packageView addSubview:buyLabel];
    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(10);
    }];

    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = UIColorFromRGB(0xECECEC);
    [bgView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_packageView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.textColor = UIColorFromRGB(0x6C6C6C);
    countLabel.font = [UIFont systemFontOfSize:13];
    countLabel.text = @"购买数量";
    [bgView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).with.offset(15);
        make.left.mas_equalTo(9);
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0x0F0F0F) forState:UIControlStateNormal];
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    [addBtn addTarget:self action:@selector(addNum) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(countLabel.mas_centerY);
        make.width.mas_equalTo(31);
        make.height.mas_equalTo(27);
    }];
    
    _buyCountLabel = [[UILabel alloc]init];
    _buyCountLabel.text = @"1";
    _buyCountLabel.layer.borderWidth = 1;
    _buyCountLabel.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    _buyCountLabel.textColor = UIColorFromRGB(0x0F0F0F);
    _buyCountLabel.font = [UIFont systemFontOfSize:16];
    _buyCountLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_buyCountLabel];
    [_buyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(countLabel.mas_centerY);
        make.right.mas_equalTo(addBtn.mas_left).offset(1);
        make.size.mas_equalTo(CGSizeMake(40, 27));
    }];
    
    UIButton *subBtn = [[UIButton alloc]init];
    [subBtn setTitle:@"-" forState:UIControlStateNormal];
    [subBtn setTitleColor:UIColorFromRGB(0x0F0F0F) forState:UIControlStateNormal];
    subBtn.layer.borderWidth = 1;
    subBtn.layer.borderColor = UIColorFromRGB(0xC1C2C4).CGColor;
    [subBtn addTarget:self action:@selector(subNum) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_buyCountLabel.mas_left).offset(1);
        make.centerY.mas_equalTo(countLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(31, 27));
    }];
    
    UIButton *buyBtn = [[UIButton alloc]init];
    buyBtn.backgroundColor = UIColorFromRGB(0xD71629);
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [buyBtn addTarget:self action:@selector(goBuyNow) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview: buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(countLabel.mas_bottom).offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(bgView.mas_bottom);
        make.height.mas_equalTo(51);
    }];

    
}



@end
