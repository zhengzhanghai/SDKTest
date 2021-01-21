//
//  UserBaseInfoModel.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//


#import "BaseModel.h"

@interface UserBaseInfoModel : BaseModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, strong) NSString *bankAccount;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *registTime;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *background;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *attentionCount;
@property (nonatomic, strong) NSString *collectCount;
@property (nonatomic, strong) NSString *osName;
@property (nonatomic, strong) NSString *vip;
@property (nonatomic, strong) NSString *authentication;
@property (nonatomic, strong) NSString *auditStatus;
@property (nonatomic, strong) NSString *age;


@property (nonatomic, strong)NSString<Optional>  *accountId;

@property (nonatomic, strong) NSString<Optional>  *realName;
@property (nonatomic, strong) NSString<Optional>  *cardImages;

@property (nonatomic, strong) NSString<Optional>  *cardFimages;

@property (nonatomic, strong) NSString<Optional>  *jobAge;

@property (nonatomic, strong) NSString<Optional>  *desp;

@property (nonatomic, strong) NSString<Optional>  *majorThey;

@property (nonatomic, strong) NSString<Optional>  *qcimages;

@property (nonatomic, strong) NSString<Optional>  *city;


- (NSString *)userTypeStr;

+(BOOL)isLogin;

//写入本地
- (void)writeToLocal;

//读取本地
+ (instancetype)readFromLocal;

//全局共享
+ (instancetype)sharedModel;

// 删除文件
+(void)deleteFromLocal;

+ (void)loadUserInfo:( NSString * _Nonnull)userId completeHandler:(void(^ __nullable)(UserBaseInfoModel * _Nullable info, NSString * _Nullable message, NSError * _Nullable error))hander;

- (void)refreshUserInfo;
@end





