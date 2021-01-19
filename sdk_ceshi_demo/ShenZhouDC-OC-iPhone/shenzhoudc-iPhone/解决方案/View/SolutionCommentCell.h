//
//  SolutionCommentCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolutionCommentModel.h"

@interface SolutionCommentCell : UITableViewCell
@property (strong, nonatomic) SolutionCommentModel *model;
+ (instancetype)cell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
