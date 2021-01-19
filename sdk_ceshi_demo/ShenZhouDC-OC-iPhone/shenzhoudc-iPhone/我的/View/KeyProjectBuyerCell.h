//
//  KeyProjectBuyerCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyProjectBuyerModel.h"

@interface KeyProjectBuyerCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;

- (void)configWithTitle:(NSString *)title time:(NSString *)timeStr;

- (void)configWithModel:(KeyProjectBuyerModel *)model;
@end
