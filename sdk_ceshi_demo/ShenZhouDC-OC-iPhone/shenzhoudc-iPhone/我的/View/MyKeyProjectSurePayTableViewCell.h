//
//  MyKeyProjectSurePayTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyKeyProjectBuyModel.h"
@interface MyKeyProjectSurePayTableViewCell : UITableViewCell

@property (strong, nonatomic) MyKeyProjectBuyModel *buyModel;

@property (copy, nonatomic)   void(^clickSurePayBlock)(NSIndexPath *indexP, MyKeyProjectBuyModel *buyModel);

+ (instancetype)createCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
