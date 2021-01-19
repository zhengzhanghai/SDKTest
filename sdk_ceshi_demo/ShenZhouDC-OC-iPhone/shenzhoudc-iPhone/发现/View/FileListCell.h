//
//  FileListCell.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;

@interface FileListCell : UITableViewCell
+ (instancetype)FileListCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath ;
- (void)refreshFileListCellWithModel:(VideoModel *)model;
@end
