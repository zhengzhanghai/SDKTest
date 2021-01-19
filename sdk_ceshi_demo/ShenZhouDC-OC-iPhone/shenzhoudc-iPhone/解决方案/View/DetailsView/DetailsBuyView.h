//
//  DetailsBuyView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DetailsBuyBlock)(NSInteger, NSInteger) ;

@interface DetailsBuyView : UIView

@property (copy, nonatomic)   DetailsBuyBlock buyBlock;

+ (instancetype)createToSuperView:(UIView *)superView;

/** 添加套餐 */
- (void)addPackage:(NSArray<NSString *> *)packages;
- (void)refresh:(NSString *)icon price:(NSString *)price bianHao:(NSString *)bianHao;

@end
