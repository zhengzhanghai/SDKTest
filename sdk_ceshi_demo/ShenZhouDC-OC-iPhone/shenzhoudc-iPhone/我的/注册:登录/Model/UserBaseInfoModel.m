//
//  UserBaseInfoModel.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "UserBaseInfoModel.h"

@implementation UserBaseInfoModel

//判断用户是否已经登录  根据是否有用户ID来判断
+(BOOL)isLogin{
    UserBaseInfoModel *model = [self readFromLocal];
    
    NSString* userid = @"";
    if (model.id != nil) {
        if (model.id.integerValue == 0 ){
            userid = @"";
        }else {
            userid = [NSString stringWithFormat:@"%ld",(long)model.id.integerValue];
        }
        
    }
    
    if (![userid  isEqual: @""]) {
        return YES;
    }
    
    return NO;
}

-(void)writeToLocal{
//    NSData *data = [self toJSONData];
//    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path=[paths objectAtIndex:0];
//    NSLog(@"%@",path);
//    NSString *Json_path=[path stringByAppendingPathComponent:@"userInfoFileNew.json"];
//    //写入文件
//    NSLog(@"%@",[data writeToFile:Json_path atomically:YES] ? @"1写入成功Succeed":@"1写入失败Failed");
    
    
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    NSArray *keys = [self getProperties];
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        id value = [self valueForKey:key];
        if (value) {
            [muDict setValue:value forKey:key];
        }
    }
    [USER_DEFAULT setValue:muDict forKey:NSStringFromClass([self class])];
    [USER_DEFAULT synchronize];
}

- (NSString *)userTypeStr {
    switch (_type.integerValue) {
        case -1:
            return @"游客";
            break;
        case 0:
            return @"普通用户";
            break;
        case 1:
            return @"技术达人";
            break;
        case 2:
            return @"未审核用户";
            break;
        case 3:
            return @"未审核达人用户";
            break;
        case 4:
            return @"未审核公司用户";
            break;
        case 5:
            return @"公司用户";
            break;
        case 6:
            return @"审核未通过用户";
            break;
        default:
            break;
    }
    return @"";
}


//读取文件
+ (instancetype)readFromLocal{
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path=[paths objectAtIndex:0];
//    NSString *Json_path=[path stringByAppendingPathComponent:@"userInfoFileNew.json"];
//    //==Json数据
//    NSData *data=[NSData dataWithContentsOfFile:Json_path];
//    
//    UserBaseInfoModel *model = [[UserBaseInfoModel alloc] initWithData:data error:nil];
//    
//    return model;
    
    
    
    NSDictionary *dict = [USER_DEFAULT valueForKey:NSStringFromClass([self class])];
    UserBaseInfoModel *model = nil;
    if (dict) {
        model = [UserBaseInfoModel modelWithDictionary:dict];
    } else {
        model = [UserBaseInfoModel modelWithDictionary:@{}];
    }
    return model;
}

// 删除文件
+(void)deleteFromLocal
{
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path=[paths objectAtIndex:0];
//    NSString *Json_path=[path stringByAppendingPathComponent:@"userInfoFileNew.json"];
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:Json_path error:nil];
    
    [USER_DEFAULT setValue:@{} forKey:NSStringFromClass([self class])];
    [USER_DEFAULT synchronize];
}


+(instancetype)sharedModel{
    return [self readFromLocal];
}


- (NSArray *)getProperties {
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    free(properties);
    return mArray.copy;
}


+ (void)loadUserInfo:(NSString *)userId {
    if (![UserModel isLogin]) return;
    NSString *url = [NSString stringWithFormat:@"%@%@?id=%@",DOMAIN_NAME,API_GET_NEW_USERPROFILE,userId];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        UserBaseInfoModel *model = nil;
        NSString *message = nil;
        if (result != nil) {
            message = result.getMessage;
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                dic = [NSDictionary changeType:dic];
                model = [UserBaseInfoModel modelWithDictionary:dic];
            }
        }else{
            
        }
    }];
}

@end
