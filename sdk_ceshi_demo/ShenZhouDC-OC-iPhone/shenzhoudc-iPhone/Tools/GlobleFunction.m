//
//  GlobleFunction.m
//  moguilay
//
//  Created by Moguilay on 14-2-26.
//  Copyright (c) 2014年 Moguilay. All rights reserved.
//

#import "GlobleFunction.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <ifaddrs.h>

@implementation GlobleFunction

#pragma mark 验证邮箱 0succ 1fail
+(BOOL) isStandardMail:(NSString *) mail{
    
    if (mail == nil || [mail isEqualToString:@""]) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

#pragma 验证手机号
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    
    if ([mobileNum length] == 0) {
        
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|17[0|6|7|8]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    
    if (!isMatch) {
        
        return NO;
        
    }
    
    
    
    return YES;
    
   
}

//是否存在文件
+(BOOL)FileExistAtPath:(NSString*)_filePath
{

     NSString *filePath =  [NSHomeDirectory() stringByAppendingFormat:@"%@",_filePath];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:filePath]) {
        return  YES;
    }
    return NO;
}

//创建文件夹
+(BOOL)CreateDictionary:(NSString*)path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
    {
        return  YES;
    }
    return  NO;
}
//移动文件夹

+(BOOL)MoveFileAtPath:(NSString*)path toPath:(NSString*)mPath{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager moveItemAtPath:path toPath:mPath error:nil])
    {
        return  YES;
    }
    return  NO;
}
//删除文件夹
+(BOOL)DeleteDictionary:(NSString*)path
{
    

         NSString *filePath =  [NSHomeDirectory() stringByAppendingFormat:@"%@",path];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:filePath error:nil])
    {
        return  YES;
    }
    return  NO;
}

//获取IP地址
+(NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

//核心函数  获得参数   获取URL中参数值得函数
+(NSString*)URLPaser:(NSString*)url andParaName:(NSString*)CS{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];
        return [tagValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
}

#pragma -mark 数字转换成千万单位
+(NSString *)numToNumWithNum:(int)num{

    float nums = 0.0;
    NSString *returnStr = @"";
    if (num/10000) {
        nums = num/10000.0;
        returnStr = [NSString stringWithFormat:@"%.1f万",nums];
        
    }else{
    
        returnStr = [NSString stringWithFormat:@"%d",num];
    }
    
    

    return returnStr;
}

#pragma -mark时间转换
+(NSString*)dateToNSString:(NSDate*)date
{
    
    
    
    NSTimeInterval late = [date timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚"];
            
        }else{
            
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    
    if (cha/86400 > 1)
        
    {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num = [timeString intValue];
        
        if (num < 2) {
            
            timeString = [NSString stringWithFormat:@"昨天"];
            
        }else if(num == 2){
            
            timeString = [NSString stringWithFormat:@"前天"];
            
        }else if (num > 2 && num <7){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }
        //        else if (num >= 7 && num <= 10) {
        //
        //            timeString = [NSString stringWithFormat:@"1周前"];
        //
        //        }
        else if(num >= 7){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }
        
    }
    
    
  
    return timeString;
}


#pragma -mark时间转换
+(NSString*)dateToNSStringFormt:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    
    return strDate;
}
+(NSString *)timeOfDay:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    
    return  strDate;
    
}

//判断字符是不是数字
+(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//URL Encode
+(NSString *)URLEncodedString:(NSString *)str
{
    
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                  (CFStringRef)str, nil,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedValue;
}



// 16 进制转换 RGB

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
// json  解析
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//dateToNSStringMothAndDay   dateToNSStringDay
//转化时间成时间表示格式
+(NSString*)dateToNSStringMothAndDay:(long long)date{
   
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:d];
    return strDate;
    

}


//转化时间成时间表示格式
+(NSString*)dateToNSStringMothAndDayAndHMS:(long long)date{
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:d];
    return strDate;
    
    
}


//转化时间成时间表示格式
+(NSString*)dateToNSStringDay:(long long )date{

    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:d];
    return strDate;
}


//转化时间成时间表示格式
+(NSString*)dateToNSStringYear:(NSDate*)date{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy:MM:dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
//转化时间成时间表示格式
+(NSString*)dateToNSStringTime:(NSDate*)date{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}






//判断是否为浮点形：

+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


+(CGSize)computingLabelSizeWith:(NSString *)text andWidth:(CGFloat)width andHeight:(CGFloat)height andFont:(UIFont*)font{
    CGSize size=CGSizeMake(0, 0);
    if (!text  || [text isEqualToString:@""]) {
        
    }else{
    NSString *content = text;
    CGSize constraint = CGSizeMake(width, height);
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:content
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];

     size = rect.size;
    }
    return size;
    

}





+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+(NetWorkStatus)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NetWorkStatus netStatus = NetWorkStatusIsUnknow;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    netStatus = NetWorkStatusIsNot;
                    //无网模式
                    break;
                case 1:
                    netStatus = NetWorkStatusIs2G;
                    break;
                case 2:
                    netStatus = NetWorkStatusIs3G;
                    break;
                case 3:
                    netStatus = NetWorkStatusIs4G;
                    break;
                case 5:
                    netStatus = NetWorkStatusIsWIFI;
                    break;
                default:
                    netStatus = NetWorkStatusIsUnknow;
                    break;
            }
        }
    }
    //根据状态选择
    return netStatus;
}

+ (CGFloat)getViewHeight:(NSString *)content attribute:(NSDictionary *)attribute width:(CGFloat)width
{
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}


/** 过滤表情 */
+ (NSString *)filterEmoji:(NSString *)string

{
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 =malloc(sizeof(char)*len);
    int j = 0;
    for (int i =0; i < len; i++) {
        unsigned int c = utf8[i];
        BOOL isControlChar =NO;
        if (c==4294967280) {
            i = i+3;
            isControlChar = YES;
        }
        if (!isControlChar) {
            newUTF8[j] = utf8[i];
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [[NSString alloc]initWithCString:(const char*)newUTF8 encoding:NSUTF8StringEncoding];
    return encrypted;
}


+(BOOL)Chk18PaperId:(NSString *)sPaperId
{
    //判断位数
    if ([sPaperId length] < 15 ||[sPaperId length] > 18) {
        return NO;
    }
    
    NSString *carid = sPaperId;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15) {
        
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
        
    }
    return YES;
}


#pragma -mark 解析token 
+(NSDictionary *)parseToken:(NSString *)token{
    
    NSArray *array = [token componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
    NSString *resultStr = @"";
    if (array.count>=2) {
        resultStr = array[1];
    }
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:resultStr options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    NSLog(@"Decoded: %@", base64Decoded);
    NSData *data = [base64Decoded dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", json);
    return json;
    
}

+ (BOOL)isIncludeEmoji:(NSString *)str {
    __block BOOL returnValue = NO;
    
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

@end
