//
//  SolutionCommentTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolutionCommentModel.h"

@interface SolutionCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) SolutionCommentModel *model;

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end
