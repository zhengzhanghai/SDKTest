//
//  PaiGongCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/5.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaiGongCell : UITableViewCell

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)configWithTitle:(NSString *)title address:(NSString *)address serviceTime:(NSString *)serviceTime technologyType:(NSString *)technologyType;

@end
