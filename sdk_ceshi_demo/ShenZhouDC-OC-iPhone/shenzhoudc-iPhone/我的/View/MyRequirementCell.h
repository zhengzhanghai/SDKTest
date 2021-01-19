//
//  MyRequirementCell.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiModel.h"

@interface MyRequirementCell : UITableViewCell

@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *accessLabel;

+ (MyRequirementCell*) makeMyRequirementCell:(UITableView *)tableView WithIndexPath:(NSIndexPath *)indexPath;
-(void)makeMyRequirementCellWithModel:(PaiModel *)model;
@end
