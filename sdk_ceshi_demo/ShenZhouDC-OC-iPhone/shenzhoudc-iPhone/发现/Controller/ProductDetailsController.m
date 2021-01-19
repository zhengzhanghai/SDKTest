//
//  ProductDetailsController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductDetailsController.h"
#import "ProductDetailsWEBController.h"
#import "ProductDetailsPictureController.h"
#import "ChanPinModel.h"

@interface ProductDetailsController ()
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) ProductDetailsWEBController *WEBController;
@property (strong, nonatomic) ProductDetailsPictureController *pictureController;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *favoriteBtn;
@property (strong, nonatomic) ChanPinModel *productModel;
@end

@implementation ProductDetailsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.segmentedControl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.segmentedControl removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self loadProductDetails];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.WEBController.view];
}

- (void)makeFavoriteBtn {
    _favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _favoriteBtn.frame = CGRectMake(0, 0, 28, 28);
    [_favoriteBtn setImage:[UIImage imageNamed:@"评价-灰"] forState:UIControlStateNormal];
    [_favoriteBtn setImage:[UIImage imageNamed:@"评价-红"] forState:UIControlStateSelected];
    [_favoriteBtn addTarget:self action:@selector(clickFavoriteBtn) forControlEvents:UIControlEventTouchUpInside];
    _favoriteBtn.selected = _productModel.isCollent.boolValue;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_favoriteBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickFavoriteBtn {
    _favoriteBtn.userInteractionEnabled = false;
    if (_productModel.isCollent.boolValue) {
        [self cancelFavorite];
    } else {
        [self favorite];
    }
}

- (void)loadProductDetails {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_GET_PRODUCT_DETAILS_NEW, _productId];
    if ([UserModel isLogin]) {
        [[AINetworkEngine sharedClient] setRequestHeaderValue:[[UserModel sharedModel] userId] headerKey:@"userId"];
    }
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            _productModel = [ChanPinModel modelWithDictionary:result.getDataObj];
            if ([UserModel isLogin]) {
                [self makeFavoriteBtn];
            }
        }
    }];
}

#pragma mark: 收藏接口
- (void)favorite {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[@"goodsid"] = _productId;
    dict[@"userid"] = [[UserModel sharedModel] userId];
    dict[@"goosType"] = @"1";
    [[AINetworkEngine sharedClient] postWithApi:API_POST_FAVORITE parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                self.productModel.isCollent = @1;
                _favoriteBtn.selected = true;
                [self showSuccess:self.view message:@"收藏成功" afterHidden:1.5];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        }
        _favoriteBtn.userInteractionEnabled = true;
    }];
}

#pragma mark: 取消收藏接口
- (void)cancelFavorite {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[@"goodsid"] = _productId;
    dict[@"userid"] = [[UserModel sharedModel] userId];
    dict[@"goosType"] = @"1";
    [[AINetworkEngine sharedClient] postWithApi:API_POST_CANCEL_FAVORITE parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                self.productModel.isCollent = @0;
                _favoriteBtn.selected = false;
                [self showSuccess:self.view message:@"已取消收藏" afterHidden:1.5];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        }
        _favoriteBtn.userInteractionEnabled = true;
    }];
}



- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"产品说明书", @"产品图片"]];
        _segmentedControl.frame = CGRectMake(100, 10, 160, 30);
        _segmentedControl.centerX = SCREEN_WIDTH/2;
        _segmentedControl.tintColor = [UIColor redColor];
        [_segmentedControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

- (void)segmentChange:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
    } else if (segment.selectedSegmentIndex == 1) {
        if (!_pictureController) {
            [_scrollView addSubview:self.pictureController.view];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(_scrollView.width, 0);
        }];
    }
}

- (ProductDetailsWEBController *)WEBController {
    if (!_WEBController) {
        _WEBController = [[ProductDetailsWEBController alloc] init];
        _WEBController.productId = _productId;
        _WEBController.view.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
        [self addChildViewController:_WEBController];
        [_WEBController didMoveToParentViewController:self];
    }
    return _WEBController;
}

- (ProductDetailsPictureController *)pictureController {
    if (!_pictureController) {
        _pictureController = [[ProductDetailsPictureController alloc] init];
        _pictureController.productId = _productId;
        _pictureController.view.frame = CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
        [self addChildViewController:_pictureController];
        [_pictureController didMoveToParentViewController:self];
    }
    return  _pictureController;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(_scrollView.width*2, _scrollView.height);
        _scrollView.pagingEnabled = true;
        _scrollView.scrollEnabled = false;
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
