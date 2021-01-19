//
//  DetailsMiddleView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DetailClickBlock)(NSInteger);
typedef void (^AllCaseBlock)();

@interface DetailsMiddleView : UIView

@property (nonatomic, copy)   DetailClickBlock detailClickBlock;
@property (nonatomic, copy)   AllCaseBlock allCaseBlock;

+ (instancetype)createToSuperView:(UIView *)superView;
- (void)setPingjiaCount:(NSString *)pingJiaCount;
@end
