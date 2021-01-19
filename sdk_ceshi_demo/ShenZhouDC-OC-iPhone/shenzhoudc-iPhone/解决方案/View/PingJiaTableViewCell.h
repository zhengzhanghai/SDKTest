//
//  PingJiaTableViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "DoubleCommentModel.h"

@interface PingJiaTableViewCell : UITableViewCell
+ (instancetype)pingJiaCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)refreshCell:(CommentModel*)model;
- (void)createCellWith:(DoubleCommentModel*)model;
/**
 *  @param icon     头像
 *  @param nickName 昵称
 *  @param score    星级
 *  @param time     评论时间
 *  @param content  评论内容
 */
- (void)refreshCell:(NSString *)icon nickName:(NSString *)nickName score:(int)score time:(NSString *)time content:(NSString *)content;
/** 加载模拟数据 */
- (void)refreshCell;
@end
