//
//  ProductScreenView.h
//  shenzhoudc-iPhone
//
//  Created by Harious on 2017/10/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductScreenView : UIView

@property (nonatomic, copy) void (^didSelectedBlock)(NSUInteger index) ;

@end
