//
//  PublishSolutionOperateCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolutionPublishModel.h"
@interface PublishSolutionOperateCell : UITableViewCell
@property (strong, nonatomic) SolutionPublishModel *publishModel;
@property (copy, nonatomic)   void (^clickBtnBlock)(SolutionPublishModel *publishModel);
+ (instancetype)createWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
