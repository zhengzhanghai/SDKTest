//
//  SolutionCommentModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface SolutionCommentModel : BaseModel

@property (strong, nonatomic) NSNumber *userid;
@property (strong, nonatomic) NSNumber *solutionid;
@property (strong, nonatomic) NSNumber *practicability;
@property (strong, nonatomic) NSNumber *novelty;
@property (strong, nonatomic) NSNumber *usability;
@property (strong, nonatomic) NSNumber *veractiy;
@property (copy, nonatomic)   NSString *assessTime;
@property (copy, nonatomic)   NSString *portrait;
@property (copy, nonatomic)   NSString *userName;
@property (copy, nonatomic)   NSString *content;

@end
