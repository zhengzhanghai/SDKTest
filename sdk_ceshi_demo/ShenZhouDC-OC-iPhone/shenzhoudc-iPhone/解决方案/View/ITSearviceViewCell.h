//
//  ITSearviceViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITServiceModel.h"

@interface ITSearviceViewCell : UITableViewCell

@property (strong, nonatomic) ITServiceModel *serModel;

+ (instancetype)create:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
