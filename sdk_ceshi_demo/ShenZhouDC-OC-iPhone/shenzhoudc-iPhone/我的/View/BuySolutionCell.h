//
//  BuySolutionCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolutionBuyModel.h"

@interface BuySolutionCell : UITableViewCell

@property (strong, nonatomic) SolutionBuyModel *buyModel;

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@end
