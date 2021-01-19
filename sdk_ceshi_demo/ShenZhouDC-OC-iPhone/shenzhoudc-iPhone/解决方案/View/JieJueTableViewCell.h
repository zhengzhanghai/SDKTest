//
//  JieJueTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JieJueModel.h"
#import "PlanModel.h"
#import "SolutionBuyModel.h"
#import "SolutionPublishModel.h"

@interface JieJueTableViewCell : UITableViewCell

+ (JieJueTableViewCell *)jieJueCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)refreshCell:(JieJueModel *)model;
- (void)refreshWithPlan:(PlanModel *)model;
- (void)refreshWithBuySolution:(SolutionBuyModel *)model;
- (void)refreshWithPublishSolution:(SolutionPublishModel *)model;
@end
