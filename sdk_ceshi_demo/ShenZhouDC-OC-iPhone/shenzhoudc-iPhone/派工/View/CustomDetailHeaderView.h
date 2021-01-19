//
//  CustomDetailHeaderView.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 17/1/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiModel.h"
@interface CustomDetailHeaderView : UIView
@property (nonatomic,assign) CGFloat selfHight;
@property (nonatomic,strong) PaiModel *model;
- (void)setCycleScrollViewImage:(NSArray*)model;
@end
