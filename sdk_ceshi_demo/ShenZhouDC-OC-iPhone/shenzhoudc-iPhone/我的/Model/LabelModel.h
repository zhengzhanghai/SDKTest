//
//  LabelModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface LabelModel : BaseModel
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *lableType;
@property(nonatomic,copy)NSString *lableContent;
@end
