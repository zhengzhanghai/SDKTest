//
//  GlobleFunction.h
//  moguilay
//
//  Created by Moguilay on 14-2-26.
//  Copyright (c) 2014年 Moguilay. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetWorkStatus) {
    NetWorkStatusIsNot = 0,
    NetWorkStatusIs2G,
    NetWorkStatusIs3G,
    NetWorkStatusIs4G,
    NetWorkStatusIsWIFI,
    NetWorkStatusIsUnknow
};

@interface GlobleFunction : NSObject
//邮箱验证
+(BOOL) isStandardMail:(NSString *) mail;

//手机号验证
+(BOOL)isMobileNumber:(NSString *)mobileNum;
//是否存在文件
+(BOOL)FileExistAtPath:(NSString*)_filePath;

//创建文件夹
+(BOOL)CreateDictionary:(NSString*)path;
//移动文件夹
+(BOOL)MoveFileAtPath:(NSString*)path toPath:(NSString*)mPath;
//删除文件
+(BOOL)DeleteDictionary:(NSString*)path;

+ (NSString *)hexStringFromString:(NSString *)string;// 16进制转换

// 时间转化
+(NSString*)dateToNSString:(NSDate*)date;

+(BOOL)isPureInt:(NSString*)string;//判断是不是数字


+(NSString *)URLEncodedString:(NSString *)str; // URL EnCode


+(NSString*)dateToNSStringMothAndDay:(long long)date;


//转化时间成时间表示格式
+(NSString*)dateToNSStringDay:(long long )date;

//核心函数  获得参数   获取URL中参数值得函数
+(NSString*)URLPaser:(NSString*)url andParaName:(NSString*)CS;


//判断是否为浮点形：
+(BOOL)isPureFloat:(NSString*)string;

+(BOOL)Chk18PaperId:(NSString *)sPaperId;

+(NSString*)dateToNSStringFormt:(NSDate*)date;
+(NSString *)timeOfDay:(NSDate*)date;//判断当前时段

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;//转换 RGB和十六进制


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;// json解析


//转化时间成时间表示格式
+(NSString*)dateToNSStringYear:(NSDate*)date;

//转化时间成时间表示格式
+(NSString*)dateToNSStringTime:(NSDate*)date;


//转化时间成时间表示格式
+(NSString*)dateToNSStringMothAndDayAndHMS:(long long)date;



//计算Label 行数 或者 列数    
+(CGSize)computingLabelSizeWith:(NSString *)text andWidth:(CGFloat)width andHeight:(CGFloat)height andFont:(UIFont*)font;



// 获取当前的网络状态
+(NetWorkStatus)getNetWorkStates;

// 计算行高
+ (CGFloat)getViewHeight:(NSString *)content attribute:(NSDictionary *)attribute width:(CGFloat)width;

// 过滤表情
+ (NSString *)filterEmoji:(NSString *)string;

#pragma -mark 解析token
+(NSDictionary *)parseToken:(NSString *)token;

// 是否包含表情
+ (BOOL)isIncludeEmoji:(NSString *)str;
@end
