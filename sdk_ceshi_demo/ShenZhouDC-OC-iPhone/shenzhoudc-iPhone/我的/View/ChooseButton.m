//
//  ChooseButton.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ChooseButton.h"

@implementation ChooseButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeRight;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
//        [self setTitle:@"测试的类型" forState:UIControlStateNormal];
        self.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
        self.layer.borderWidth = 1;
        [self setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width *1/4;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(imageW*3, 0, imageW-5, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleW = contentRect.size.width *3/4;
    CGFloat titleH = contentRect.size.height;
    
    return CGRectMake(0, 0, titleW, titleH);
}
@end
