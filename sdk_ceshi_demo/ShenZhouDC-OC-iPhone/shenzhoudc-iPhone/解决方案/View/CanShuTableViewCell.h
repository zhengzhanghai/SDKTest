//
//  CanShuTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanShuTableViewCell : UITableViewCell

+ (instancetype)cell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)refreshCell:(NSString *)title content:(NSString *)content;

@end
