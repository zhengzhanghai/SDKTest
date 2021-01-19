//
//  FavoriteModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface FavoriteModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *userid;
@property (strong, nonatomic) NSNumber *goodsid;
@property (strong, nonatomic) NSNumber *goosType;
@property (copy, nonatomic)   NSString *collectionTime;
@property (copy, nonatomic)   NSString *goodsName;
@property (copy, nonatomic)   NSString *image;

- (NSString *)goodsTypeName;
@end
