//
//  WXLoginShare.h
//  微信登录_分享
//
//  Created by myhg on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "CommonUtil.h"
#import "BaseViewController.h"
//#import "GDataXMLNode.h"

@protocol WXLoginShareDelegate <NSObject>
/**
 *  成功
 */
typedef void(^loginSuccess)(NSDictionary *dice);
/**
 *  失败
 */
typedef void(^loginFail)(NSDictionary *dice);

typedef void(^FetchOpenIdSucess)(NSString *openId);
typedef void(^FetchOpenIdFailure)(NSString *message);
@optional
/**
 *  登录成功
 *
 *  @param dice 微信后台返回的数据
 */
- (void)WXLoginShareLoginSuccess:(NSDictionary *)dice;
/**
 *  登录失败
 *
 *  @param dice 微信后台返回的数据
 */
- (void)WXLoginShareLoginFail:(NSDictionary *)dice;

@end


@interface WXLoginShare : NSObject

@property (nonatomic,weak)id<WXLoginShareDelegate>delegate;
/**
 *  成功的block
 */
@property (nonatomic,copy)loginSuccess loginSuccessBlock;
/**
 *  失败的block
 */
@property (nonatomic,copy)loginFail loginFailBlock;

/**
 *  获取openId成功的block
 */
@property (nonatomic,copy)FetchOpenIdSucess fetchOpenIdSucess;
/**
 *  获取openId失败的block
 */
@property (nonatomic,copy)FetchOpenIdFailure fetchOpenIdFailure;

@property (strong, nonatomic) BaseViewController *currentController;

@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString *nickname; // 用户昵称
@property (strong, nonatomic) NSString *headimgurl; // 用户头像地址

+ (WXLoginShare *)shareInstance;
/**
 *  注册ID
 */
- (void)WXLoginShareRegisterApp;
/**
 *  微信登录
 */
- (void)WXLogin;
/**
 *  微信登录 block版本
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 */
- (void)WXLoginSuccess:(loginSuccess)successBlock fail:(loginFail)failBlock;


- (void)fetchOpenIdController:(BaseViewController *)controller success:(FetchOpenIdSucess)fetchSuccessBlock failure:(FetchOpenIdFailure)fetchFailureBlock;
/**
 *  微信文字分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendMessageToWX:(int)scene;
/**
 *  微信图片分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendImageToWX:(int)scene;
/**
 *  微信音乐分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendMusicToWX:(int)scene;
/**
 *  微信视频分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendVideoToWX:(int)scene;
/**
 *  微信网页分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendWebToWX:(int)scene WithUrl:(NSString *)url Title:(NSString *)title Desp:(NSString *)desp;
/**
 *  打印微信注册消息
 */
- (void)WXLoginShareMesg;
/**
 *  微信支付功能
 */

- (void)getWeChatPayWithOrderName:(NSString *)name price:(NSString*)price appId:(NSString *)app_id orderSn:(NSString *)orderSn;

- (void)getRechargeNumberWithPrice:(NSString *)price appId:(NSString *)app_Id orderId:(NSString *)orderId callBack:(void(^)(NSInteger, NSString *))callBack;
- (NSString *)jumpToBizPay;

-(void)sendPayInfoToServer;

@end
