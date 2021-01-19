//
//  MenuCell.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

+ (instancetype)menuCell:(UITableView *)tableView
               indexPath:(NSIndexPath *)indexPath;

- (void)config:(NSString *)title icon:(NSString *)icon;
- (void)setNorlal:(NSString *)icon;
- (void)setSelect:(NSString *)icon;
@end
