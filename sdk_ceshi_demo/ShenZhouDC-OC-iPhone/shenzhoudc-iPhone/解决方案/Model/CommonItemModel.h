//
//  CommonItemModel.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonItemModel : NSObject
@property (copy, nonatomic) NSString *keyWord;
@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *itemName;
@property (assign, nonatomic) BOOL selected;

+ (instancetype)createModel:(NSDictionary *)dict andKeyWord:(NSString *)keyword;
@end
