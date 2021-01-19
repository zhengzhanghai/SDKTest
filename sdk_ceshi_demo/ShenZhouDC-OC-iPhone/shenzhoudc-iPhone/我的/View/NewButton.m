//
//  NewButton.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "NewButton.h"

@implementation NewButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.6;
    
    return CGRectMake(0, 5, imageW, imageH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleY = contentRect.size.height*0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}
@end
