//
//  MyKeyProjectTableViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, KeyProjectTableType) {
    KeyProjectTableTypePublish,
    KeyProjectTableTypeBuy
};

@interface MyKeyProjectTableViewController : BaseViewController
@property (assign, nonatomic) KeyProjectTableType type;
@end
