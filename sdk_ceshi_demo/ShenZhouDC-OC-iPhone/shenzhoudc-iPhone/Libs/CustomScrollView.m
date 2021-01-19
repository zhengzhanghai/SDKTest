//
//  CustomScrollView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = NO;
    }
    return self;
}

//- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
//    return NO;
//}

@end
