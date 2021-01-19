//
//  ProductFiltrateView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductFiltrateView : UIView

@property (copy, nonatomic)   void (^finishFiltrateBlock)(NSString *filtrateId, NSString *filtrateName);

@property (copy, nonatomic)   void (^finishFiltrateWithNameBlock)(NSString *filtrateName);

- (void)showWithAnimated:(BOOL)animated;

- (void)removeFromSuperviewWithAnimated:(BOOL)animated;
@end
