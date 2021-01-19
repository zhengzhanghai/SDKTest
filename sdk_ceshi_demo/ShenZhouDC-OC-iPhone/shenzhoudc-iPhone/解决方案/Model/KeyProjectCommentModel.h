//
//  KeyProjectCommentModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface KeyProjectCommentModel : BaseModel

@property (strong, nonatomic) NSNumber *expertiseLevel;
@property (strong, nonatomic) NSNumber *serverAttitude;
@property (strong, nonatomic) NSNumber *globalAssessment;

@property (copy, nonatomic)   NSString *userName;
@property (copy, nonatomic)   NSString *createTime;
@property (copy, nonatomic)   NSString *desc;
@property (copy, nonatomic)   NSString *portrait;

@end
