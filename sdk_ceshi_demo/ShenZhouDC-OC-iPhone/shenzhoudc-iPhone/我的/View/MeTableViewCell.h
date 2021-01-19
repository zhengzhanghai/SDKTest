//
//  MeTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *accessLabel;


+ (MeTableViewCell*) makeMeTableViewCell:(UITableView *)tableView WithIndexPath:(NSIndexPath *)indexPath;

@end
