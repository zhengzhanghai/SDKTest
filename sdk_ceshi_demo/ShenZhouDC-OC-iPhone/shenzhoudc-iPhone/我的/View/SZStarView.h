//
//  SZStarView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZStarView : UIView
@property (copy, nonatomic)   NSString *starStr;

- (void)setStarWithIndex:(NSInteger)index;

@end
