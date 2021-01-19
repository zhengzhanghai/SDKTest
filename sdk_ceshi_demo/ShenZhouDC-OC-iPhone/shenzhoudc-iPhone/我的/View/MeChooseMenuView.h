//
//  MeChooseMenuView.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeChooseMenuView : UIView

@property (nonatomic, copy) void (^clickItemBlock)(NSUInteger);

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;


@end
