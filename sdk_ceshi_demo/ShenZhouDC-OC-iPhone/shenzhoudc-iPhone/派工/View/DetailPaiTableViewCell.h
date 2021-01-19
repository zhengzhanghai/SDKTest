//
//  DetailPaiTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaiModel;
@interface DetailPaiTableViewCell : UITableViewCell
@property (nonatomic,strong) PaiModel *model;
+ (DetailPaiTableViewCell*)customCellWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath;
@end
