//
//  SkillIntelligentTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiModel.h"
typedef void(^block)();
@interface SkillIntelligentTableViewCell : UITableViewCell
@property (nonatomic,strong) PaiModel *model;
@property (nonatomic,copy) block block;
+ (SkillIntelligentTableViewCell*)customCellWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath;
@end
