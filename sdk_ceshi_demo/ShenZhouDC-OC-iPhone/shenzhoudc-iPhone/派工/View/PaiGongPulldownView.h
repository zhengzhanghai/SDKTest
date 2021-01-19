//
//  PaiGongPulldownView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/5.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaiGongPulldownView : UIView

@property (copy, nonatomic)   void(^clickItemBlick)(NSInteger);


- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles;

- (void)setTitle:(NSString *)title index:(NSInteger)index;

- (CGPoint)itemCenterWithIndex:(NSInteger)index;

- (void)setItemSelected:(BOOL)selected atIndex:(NSInteger)index;

@end


#pragma mark ---------------   PulldownBtn   ----------------
@interface PulldownBtn: UIButton

@property (assign, nonatomic) BOOL customSelected;

- (instancetype)initWithTitle:(NSString *)title norIcon:(NSString *)norIcon selectedIcon:(NSString *)selectedIocn itemTextMaxWidth:(CGFloat)itemTextMaxWidth;

- (void)modifyTitle:(NSString *)title;
@end
