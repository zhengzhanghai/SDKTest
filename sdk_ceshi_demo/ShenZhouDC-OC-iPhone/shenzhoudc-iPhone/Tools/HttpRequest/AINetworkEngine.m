//
//  AINetworkEngine.m
//  EWoCartoon
//
//  Created by Crauson on 16/5/1.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "AINetworkEngine.h"
#import "CommonMacro.h"
#import "NetAPI.h"

@implementation AINetworkEngine


+ (AINetworkEngine *)sharedClient {
    static AINetworkEngine *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AINetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:DOMAIN_NAME]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        
    });
    
    return _sharedClient;
}

+ (AINetworkEngine *)sharedJSONClient {
    static AINetworkEngine *sharedJSONClient = nil;
    static dispatch_once_t onceJSONToken;
    dispatch_once(&onceJSONToken, ^{
        sharedJSONClient = [[AINetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:DOMAIN_NAME]];
        sharedJSONClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    });
    return sharedJSONClient;
}

+ (AINetworkEngine *)sharedClientWithoutBaseURL{
    static AINetworkEngine * sharedClientNoBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClientNoBase = [[AINetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return sharedClientNoBase;
}
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [ self setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    // By default, the example ships with SSL pinning enabled for the app.net API pinned against the public key of adn.cer file included with the example. In order to make it easier for developers who are new to AFNetworking, SSL pinning is automatically disabled if the base URL has been changed. This will allow developers to hack around with the example, without getting tripped up by SSL pinning.
    if ([[url scheme] isEqualToString:@"https"]) {
        [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate]];
    } else {
        [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    }
    return self;
}


// 【get】方式请求数据
- (void)getWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block
{
    
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([UserModel sharedModel].token) {
       [self.requestSerializer setValue:[UserModel sharedModel].token forHTTPHeaderField:@"token"];//设置请求头
    }
    if ([UserModel sharedModel].userId) {
        [self.requestSerializer setValue:[UserModel sharedModel].userId forHTTPHeaderField:@"userId"];
    }
    [self GET:api parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL)%@",task.response.URL);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"operation.response.URL)%@",task.response.URL);
        if (block) {
            block(nil, error);
        }

    }];
    
    
    
    
  
    
    

//    [self GET:api parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        CLog(@"operation.response.URL)%@",operation.response.URL);
//        @try {
//            if (block) {  // 将请求下来的数据放到block块中
//                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
//                block(resultptr, nil);
//            }
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//            
//        }
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        CLog(@"operation.response.URL)%@",operation.response.URL);
//        if (block) {
//            block(nil, error);
//        }
//    }];
}
//// 【post】方式请求数据
- (void)postWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block
{
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if ([UserModel sharedModel].token) {
        [self.requestSerializer setValue:[UserModel sharedModel].token forHTTPHeaderField:@"token"];//设置请求头
    }
    [self POST:api parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL)%@",task.response.URL);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"operation.response.URL)%@",task.response.URL);
        NSLog(@"%@",error.userInfo);
        if (block) {
            block(nil, error);
        }
    }];
//    [self POST:api parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        CLog(@"operation.response.URL)%@",operation.response.URL);
//        @try {
//            if (block) {  // 将请求下来的数据放到block块中
//                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
//                block(resultptr, nil);
//            }
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//            
//        }
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        CLog(@"operation.response.URL)%@",operation.response.URL);
//        if (block) {
//            block(nil, error);
//        }
//    }];
}

- (void)postJSONWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block
{
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    if ([UserModel sharedModel].token) {
        [self.requestSerializer setValue:[UserModel sharedModel].token forHTTPHeaderField:@"token"];//设置请求头
    }
    [self POST:api parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL)%@",task.response.URL);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"operation.response.URL)%@",task.response.URL);
        NSLog(@"%@",error.userInfo);
        if (block) {
            block(nil, error);
        }
    }];
}



//-(void)downLoadFile:(NSString *)severPath
//      andOutPutpath:(NSString*)localPath
//    CompletionBlock:(void (^)(NSDictionary *posts, NSError *error))block{
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:severPath]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:localPath append:NO];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        CLog(@"Successfully downloaded file to %@",localPath);
//        if (block) {
//            block ([NSDictionary dictionaryWithObjectsAndKeys:@"200",@"code", nil], nil);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        CLog(@"Error: %@", error);
//        if (block) {
//            block ([NSDictionary dictionary], error);
//        }
//    }];
//    
//    [operation start];
//}

- (void)setRequestHeaderValue:(NSString *)value headerKey:(NSString *)key {
    [self.requestSerializer setValue:value forHTTPHeaderField:key];
}
@end
