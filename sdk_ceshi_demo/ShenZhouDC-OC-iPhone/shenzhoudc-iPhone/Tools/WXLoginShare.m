//
//  WXLoginShare.m
//  微信登录_分享
//
//  Created by myhg on 16/3/22.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "WXLoginShare.h"
//#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UserModel.h"




@interface WXLoginShare ()
{
    NSString *nonceStr;
    NSString *paySign ;
    NSString *prePayId;
    NSString *signType;
    NSString *timeStamp;
    NSString *priceStr;
    NSString *payResultMsg;
    NSString *orderID;
    NSString *appId;
}

@property (nonatomic,copy)NSString *kWeiXinRefreshToken;

@property (copy, nonatomic) void (^payCallBack)(NSInteger, NSString *);

@end

@implementation WXLoginShare

+ (WXLoginShare *)shareInstance {
    static WXLoginShare *LoginShare = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        LoginShare = [[self alloc] init];
    });
    return LoginShare;
}
/**
 *  注册ID
 */
- (void)WXLoginShareRegisterApp{
    [WXApi registerApp:WXAPPID];
    NSLog(@"跳进来了~~~~~~~~~~~~~2");
}

/**
 *  打印微信注册消息
 */
- (void)WXLoginShareMesg{
    NSLog(@"微信注册ID");
    NSLog(@"跳进来了~~~~~~~~~~~~~1");
}
/**
 *  微信登录
 */
- (void)WXLogin{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"WXLoginViewController";
    [WXApi sendReq:req];
    NSLog(@"跳进来了~~~~~~~~~~~~~3");
}
/**
 *  微信登录 block版本
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 */
- (void)WXLoginSuccess:(loginSuccess)successBlock fail:(loginFail)failBlock{
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"WXLoginViewController";
    [WXApi sendReq:req];
    
    self.loginSuccessBlock = ^(NSDictionary *dic){
        successBlock(dic);
    };
    self.loginFailBlock = ^(NSDictionary *dic){
        failBlock(dic);
    };
}

- (void)fetchOpenIdController:(BaseViewController *)controller success:(FetchOpenIdSucess)fetchSuccessBlock failure:(FetchOpenIdFailure)fetchFailureBlock {
    _currentController = controller;
    _fetchOpenIdSucess = fetchSuccessBlock;
    _fetchOpenIdFailure = fetchFailureBlock;
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"WXLoginViewController";
    [WXApi sendReq:req];
}


/**
 *  微信文字分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendMessageToWX:(int)scene{
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = @"测试数据";
    req.bText = YES;
    req.scene = scene;
    [WXApi sendReq:req];
}
/**
 *  微信图片分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendImageToWX:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    WXImageObject *imageobject = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
    imageobject.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
/**
 *  微信音乐分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendMusicToWX:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这事一首音乐";
    message.description = @"好听吗?";
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    
    WXMusicObject *musicobject = [WXMusicObject object];
    musicobject.musicUrl = @"http://tsmusic24.tc.qq.com/102396.mp3";
    musicobject.musicLowBandUrl = musicobject.musicUrl;
    musicobject.musicDataUrl = @"http://tsmusic24.tc.qq.com/102396.mp3";
    musicobject.musicLowBandDataUrl = musicobject.musicDataUrl;
    message.mediaObject = musicobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

/**
 *  微信视频分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendVideoToWX:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这事一段视频";
    message.description = @"好看吗?";
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    
    WXVideoObject *videoobject = [WXVideoObject object];
    videoobject.videoUrl = @"http://www.iqiyi.com/v_19rrok5lvc.html";
    videoobject.videoLowBandUrl = videoobject.videoUrl;
    message.mediaObject = videoobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

/**
 *  微信网页分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendWebToWX:(int)scene WithUrl:(NSString *)url Title:(NSString *)title Desp:(NSString *)desp{

        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = desp;
        [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
        WXWebpageObject *ext = [WXWebpageObject object];
       
        NSLog(@"..................%@",url);
        ext.webpageUrl = url;
        message.mediaObject = ext;
    
    
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        
        [WXApi sendReq:req];
}

/**
 *  获取access_token
 *  @param code code description
 */
- (void)getAccessTokenWithCode:(NSString *)code {
    [_currentController showLoadingToView:_currentController.view];
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,WXSECRET,code];

    
    NSLog(@"微信登录的网址是： = %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_currentController hiddenLoading];
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dict = %@",dict);
                if ([dict objectForKey:@"errcode"])
                {
                    if (_fetchOpenIdFailure) {
                        _fetchOpenIdFailure(@"微信授权失败");
                    }
                    if (self.loginFailBlock) {
                        self.loginFailBlock(dict);
                    }
                    // 授权失败(用户取消/拒绝)
                    if ([self.delegate respondsToSelector:@selector(WXLoginShareLoginFail:)]) {
                        [self.delegate WXLoginShareLoginFail:dict];
                    }
                }else{
                    if ([dict objectForKey:@"openid"]) {
                        if (_fetchOpenIdSucess) {
                            _fetchOpenIdSucess([dict objectForKey:@"openid"]);
                            return ;
                        }
                    }
                    self.kWeiXinRefreshToken = [dict objectForKey:@"access_token"];
                    self.openid = [dict objectForKey:@"openid"];
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
}
/**
 *  获取用户信息
 *
 *  @param accessToken access_token
 *  @param openId      openId description
 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSLog(@"urlString = %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"dict = %@",dict);
                if ([dict objectForKey:@"errcode"])
                {
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults] objectForKey:self.kWeiXinRefreshToken]];
                }else{
                    if (self.loginSuccessBlock) {
                        self.loginSuccessBlock(dict);
                    }
                    if ([_delegate respondsToSelector:@selector(WXLoginShareLoginSuccess:)]) {
                        [_delegate WXLoginShareLoginSuccess:dict];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoginApp" object:self userInfo:@{@"openId":openId}];
                    
                    
                }
            }
        });
    });
    

}
/**
 *  刷新access_token
 *
 *  @param refreshToken refreshToken description
 */
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WXAPPID,refreshToken];//@"wx29c1153063de230b"
    

    NSLog(@"urlString = %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else{
                    //重新使用AccessToken获取信息
                }
            }
        });
    });
    
}

#pragma mark - 微信支付相关--通过app直接跳转至支付-----------------------------------------


//根据商品的信息获取本地业务订单号******************************************************/
//- (void) getOrderIdFromServerWithProductName:(NSString *)name price:(NSString*)price {
//    
//    __weak WXLoginShare *weakSelf = self;
//    NSString *url = [NSString stringWithFormat:@"%@userPaycheck/getOrderNumber/1",DOMAIN_NAME];//,[UserModel sharedModel].userId
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"%@",responseObject);
//          NSDictionary *dic = [responseObject objectForKey:@"data"];
//        orderID = dic[@"orderSn"];
//        
//        [weakSelf getWeChatPayWithOrderName:name price:price];
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    
//}

//神州云方案的获取本地业务订单号接口，传入用户充值的金额。可返回调起微信支付时需要的参数：orderSn、appId
- (void)getRechargeNumberWithPrice:(NSString *)price appId:(NSString *)app_Id orderId:(NSString *)orderId callBack:(void(^)(NSInteger, NSString *))callBack{
    _payCallBack = callBack;
    [self getWeChatPayWithOrderName:@"神州方案云-平台消费" price:price appId:app_Id orderSn:orderId];
//    __weak WXLoginShare *weakSelf = self;
//    NSString *api = [NSString stringWithFormat:@"%@v1/payment/recharge",DOMAIN_NAME];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"nickName"] = [UserBaseInfoModel sharedModel].nickName;
//    params[@"accountId"] = [UserBaseInfoModel sharedModel].id;
//    params[@"price"] = price;
//    
//    NSLog(@" --- %@,,,%@",params,api);
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [manager POST:api parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"通知服务器即将支付成功===%@",responseObject);
//        int code = [[responseObject objectForKey:@"code"] intValue];
//        if (code == 1000) {
//            NSDictionary *dic = [responseObject objectForKey:@"data"];
//            
//            appId = [[dic objectForKey:@"appId"] stringValue];
//            orderID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rechargeNo"]];
//            [weakSelf getWeChatPayWithOrderName:@"神州方案云-平台消费" price:price];
//        } else {
//            if (_payCallBack) {
//                _payCallBack(0, [responseObject objectForKey:@"message"]);
//            }
//            
//        }
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (_payCallBack) {
//            _payCallBack(0, @"请求失败");
//        }
//        NSLog(@"请求失败%@",error);
//    }];
}
// 调起微信支付，传进来商品名称和价格
- (void)getWeChatPayWithOrderName:(NSString *)name price:(NSString*)price appId:(NSString *)app_id orderSn:(NSString *)orderSn
{
   
    
    priceStr = price;
    //**************  一、通过本地服务器提供的接口

    NSString *url = @"http://pay.eteclab.org/api/v1/charge/order";//本地服务器的统一下单接口，微信支付宝都一样，传参不一样
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 应用  新的参数
    params[@"appId"] = app_id;
    //订单号
    params[@"orderSn"] = orderSn;
    // 价格
    params[@"amount"] = price;//单位是分。输入的金额需要 X100 传给服务器
    // 支付渠道
    params[@"channel"] = @"wx";  //微信支付
    //商品描述
    params[@"body"] = name;
    //商品描述
    params[@"subject"] = name;
    
    
    NSLog(@"参数参数参数参数参数参数参数参数参数参数参数参数参数==%@",params);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 1000) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            prePayId = [dataDic objectForKey:@"prePayId"];
            nonceStr = [dataDic objectForKey:@"nonceStr"];
            paySign = [dataDic objectForKey:@"paySign"];
            timeStamp = [dataDic objectForKey:@"timeStamp"];
            signType = [dataDic objectForKey:@"paySign"];
            
            // 调起微信支付
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = WXPartnerId;
            /** 预支付订单 */
            request.prepayId = prePayId;
            /** 商家根据财付通文档填写的数据和签名 */
            request.package = @"Sign=WXPay";
            /** 随机串，防重发 */
            request.nonceStr = nonceStr;
            /** 时间戳，防重发 */
            NSString *timeStr = timeStamp;
            request.timeStamp = (UInt32)timeStr.integerValue;
            request.sign = signType;
            
            if (_payCallBack) {
                _payCallBack(1, [responseObject objectForKey:@"message"]);
            }
            [WXApi sendReq:request];
            
        } else {
            if (_payCallBack) {
                _payCallBack(0, [responseObject objectForKey:@"message"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_payCallBack) {
            _payCallBack(0, @"请求失败");
        }
        NSLog(@"失败~~~~~~~~~~~~~~~~~~~~~%@",error);
    }];
}

#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp {
    //微信支付
    if ([resp isKindOfClass:[PayResp class]]) {
        
        NSLog(@"进入回调信息~~~~~~~~~~");
//        [self sendPayInfoToServer];
        
        //        switch (resp.errCode) {
        //            case WXSuccess:
        //                NSLog(@"进入回调成功里面~~~~~~~~~~~~");
        //                // 三、给服务器发送查询支付订单是否成功的请求，如果确定已支付成功，再返回结果
        //                [self sendPayInfoToServer];
        //                break;
        //            default:
        //
        //                break;
        //        }
    }
    
    // 微信登录
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        if (resp.errCode == 0) {
            
            NSLog(@"跳进来了~~~~~~~~~~~~~3");
            
            SendAuthResp *aresp = (SendAuthResp *)resp;
            [self getAccessTokenWithCode:aresp.code];
            return;
        } else {
            if (_fetchOpenIdFailure) {
                _fetchOpenIdFailure(@"微信授权失败");
            }
        }
    }
    
    // 微信分享/收藏
    //    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
    //        SendMessageToWXResp *aresp = (SendMessageToWXResp *)resp;
    //        NSLog(@"county = %@",aresp.country);
    //        NSLog(@"lang = %@",aresp.lang);
    //    }
    
    //微信分享，并且分享成功后点击返回应用，才会调用一下接口
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        if (resp.errCode == WXSuccess) {
            NSLog(@"分享成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendBox" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"inBox" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"productDetail" object:nil];
            
        }else{
            
            //            [SVProgressHUD showErrorWithStatus:@"分享失败"];
            //            [self showError:self.view message:@"分享失败" afterHidden:3];
            
        }
        
        
    }
}

-(void)sendPayInfoToServer{
    
    NSLog(@"确定已经支付。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。");
    
    // 四、通过本地服务器请求，核实是否已经支付成功，如成功，提示支付结果，往外放消息
    NSString *uuid = [[NSUUID UUID] UUIDString];
    //    NSString *strUrl = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *url = @"http://pay.enetic.cn/pay/app/qxt/pay/result";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"out_trade_no"] = orderID;
    
    
    NSLog(@"===========>>>>>>>>>>>=========>>>>>>>>>>>%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = [[responseObject objectForKey:@"code"] intValue];
        NSLog(@"~~~~~~~~~%@",responseObject);
        
        
        
        if (code == 1000) {
            
            NSString *return_code = [responseObject objectForKey:@"return_code"];
            NSString *result_code = [responseObject objectForKey:@"result_code"];
            
            if ([return_code isEqualToString:@"SUCCESS"] && [result_code isEqualToString:@"SUCCESS"]) {
                //查询支付结果
                NSString *trade_state = [responseObject objectForKey:@"trade_state"];
                if ([trade_state isEqualToString:@"SUCCESS"]) {
                    ///支付成功
                    //支付成功
                    payResultMsg = @"成功";
                    //记录充值记录
                    [self keepRechartRecord];
                }else{
                    ///支付失败
                    
                    payResultMsg = @"失败";
                    
                }
                
            }else{
                ///支付失败
                payResultMsg = @"失败";
                
                
            }
            
            
            //这里可以向外面跑消息,给需要得知支付结果后才能处理下一步的控制器
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishPay" object:self userInfo:@{@"payMsg":payResultMsg}];
    
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"服务器请求失败%@",error);
        
        
    }];
}



/** 签名 */
- (NSString *)genSign:(NSDictionary *)signParams {
    
    
    // 排序, 因为微信规定 ---> 参数名ASCII码从小到大排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //生成 ---> 微信规定的签名格式
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    // 拼接API密钥
    NSString *result = [NSString stringWithFormat:@"%@&key=%@", signString, WXAPIKey];
    // 打印检查
    NSLog(@"result = %@", result);
    // md5加密
    NSString *signMD5 = [CommonUtil md5:result];
    // 微信规定签名英文大写
    signMD5 = signMD5.uppercaseString;
    // 打印检查
    NSLog(@"signMD5 = %@", signMD5);
    return signMD5;
}


- (NSString *)genOutTradNo {
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 99999999 + 10000 ] ];
}

-(void)keepRechartRecord {
    NSString *url = [NSString stringWithFormat:@"%@userPaycheck/save",DOMAIN_NAME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [UserModel sharedModel].userId;
    params[@"orderSn"] = orderID;
    params[@"orderStatus"] = @2;
    params[@"amount"] = priceStr;
    params[@"payType"] = @1;
    
    NSLog(@"%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        int code = [[responseObject objectForKey:@"code"] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1000) {
            NSLog(@"记录充值记录成功 == %@", message);
        }
        if (code == 204) {
            NSLog(@"记录充值记录失败 == %@", message);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}



@end
