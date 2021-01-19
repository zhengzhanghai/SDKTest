//
//  DetailsMiddleView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "DetailsMiddleView.h"
#define BASE_TAG 6578

@interface DetailsMiddleView()

@property (nonatomic, strong) UILabel         *pingJia;

@end

@implementation DetailsMiddleView

+ (instancetype)createToSuperView:(UIView *)superView {
    DetailsMiddleView *view = [[DetailsMiddleView alloc] init];
    [superView addSubview:view];
    [view initUI];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)setPingjiaCount:(NSString *)pingJiaCount {
    self.pingJia.text = [NSString stringWithFormat:@"%@条评价", pingJiaCount];
}

- (void)initUI {
//    NSArray *titles = @[@"查看详细说明",
//                        @"全部评价",
//                        @"相关产品"];
    NSArray *titles = @[@"交钥匙项目"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.tag = BASE_TAG + i;
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(i*45);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(45);
            if (i == titles.count-1) {
                make.bottom.equalTo(self.mas_bottom).offset(0);
            }
        }];
        
        UILabel *title = [[UILabel alloc] init];
        [button addSubview:title];
        title.text = titles[i];
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont systemFontOfSize:15];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([titles[i] isEqualToString:@"交钥匙项目"]) {
                make.centerX.mas_equalTo(0);
            } else {
                make.left.mas_equalTo(8);
            }
            make.centerY.mas_equalTo(0);
        }];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right"]];
//        [button addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-15);
//            make.centerY.mas_equalTo(0);
//            make.width.mas_equalTo(8);
//            make.height.mas_equalTo(13);
//        }];
        
        if ([titles[i] isEqualToString:@"全部评价"]) {
            self.pingJia = [[UILabel alloc] init];
            [button addSubview:self.pingJia];
            self.pingJia.text = @"0条评价";
            self.pingJia.textColor = UIColorFromRGB(0xB0B0B0);
            self.pingJia.font = [UIFont systemFontOfSize:12];
            [self.pingJia mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(imageView.mas_left).offset(-9);
                make.centerY.mas_equalTo(0);
            }];
        }
        
        if ([titles[i] isEqualToString:@"交钥匙项目"]) {
            button.backgroundColor = UIColorFromRGB(0xF8F8F8);
            
//            UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button addSubview:allBtn];
//            [allBtn setTitle:@"全部" forState:UIControlStateNormal];
//            [allBtn setTitleColor:UIColorFromRGB(0xB0B0B0) forState:UIControlStateNormal];
//            allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//            [allBtn addTarget:self action:@selector(allCaseClick:) forControlEvents:UIControlEventTouchUpInside];
//            [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(imageView.mas_left).offset(-9);
//                make.centerY.mas_equalTo(0);
//            }];

        }
        
        if (i != titles.count-1) {
            UIView *sepLine = [[UIView alloc] init];
            [button addSubview:sepLine];
            sepLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
            [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(2);
            }];
        }
    }
}

- (void)btnAction:(UIButton *)button {
    NSLog(@"%ld", button.tag - BASE_TAG);
    if (self.detailClickBlock) {
        self.detailClickBlock(button.tag-BASE_TAG);
    }
}

- (void)allCaseClick:(UIButton *)btn {
    if (self.allCaseBlock) {
        self.allCaseBlock();
    }
}

@end
