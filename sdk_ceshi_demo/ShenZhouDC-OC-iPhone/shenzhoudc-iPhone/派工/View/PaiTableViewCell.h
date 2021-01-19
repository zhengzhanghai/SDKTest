//
//  PaiTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaiModel;
@interface PaiTableViewCell : UITableViewCell

@property (nonatomic,strong) PaiModel *model;
+ (PaiTableViewCell*)customCellWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath;
@end
