//
//  PublishSolutionCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolutionPublishModel.h"

@interface PublishSolutionCell : UITableViewCell

@property (strong, nonatomic) SolutionPublishModel *publishModel;
+ (instancetype)createWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
