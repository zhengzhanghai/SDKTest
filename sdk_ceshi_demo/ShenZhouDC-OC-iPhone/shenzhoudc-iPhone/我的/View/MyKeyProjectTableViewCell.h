//
//  MyKeyProjectTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyKeyProjectModel.h"
#import "MyKeyProjectBuyModel.h"

@interface MyKeyProjectTableViewCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

- (void)configWithTitle:(NSString *)title timeStr:(NSString *)timeStr status:(NSString *)statusStr;

- (void)configWithModel:(MyKeyProjectModel *)model;

- (void)configWithBuyModel:(MyKeyProjectBuyModel *)model;
@end
