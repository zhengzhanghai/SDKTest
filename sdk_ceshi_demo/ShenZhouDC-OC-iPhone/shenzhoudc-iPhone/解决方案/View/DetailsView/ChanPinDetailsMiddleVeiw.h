//
//  ChanPinDetailsMiddleVeiw.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChanDetailClickBlock)(NSInteger);
typedef void (^ChanPinAllCaseBlock)();

@interface ChanPinDetailsMiddleVeiw : UIView

@property (nonatomic, copy)   ChanDetailClickBlock detailClickBlock;
@property (nonatomic, copy)   ChanPinAllCaseBlock allCaseBlock;

+ (instancetype)createToSuperView:(UIView *)superView;
@end
