//
//  SolutionCollectionHeaderView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SolutionClickTitleBlock)(NSInteger);

@interface SolutionCollectionHeaderView : UICollectionReusableView
    @property (nonatomic, copy)  SolutionClickTitleBlock titleBlpck;
- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;
@end
