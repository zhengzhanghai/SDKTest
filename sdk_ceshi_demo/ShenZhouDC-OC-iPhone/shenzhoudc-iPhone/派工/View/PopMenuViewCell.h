//
//  PopMenuViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopMenuViewCell : UITableViewCell
+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)configWIthTitle:(NSString *)title;
@end
