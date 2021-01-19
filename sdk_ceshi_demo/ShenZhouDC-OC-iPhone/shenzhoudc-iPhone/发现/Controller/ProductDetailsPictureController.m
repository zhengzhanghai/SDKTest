//
//  ProductDetailsPictureController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductDetailsPictureController.h"
#import "ImageFlexibleView.h"
#import "ProductPictureCollectionCell.h"

@interface ProductDetailsPictureController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (copy, nonatomic)   NSArray *imageURLs;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic)   NSArray *imageViews;
@property (strong, nonatomic) NSMutableDictionary *cachePicture;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation ProductDetailsPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = true;
    _cachePicture = [NSMutableDictionary dictionary];
//    [self makeCollectinoView];
    [self makeScrollView];
    [self loadProductPicture];
}

- (void)makeScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOPBARHEIGHT)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = true;
    _scrollView.bounces = false;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollView];
}

- (void)makeCollectinoView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-TOPBARHEIGHT);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOPBARHEIGHT) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = true;
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

- (void)loadProductPicture {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&type=%@", API_GET_PRODUCT_DETAILS_MESSAGE,_productId, @"2"];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSDictionary *dict = result.getDataObj;
            if ([dict.allKeys containsObject:@"dataImgProduct"]) {
                self.imageURLs = dict[@"dataImgProduct"];
                [self makePicture];
            }
        }
    }];
}

- (void)makePicture {
    if (_imageURLs.count == 0) {
        return;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.width*_imageURLs.count, _scrollView.height);
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *imageViews = [NSMutableArray arrayWithCapacity:_imageURLs.count];
    for (NSUInteger i = 0; i < _imageURLs.count; i++) {
        ImageFlexibleView *flexibleView =  [[ImageFlexibleView alloc] initWithFrame:CGRectMake(_scrollView.width*i, 0, _scrollView.width, _scrollView.height)];
        flexibleView.tag = i;
        flexibleView.backgroundColor = [UIColor blackColor];
        flexibleView.imageView.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:flexibleView];
        __weak ImageFlexibleView *weakFle = flexibleView;
        __weak typeof(self) weakSelf = self;
        flexibleView.imageScrollBlock = ^(ImageScrollToEdge edgeDirection, CGFloat offect) {
            NSInteger index = weakFle.tag;
            [weakSelf imageFleScrollWithIndex:index edgeDirection:edgeDirection offect:offect];
        };
        [imageViews addObject:flexibleView];
        
        UILabel *deLabel = [[UILabel alloc] init];
        deLabel.frame = CGRectMake(0, flexibleView.height-50, 100, 30);
        deLabel.textAlignment = NSTextAlignmentCenter;
        deLabel.centerX = flexibleView.width/2;
        deLabel.text = [NSString stringWithFormat:@"%zd/%zd", i+1, _imageURLs.count];
        deLabel.textColor = [UIColor whiteColor];
        deLabel.backgroundColor = [UIColor clearColor];
        [flexibleView addSubview:deLabel];
        
    }
    _imageViews = imageViews;
    [self loadImageWithIndex:0];
    [_cachePicture setObject:@"picture" forKey:[NSNumber numberWithInteger:0]];
}

- (void)imageFleScrollWithIndex:(NSInteger)index edgeDirection:(ImageScrollToEdge)edgeDirection offect:(CGFloat)offect {
    if (edgeDirection == ImageScrollToEdgeLeft) {
        if (index > 0) {
            _scrollView.contentOffset = CGPointMake(index*_scrollView.width-offect, 0);
            if (![self isExistCacheWithIndex:index-1]) {
                [self cacheWithIndex:index-1];
                [self loadImageWithIndex:index-1];
            }
        }
    } else if (edgeDirection == ImageScrollToEdgeRight) {
        if (index < _imageViews.count-1) {
            _scrollView.contentOffset = CGPointMake(index*_scrollView.width+offect, 0);
            if (![self isExistCacheWithIndex:index+1]) {
                [self cacheWithIndex:index+1];
                [self loadImageWithIndex:index+1];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/scrollView.width);
    if (_imageViews.count > index) {
        if (![self isExistCacheWithIndex:index]) {
            [self cacheWithIndex:index];
            [self loadImageWithIndex:index];
        }
    }
    if (_imageViews.count > index+1) {
        if (![self isExistCacheWithIndex:index+1]) {
            [self cacheWithIndex:index+1];
            [self loadImageWithIndex:index+1];
        }
    }
}

- (BOOL)isExistCacheWithIndex:(NSInteger)index {
    if ([_cachePicture.allKeys containsObject:[NSNumber numberWithInteger:index]]) {
        return true;
    }
    return false;
}

- (void)cacheWithIndex:(NSInteger)index {
    [_cachePicture setObject:@"picture" forKey:[NSNumber numberWithInteger:index]];
}

- (void)loadImageWithIndex:(NSInteger)index {
    ImageFlexibleView *flexibleView = _imageViews[index];
    [flexibleView.imageView sd_setImageWithURL:[NSURL URLWithString:_imageURLs[index]] placeholderImage:[[UIImage alloc] init] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductPictureCollectionCell *cell = [ProductPictureCollectionCell create:collectionView indexPath:indexPath];
    cell.photoView.imageStr = @"http://scimg.jb51.net/allimg/131021/2-131021133044508.jpg";
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
