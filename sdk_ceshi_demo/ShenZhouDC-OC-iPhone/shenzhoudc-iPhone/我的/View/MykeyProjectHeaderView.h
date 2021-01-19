//
//  MykeyProjectHeaderView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MykeyProjectHeaderView : UIView

@property (copy, nonatomic)  void(^clickItemBlock)(NSInteger index);

@end
