//
//  ChanPinDetailsBaseInfoView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanPinDetailsBaseInfoView : UIView

+ (instancetype)createToSuperView:(UIView *)superView;
- (void)refresh:(NSString *)title source:(NSString *)source bianHao:(NSString *)bianHao huoHao:(NSString *)huoHao;
@end
