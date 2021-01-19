//
//  ProductCategoryModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface ProductCategoryModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic)   NSString *dataCategoryUpdateName;
@property (copy, nonatomic)   NSString *dataCategoryContent;
@property (copy, nonatomic)   NSString *dataCategoryDesc;
@property (copy, nonatomic)   NSString *dataCategoryCreatetime;
@property (copy, nonatomic)   NSString *dataCategoryUpdatetime;
@property (copy, nonatomic)   NSString *dataCategoryImage;
@end
