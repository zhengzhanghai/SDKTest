//
//  MyKeyProjectOperateTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/29.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyKeyProjectBuyModel.h"
#import "MyKeyProjectModel.h"

@interface MyKeyProjectOperateTableViewCell : UITableViewCell

@property (strong, nonatomic) MyKeyProjectBuyModel *buyModel;
@property (strong, nonatomic) MyKeyProjectModel *model;

@property (copy, nonatomic)   void(^clickBtnBlock)();

+ (instancetype)createCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end
