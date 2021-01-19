//
//  UserModel.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//


#import "JSONModel.h"
#import "BaseModel.h"



@interface UserModel : BaseModel   //JSONModel
//@property(nonatomic, strong)NSString *exp;//数值类型
//@property(nonatomic, strong)NSString *iat;//刷新时间
//@property(nonatomic, strong)NSString *sub;//用户名
@property(nonatomic, strong)NSString *userId;//用户ID
//@property(nonatomic, strong)NSString *userType;//用户类型 -1访客 0 普通用户 1技术达人 2厂商 3代理商 4集成商 5普通企业用户
@property(nonatomic,strong)NSNumber *type;
@property(nonatomic, strong)NSString *token;

- (NSString *)userTypeStr;

//@property(nonatomic, strong)NSString *refreshToken;
+(BOOL)isLogin;//判断用户是否已经登录

//写入本地
- (void)writeToLocal;

//读取本地
+ (instancetype)readFromLocal;

//全局共享
+ (instancetype)sharedModel;

// 删除文件
+(void)deleteFromLocal;
@end
