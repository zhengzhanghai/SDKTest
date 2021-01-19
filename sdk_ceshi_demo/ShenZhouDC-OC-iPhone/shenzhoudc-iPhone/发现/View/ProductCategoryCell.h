//
//  ProductCategoryCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCategoryCell : UITableViewCell

+ (instancetype)createWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)configWIthIcon:(NSString *)icon title:(NSString *)title;

@end
