//
//  DetailsBaseInfoView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsBaseInfoView : UIView
@property (strong, nonatomic) UIButton        *favoriteBtn;
@property (copy, nonatomic)   void(^pingLunBlock)(NSString *type);
@property (copy, nonatomic)   void(^favoriteBlock)();

+ (instancetype)createToSuperView:(UIView *)superView;

/**
 * 给控件赋值
 * 参数1：名称，source：方案来源，orderCount：成交量，comment：好评量
 * 如果不改变某个值，传nil
 */
- (void)refresh:(NSString *)title source:(NSString *)source orderCount:(NSString *)orderCount comment:(NSString *)comment complaintCount:(NSString *)complaintCount isFavorite:(BOOL)isFavorite;
@end
