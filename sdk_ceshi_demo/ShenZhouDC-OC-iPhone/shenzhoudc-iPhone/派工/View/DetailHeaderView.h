//
//  DetailHeaderView.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiModel.h"
@interface DetailHeaderView : UITableViewHeaderFooterView
@property (nonatomic,assign) CGFloat selfHight;
+ (instancetype)customHeaaderFooterViewWith:(UITableView*)tableView;
@property (nonatomic,strong) PaiModel *model;
@end
