//
//  MyKeyProjectBuyModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface MyKeyProjectBuyModel : BaseModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *pkgId;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic)   NSString *name;
@property (copy, nonatomic)   NSString *updateTime;
@property (copy, nonatomic)   NSString *image;

- (NSString *)stasusString;
@end
