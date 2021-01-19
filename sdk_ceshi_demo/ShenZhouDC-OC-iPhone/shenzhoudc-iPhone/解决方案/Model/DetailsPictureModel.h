//
//  DetailsPictureModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/11.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface DetailsPictureModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *productId;
@property (copy, nonatomic)   NSString *image;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *sort;
@property (copy, nonatomic)   NSString *createTime;
@property (copy, nonatomic)   NSString *modifyTime;

@end
