//
//  VideoModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface VideoModel : BaseModel
@property(nonatomic, copy) NSString *dataTitle;
@property(nonatomic, copy) NSString *dataUrl;
@property(nonatomic,copy)NSString *dataIcon;
@property(nonatomic,copy)NSString *dataDesc;
@property(nonatomic,strong)NSNumber *dataType;
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,copy)NSString *dataCreattime;
@end
