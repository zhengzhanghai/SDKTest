//
//  MyKeyProjectOperateImageTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyKeyProjectBuyModel.h"
#import "MyKeyProjectModel.h"

@interface MyKeyProjectOperateImageTableViewCell : UITableViewCell

@property (strong, nonatomic) MyKeyProjectBuyModel *buyModel;
@property (strong, nonatomic) MyKeyProjectModel *model;

@property (copy, nonatomic)   void(^clickBtnBlock)();

+ (instancetype)createCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
