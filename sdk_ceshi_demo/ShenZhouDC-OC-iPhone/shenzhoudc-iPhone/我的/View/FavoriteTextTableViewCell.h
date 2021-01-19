//
//  FavoriteTextTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteModel.h"


@interface FavoriteTextTableViewCell : UITableViewCell
@property (strong, nonatomic) FavoriteModel *model;

+ (instancetype)create:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
