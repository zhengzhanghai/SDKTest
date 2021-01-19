//
//  DealViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//加了交易记录的接单页面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DealViewController : BaseViewController
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,copy)NSString *headerTitle;

@end
