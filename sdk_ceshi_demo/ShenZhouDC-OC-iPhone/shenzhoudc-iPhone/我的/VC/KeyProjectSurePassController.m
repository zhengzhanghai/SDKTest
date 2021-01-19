//
//  KeyProjectSurePassController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectSurePassController.h"
#import "KeyProjectSurePassPictureCollectionViewCell.h"
#import "KeyProjectSurePassBottomView.h"
#import "FileResourceModel.h"
#import <WebKit/WebKit.h>
#define BOTTOM_HEIGHT 50

@interface KeyProjectSurePassController ()<UIScrollViewDelegate, WKNavigationDelegate>
@property (copy, nonatomic)   NSArray <FileResourceModel *>*dataSource;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *cacheDict;
@property (strong, nonatomic) NSMutableDictionary *cacheLoadingDict;
@property (strong, nonatomic) UILabel *tagLabel;

@end

@implementation KeyProjectSurePassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"等待确认合同";
    _cacheDict = [NSMutableDictionary dictionary];
    _cacheLoadingDict = [NSMutableDictionary dictionary];
    [self loadAgreement];
}

- (void)sureReceiveOrder {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_KEY_PROJECT_SURE;
    NSDictionary *dict = @{@"userId":[UserModel sharedModel].userId,
                           @"pakId": _id ? _id: @""};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
            if (result.isSucceed) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KeyProjectSurePassFinishNotifation object:nil];
                [self showSuccess:self.view message:result.getMessage afterHidden:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:true];
                });
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)cancelReceiveOrder {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_KEY_PROJECT_CANCEL;
    NSDictionary *dict = @{@"userId":[UserModel sharedModel].userId,
                           @"pakId": _id ? _id: @""};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
            if (result.isSucceed) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KeyProjectSurePassFinishNotifation object:nil];
                [self showSuccess:self.view message:result.getMessage afterHidden:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:true];
                });
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)loadAgreement {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_KEY_PROJECT_AGREEMENT;
    NSDictionary *dict = @{@"userId":[UserModel sharedModel].userId,
                           @"pakId": _id ? _id: @""};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result) {
            if (result.isSucceed) {
                NSArray *list = result.getDataObj;
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
                for (NSUInteger i = 0; i < list.count; i++) {
                    NSString *filePath = list[i];
                    FileResourceModel *model = [[FileResourceModel alloc] init];
                    model.filePath = filePath;
                    if ([filePath rangeOfString:@".pdf"].location != NSNotFound) {
                        model.type = FileResourceModelTypePDF;
                    } else {
                        model.type = FileResourceModelTypeImage;
                    }
                    [array addObject:model];
                }
                _dataSource = array;
                [self makeScrollView];
                [self makeTagLabel];
                [self makeBottomView];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:1.5];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}

- (void)makeScrollView {
    if (_dataSource.count == 0) {
        return ;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_HEIGHT-TOPBARHEIGHT)];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.pagingEnabled = true;
    _scrollView.bounces = false;
    _scrollView.contentSize = CGSizeMake(_dataSource.count*SCREEN_WIDTH, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    [self addWebView:0];
}

- (void)makeTagLabel {
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.frame = CGRectMake((SCREEN_WIDTH-170)/2, SCREEN_HEIGHT-BOTTOM_HEIGHT-60, 170, 50);
    _tagLabel.layer.cornerRadius = 10;
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.font = [UIFont boldSystemFontOfSize:20];
    _tagLabel.numberOfLines = 0;
    _tagLabel.clipsToBounds = true;
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.5];
    [self.view addSubview:_tagLabel];
    [self setTagText:1];
}

- (void)setTagText:(NSUInteger)page {
    NSString *alertText = @"左右滑动可以切换文件";
    NSString *string = [NSString stringWithFormat:@"%zd/%zd\n%@", page, _dataSource.count, alertText];
    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] initWithString:string];
    [muAttStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} range:[string rangeOfString:alertText]];
    _tagLabel.attributedText = muAttStr;
}

- (void)addWebView:(NSUInteger)index {
    NSString *indexStr = [NSString stringWithFormat:@"%zd", index];
    if ([_cacheDict.allKeys containsObject:indexStr]) {
        return ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        FileResourceModel *model = _dataSource[index];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(_scrollView.width*index, 0, _scrollView.width, _scrollView.height)];
        webView.tag = index;
        webView.navigationDelegate = self;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.filePath]]];
        [_scrollView addSubview:webView];
        [_cacheDict setObject:webView forKey:indexStr];
    });
}

- (WKWebView *)webView:(NSUInteger)index {
    NSString *indexStr = [NSString stringWithFormat:@"%zd", index];
    return [_cacheDict objectForKey:indexStr];
}

- (void)addLoadingViewToWebView:(NSUInteger)index {
    MBProgressHUD *loadingView = [MBProgressHUD showHUDAddedTo:[self webView:index] animated:true];
    loadingView.removeFromSuperViewOnHide = true;
    loadingView.label.text = @"";
    
    NSString *indexStr = [NSString stringWithFormat:@"%zd", index];
    [_cacheLoadingDict setObject:loadingView forKey:indexStr];
}

- (void)removeWebLoadingView:(NSUInteger)index {
    NSString *indexStr = [NSString stringWithFormat:@"%zd", index];
    UIView *loadingView = [_cacheLoadingDict valueForKey:indexStr];
    [loadingView removeFromSuperview];
    [_cacheLoadingDict removeObjectForKey:indexStr];
}

- (void)makeBottomView {
    KeyProjectSurePassBottomView *bottomView = [[KeyProjectSurePassBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    bottomView.clickItemBlock = ^(NSInteger index) {
        if (index == 0) {
            [self cancelReceiveOrder];
        } else {
            [self sureReceiveOrder];
        }
        NSLog(@"%zd", index);
    };
    [self.view addSubview:bottomView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger nextIndex = (NSUInteger)ceil(scrollView.contentOffset.x/_scrollView.width);
    [self addWebView:nextIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setTagText:(NSInteger)(roundf(_scrollView.contentOffset.x/_scrollView.width))+1];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self addLoadingViewToWebView:webView.tag];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self removeWebLoadingView:webView.tag];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self removeWebLoadingView:webView.tag];
    [self showError:self.view message:@"加载文件失败" afterHidden:2];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self removeWebLoadingView:webView.tag];
    [self showError:self.view message:@"加载文件失败" afterHidden:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
