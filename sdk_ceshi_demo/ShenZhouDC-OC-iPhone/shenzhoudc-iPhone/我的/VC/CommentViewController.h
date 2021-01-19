//
//  CommentViewController.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentViewController : BaseViewController

@property(nonatomic , assign) int commentId;// 区分是什么类别的评价 1 商品   2 需求  3 解决方案 4 派工
@property(nonatomic , copy) NSString *resourceId; //评论的资源id
@property(nonatomic , copy) NSString *orderId; //订单id
@end
