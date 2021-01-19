//
//  BaseWebViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/5.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : BaseViewController

@property (copy, nonatomic)   NSString *loadURLString;
@property (strong, nonatomic) WKWebView *webView;

@end
