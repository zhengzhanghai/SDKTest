//
//  SolutionDetailsContentView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/12.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanDetailsModel.h"

@interface SolutionDetailsContentView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame planDetails:(PlanDetailsModel *)model;

@end
