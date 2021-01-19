//
//  DoubleCommentCell.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubleCommentModel.h"

@interface DoubleCommentCell : UITableViewCell
+ (instancetype)DoubleCommentCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)createDoubleCommentCellWith:(DoubleCommentModel*)model;
@end
