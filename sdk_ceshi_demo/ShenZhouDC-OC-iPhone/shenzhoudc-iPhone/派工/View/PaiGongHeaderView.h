//
//  PaiGongHeaderView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/5/31.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaiGongHeaderView : UIView

@property (assign, nonatomic) NSInteger currentIndex;

@property (copy, nonatomic)   void(^clickTitleBlock)(NSInteger);

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
