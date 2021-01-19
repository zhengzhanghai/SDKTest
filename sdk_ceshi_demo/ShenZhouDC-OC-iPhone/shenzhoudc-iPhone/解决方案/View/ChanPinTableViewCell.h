//
//  ChanPinTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JieJueModel.h"
#import "ChanPinModel.h"

@interface ChanPinTableViewCell : UITableViewCell
@property (copy, nonatomic)   void(^clickZanOrCaiBlock)(NSString *sourceId, NSString *type);
+ (instancetype)cell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)refresh:(JieJueModel *)model;
- (void)config:(ChanPinModel *)model;
- (void)refresh:(NSString *)icon title:(NSString *)title category:(NSString *)category orderCount:(NSString *)orderCount comment:(NSString *)comment source:(NSString *)source;
@end
