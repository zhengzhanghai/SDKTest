//
//  EvaluateView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/29.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateView : UIView
@property (copy, nonatomic) void(^finishEvalueBlock)(NSArray *starArr, NSString *evaluateContent);

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles;

- (instancetype)initSolutionWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles;

@end



