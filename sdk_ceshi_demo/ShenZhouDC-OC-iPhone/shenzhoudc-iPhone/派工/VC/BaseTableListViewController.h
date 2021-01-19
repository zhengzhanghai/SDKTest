//
//  BaseTableListViewController.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void(^baseRefreshBlcok)();
@interface BaseTableListViewController : BaseViewController
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSourse;
@property(nonatomic,copy)baseRefreshBlcok baseRefreshBlcok;

@end
