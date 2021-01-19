//
//  UserModel.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
//判断用户是否已经登录  根据是否有用户ID来判断
+(BOOL)isLogin{
    UserModel *model = [self readFromLocal];
    
    NSString* userid = @"";
    if (model.userId != nil) {
        if (model.userId.integerValue == 0 ){
            userid = @"";
        }else {
            userid = [NSString stringWithFormat:@"%ld",(long)model.userId.integerValue];
        }
        
    }
    
    if (![userid  isEqual: @""]) {
        return YES;
    }
    
    return NO;
}

-(void)writeToLocal{
    NSData *data = [self toJSONData];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"%@",path);
    NSString *Json_path=[path stringByAppendingPathComponent:@"userFile.json"];//Info
    //写入文件
    NSLog(@"%@",[data writeToFile:Json_path atomically:YES] ? @"Succeed写入成功":@"写入失败Failed");
    
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
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:@"userFile.json"];//Info
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:Json_path];
    
    UserModel *model = [[UserModel alloc] initWithData:data error:nil];
    
    return model;
    
}

// 删除文件
+(void)deleteFromLocal
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:@"userFile.json"];//Info
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:Json_path error:nil];
}


+(instancetype)sharedModel{
    return [self readFromLocal];
}

@end
