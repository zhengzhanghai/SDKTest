//
//  CityModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface CityModel : BaseModel
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSNumber *provinceId;
@end
