//
//  MyKeyProjectImageTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyKeyProjectModel.h"
#import "MyKeyProjectBuyModel.h"

@interface MyKeyProjectImageTableViewCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;

- (void)configWithTitle:(NSString *)title timeStr:(NSString *)timeStr status:(NSString *)statusStr;

- (void)configWithModel:(MyKeyProjectModel *)model;

- (void)configWithBuyModel:(MyKeyProjectBuyModel *)model;
@end
