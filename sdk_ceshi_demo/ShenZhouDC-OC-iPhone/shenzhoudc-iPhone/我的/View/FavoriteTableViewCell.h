//
//  FavoriteTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteModel.h"

@interface FavoriteTableViewCell : UITableViewCell
@property (strong, nonatomic) FavoriteModel *model;

+ (instancetype)create:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
