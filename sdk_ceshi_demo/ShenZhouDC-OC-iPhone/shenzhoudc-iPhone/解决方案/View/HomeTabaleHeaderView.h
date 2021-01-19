//
//  HomeTabaleHeaderView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickTitleBlock)(NSInteger);

@interface HomeTabaleHeaderView : UIView
@property (nonatomic, copy)  ClickTitleBlock titleBlpck;
- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;
@end
