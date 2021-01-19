//
//  CommonMacro.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/22.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//


#ifndef ___CommonMacro_h
#define ___CommonMacro_h


#pragma mark - **** Common Macro ****
#pragma mark -

#import "AppDelegate.h"


#define PDFDEMOURL @"http://transition.fcc.gov/Forms/Form740/740.pdf"//PDF demo演示需要

#pragma -mark 第三方相关

// 百度地图  API  APPKEY
#define BAIDUMAP @"EGZudhexGG8Wu2sY8ginDydP"//测试用  记得更换



//#define kWXAPP_ID @"wx5199f2a6aceb216e"
//#define kWXAPP_SECRET @"ab16e91bd9ed2f2fb6922d1b7ea6b115"


//微信相关  WECHAT
#define WXAPPID @"wxb3d40429b2924b95"
#define WXSECRET @"75df53c50d22413a44bb73cfedabd404"
#define SHAREWX @""// 分享到微信等自定义URL
#define WXPartnerId @"1486541112" //微信商户号
#define WXAPIKey @"b63ee8072bd84cbeb68a0c5e0241aa39" //API密钥 洗衣机
#define SHARE_TITLE @""// 分享到微信的文字描述
#define WXunifiedorder @"http://pay.eteclab.org/api/v1/charge/order"

//uemng  统计  APPKEY
#define UMCLICK @"55ec0d7267e58e6824000827"// 记得更换

//支付宝相关  WECHAT
#define AliScheme @"com.enetic.sengzhoufanganyun.alipay" //"URLScheme中跟传给支付宝的要一致"WashingMechine

#define JUMP_APP @""

// 极光推送  KEY
// 极光推送  KEY
#define JPush_APPKEY @"a93178cf2afc6353d729a9c8"   // 测试用

//主颜色 红色值
#define MainColor UIColorFromRGB(0xFF455B)

//网络请求接口define
#pragma mark - 网络请求地址
//正式接口
//#define SERVICE_BASE_ADDRESS     @"http://shenzhou.enetic.cn/api/"
// 测试接口
//#define SERVICE_BASE_ADDRESS     @"http://192.168.1.10:8083/api/"


//客户端路径定义
#pragma mark - 客户端路径定义
//document目录   一般需要持久的数据都放在此目录中，可以在当中添加子文件夹，iTunes备份和恢复的时候，会包括此目录。
#define DOCUMENTDICTIONARY     [NSHomeDirectory() stringByAppendingFormat:@"/Library/Private Documents"]
//temp文件目录  创建临时文件的目录，当iOS设备重启时，文件会被自动清除
#define TEMP_DICTIONARY     [NSTemporaryDirectory() stringByAppendingFormat:@"/tmp"]
//cache目录
#define CACHE_DICTIONARY     [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches"]


// 缓存主目录
#define DMCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"DMCache"]

// 文件的存放路径（caches）
#define DMFileFullpath(url) [DMCachesDirectory stringByAppendingPathComponent:DMFileName(url)]

// 保存文件名
#define DMFileName(url)  [[url componentsSeparatedByString:@"/"] lastObject]




//RGB 三个参数数值相同
#define UIColorFromSameRGB(r) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:1]

// 主题蓝
#define THEMECOLOR [UIColor colorWithRed:79/255.0f green:185/255.0f blue:232/255.0f alpha:1]
// 背景灰
#define D_BG_GRAY_COLOR [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f]


#define APP_DELEGATE_INSTANCE                       ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define USER_DEFAULT                                [NSUserDefaults standardUserDefaults]
#define MAIN_STORY_BOARD(Name)                      [UIStoryboard storyboardWithName:Name bundle:nil]
#define NS_NOTIFICATION_CENTER                      [NSNotificationCenter defaultCenter]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_5_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")
#define IS_OS_6_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define IS_OS_7_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define IS_OS_9_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

#define IS_WIDESCREEN_5                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6Plus                        (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)
#define IS_IPHONE                                  ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"] || [[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"])
#define IS_IPOD                                    ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])
#define IS_IPHONE_5                                (IS_IPHONE && IS_WIDESCREEN_5)
#define IS_IPHONE_6                                (IS_IPHONE && IS_WIDESCREEN_6)
#define IS_IPHONE_6Plus                            (IS_IPHONE && IS_WIDESCREEN_6Plus)


#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#define UI_WITH_RATE  [GlobleFunction getUIWidthRate]
#define UI_FONT_RATE  [GlobleFunction getUIFontRate]

//常见的Bar高度
#define TABBARHEIGHT 49
#define NAVBARHEIGHT 44
#define STATUSBARHEIGHT [[UIApplication sharedApplication]statusBarFrame].size.height
//#define STATUSBARHEIGHT 20

#define TOPBARHEIGHT            (NAVBARHEIGHT+STATUSBARHEIGHT)
#define CONTENTHEIGHT_NOTOP     (SCREEN_HEIGHT-TOPBARHEIGHT)
#define CONTENTHEIGHT_NOTABBAR  (SCREEN_HEIGHT-TABBARHEIGHT)
#define CONTENTHEIGHT_NOTAB_NOTOP (SCREEN_HEIGHT-TABBARHEIGHT-TOPBARHEIGHT)

#define DOT_COORDINATE                  0.0f
#define STATUS_BAR_HEIGHT               0.0f
#define BAR_ITEM_WIDTH_HEIGHT           30.0f
#define NAVIGATION_BAR_HEIGHT           35.0f
#define TAB_TAB_HEIGHT                  49.0f
#define TABLE_VIEW_ROW_HEIGHT           NAVIGATION_BAR_HEIGHT
#define CONTENT_VIEW_HEIGHT_NO_TAB_BAR  (SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)
#define CONTENT_VIEW_HEIGHT_TAB_BAR     (CONTENT_VIEW_HEIGHT_NO_TAB_BAR - TAB_TAB_HEIGHT)

#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


#define IFISNIL(v)                      (v = (v != nil) ? v : @"")
#define IFISNILFORNUMBER(v)             (v = (v != nil) ? v : [NSNumber numberWithInt:0])
#define IFISSTR(v)                      (v = ([v isKindOfClass:[NSString class]]) ? v : [NSString stringWithFormat:@"%@",v])


#pragma mark - **** Constants ****
#pragma mark -

#define ARROW_BUTTON_WIDTH              NAVIGATION_BAR_HEIGHT
#define NAV_TAB_BAR_HEIGHT              ARROW_BUTTON_WIDTH
#define ITEM_HEIGHT                     NAV_TAB_BAR_HEIGHT

#define NavTabbarColor                  UIColorWithRGBA(240.0f, 230.0f, 230.0f, 1.0f)
#define SCNavTabbarBundleName           @"SCNavTabBar.bundle"
#define WX_ACCESS_TOKEN                 @"access_token"
#define WX_OPEN_ID                      @"openid"
#define WX_REFRESH_TOKEN                @"refresh_token"

#define SCNavTabbarSourceName(file) [SCNavTabbarBundleName stringByAppendingPathComponent:file]

#define GET_LandscapeNumber(num) (SCREEN_HEIGHT*num/375.0)

#define LandscapeNumber(num) (SCREEN_WIDTH*num/375.0)


#define IS_IPAD  [[[UIDevice currentDevice] model] isEqualToString:@"iPad"]

#endif

