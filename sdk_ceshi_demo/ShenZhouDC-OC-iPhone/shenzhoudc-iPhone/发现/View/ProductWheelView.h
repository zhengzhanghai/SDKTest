//
//  ProductWheelView.h
//  shenzhoudc-iPhone
//
//  Created by Harious on 2017/10/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductWheelView : UIView
@property (nonatomic, copy) void (^closeBlock)();
@property (nonatomic, copy) void (^didselectedBlock)(NSUInteger index);
@end
