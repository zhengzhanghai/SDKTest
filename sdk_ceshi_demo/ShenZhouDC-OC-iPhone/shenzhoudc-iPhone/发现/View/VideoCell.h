//
//  VideoCell.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoCell : UITableViewCell


+ (instancetype)VideoCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath ;
- (void)refreshFileListCellWithModel:(VideoModel *)model;
@end
