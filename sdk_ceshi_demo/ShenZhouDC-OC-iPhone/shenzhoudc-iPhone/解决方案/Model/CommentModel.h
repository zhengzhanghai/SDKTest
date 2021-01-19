//
//  CommentModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *sendId;
@property (strong, nonatomic) NSNumber *score;
@property (copy, nonatomic)   NSString *nickName;
@property (copy, nonatomic)   NSString *portrait;
@property (copy, nonatomic)   NSString *content;
@property (copy, nonatomic)   NSString *createTime;
@end
