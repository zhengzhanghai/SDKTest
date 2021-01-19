//
//  keyProjectCommentTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyProjectCommentModel.h"

@interface keyProjectCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) KeyProjectCommentModel *model;

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
