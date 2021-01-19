//
//  WKWebView+HeaderFooter.m
//  shenzhoudc-iPhone
//
//  Created by ZZH on 2020/7/15.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

#import "WKWebView+HeaderFooter.h"

#define kHeaderViewTag 2200
#define kFooterViewTag 2201

@interface WKWebView ()
@property (nonatomic,readonly) UIView * webBrowser;
@end

@implementation WKWebView (HeaderFooter)


-(void)setHeaderView:(UIView *)headerView{
    UIView * _headerView = [self headerView];
    if (_headerView) {
        [_headerView removeFromSuperview];
    }
    
    
    headerView.tag = kHeaderViewTag;
    [headerView setFrame:CGRectMake(0, 0, self.frame.size.width, headerView.frame.size.height)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.scrollView insertSubview:headerView atIndex:0];
    
    
    
    UIView * webBrowser = [self webBrowser];
    if (webBrowser) {
        [webBrowser setFrame:(CGRect){0, headerView.frame.size.height,webBrowser.frame.size}];
    }
}

-(UIView *)headerView{
    return [self.scrollView viewWithTag:kHeaderViewTag];
}

-(void)setFooterView:(UIView *)footerView{
  
   
    
    UIView * _footerView = [self footerView];
    if (_footerView) {
        [_footerView removeFromSuperview];
    }
    

    
    footerView.tag = kFooterViewTag;

    
    [footerView setFrame:CGRectMake(0, self.scrollView.contentSize.height, self.frame.size.width, footerView.frame.size.height)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.scrollView insertSubview:footerView atIndex:0];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    UIEdgeInsets edgeInsets = self.scrollView.contentInset;
    edgeInsets.bottom = footerView.frame.size.height;
    self.scrollView.contentInset = edgeInsets;
    
    
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
}

- (void)removeObserverForWebViewContentSize
{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}




-(UIView *)footerView{
    return [self.scrollView viewWithTag:kFooterViewTag];
}



-(UIView *)webBrowser{
    UIScrollView * scroller = self.scrollView;
    UIView * result;
    for (UIView * view in scroller.subviews) {
        if ([[NSString stringWithUTF8String:object_getClassName(view)] isEqualToString:@"UIWebBrowserView"]) {
            result = view;
            result.backgroundColor = [UIColor whiteColor];
            break;
        }
    }
    
    return result;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    
    NSValue * value = change[@"new"];
    CGSize size;
    [value getValue:&size];
    
    
    UIView * footerView = [self footerView];
    if (footerView) {
        [footerView setFrame:(CGRect){0, size.height, footerView.frame.size}];
        [view removeFromSuperview];
    }
   
}




@end
