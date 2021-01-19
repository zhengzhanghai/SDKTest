//
//  DoubleCommentModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface DoubleCommentModel : BaseModel
@property(nonatomic ,strong) NSNumber *id;
@property(nonatomic ,strong) NSNumber *sendId; 
@property(nonatomic ,strong) NSNumber *resourceId;
@property(nonatomic ,strong) NSNumber *orderId;
@property(nonatomic ,copy) NSString *orderSn;
@property(nonatomic ,copy) NSString *createTime;
@property(nonatomic ,strong) NSNumber *standard;
@property(nonatomic ,strong) NSNumber *customers;
@property(nonatomic ,strong) NSNumber *global;
@property(nonatomic ,strong) NSNumber *observer; //1接单人 2发单人
@property(nonatomic ,copy) NSString *cause;
@property(nonatomic,strong)NSNumber  *demandCompliance;//<Optional>
@property(nonatomic,strong)NSNumber  *cooperate;//<Optional>


@end
