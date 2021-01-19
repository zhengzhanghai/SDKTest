//
//  ChanPinModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface ChanPinModel : BaseModel
@property(nonatomic, copy) NSString *dataTitle;
@property(nonatomic, copy) NSString *dataUrl;
@property(nonatomic,copy)NSString *dataIcon;
@property(nonatomic,copy)NSString *dataDesc;
@property(nonatomic,strong)NSNumber *dataType;
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,copy)NSString *dataCreattime;
@property(nonatomic,strong)NSNumber *dataThumbsUp;
@property(nonatomic,strong)NSNumber *dataMakeComplaints;
@property(nonatomic, copy) NSString *dataCategoryName;
@property(nonatomic, copy) NSString *dataTypeName;
@property (strong, nonatomic) NSNumber *isCollent;
@end
