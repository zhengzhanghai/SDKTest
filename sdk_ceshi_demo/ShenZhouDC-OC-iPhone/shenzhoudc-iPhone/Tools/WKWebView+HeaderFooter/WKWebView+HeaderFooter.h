//
//  WKWebView+HeaderFooter.h
//  shenzhoudc-iPhone
//
//  Created by ZZH on 2020/7/15.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (HeaderFooter)

@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIView * footerView;

- (void)removeObserverForWebViewContentSize;


@end

NS_ASSUME_NONNULL_END
