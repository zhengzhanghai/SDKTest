//
//  PaiModel.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface PaiModel : BaseModel
@property(nonatomic,strong) NSNumber *id;
@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,strong) NSNumber *assignStatus;
@property(nonatomic,strong) NSNumber *categoryId;
@property(nonatomic,copy) NSString *provinceName;
@property(nonatomic,copy) NSString *categoryName;
//地区ID
@property(nonatomic,strong) NSNumber *provinceId;
@property(nonatomic,copy) NSString *names;
@property(nonatomic,copy) NSString *desp;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,strong) NSNumber *orderUserId;
//派工详情轮播图
@property(nonatomic,copy) NSString *downUrl;
//达人名称
@property(nonatomic,copy) NSString *nickName;
//达人头像
@property(nonatomic,copy) NSString *portrait;
@property(nonatomic,copy) NSString *isSelected;
/**
 *  评价列表
 */
@property(nonatomic,strong) NSNumber *sendId;
@property(nonatomic,copy) NSString *score;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *createTime;
@end
