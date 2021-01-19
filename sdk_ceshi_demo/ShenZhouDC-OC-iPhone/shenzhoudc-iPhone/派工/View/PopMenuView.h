//
//  PopMenuView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopMenuView : UIView

@property (copy, nonatomic)   void(^clickSelfBlock)();

@property (copy, nonatomic)   void(^clickCellBlock)(NSInteger cellIndex, NSString *title);

- (instancetype)initWithShapeLayerFrame:(CGRect)frame withArrowCenterX:(CGFloat)arrowCenterX titles:(NSArray *)titles;

- (void)showWithAnimation:(NSTimeInterval)time completed:(void(^)())completed;

- (void)hiddenWithAnimation:(NSTimeInterval)time completed:(void(^)())completed;
@end
