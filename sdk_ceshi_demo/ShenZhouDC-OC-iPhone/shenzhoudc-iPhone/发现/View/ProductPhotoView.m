//
//  ProductPhotoView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/9/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductPhotoView.h"

@interface ProductPhotoView ()<UIScrollViewDelegate>
@property (assign, nonatomic) BOOL isGes;
@property (assign, nonatomic) CGFloat oldTx;
@end

@implementation ProductPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _oldTx = 1;
        [self makeUI];
    }
    return self;
}

- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (void)makeUI {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.bounces = false;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.showsVerticalScrollIndicator = false;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    _imageView.userInteractionEnabled = true;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView);
        make.height.mas_equalTo(_scrollView);
    }];
    
    _imageView.backgroundColor = [UIColor redColor];
    
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinAction:)];
    [_imageView addGestureRecognizer:pinGes];
}

- (void)pinAction:(UIPinchGestureRecognizer *)pin {
    if (pin.state == UIGestureRecognizerStateBegan) {
        _isGes = true;
    }
    
    CGFloat newTx = _oldTx+pin.velocity/100;
    [self setImageFrameAndScrollSize:newTx];
    
    //     手势结束
    if (pin.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat tx = newTx;
            if (tx < 1) {
                tx = 1;
            }
            if (tx > 2.5) {
                tx = 2.5;
            }
            [self setImageFrameAndScrollSize:tx];
        } completion:^(BOOL finished) {
            _isGes = false;
        }];
    }
}

- (void)setImageFrameAndScrollSize:(CGFloat)tx {
    _imageView.transform = CGAffineTransformMakeScale(tx, tx);
    if (_imageView.frame.size.width < _scrollView.frame.size.width) {
        _imageView.frame = CGRectMake((_scrollView.frame.size.width-_imageView.frame.size.width)/2,
                                      (_scrollView.frame.size.height-_imageView.frame.size.height)/2,
                                      _imageView.frame.size.width,
                                      _imageView.frame.size.height);
    } else {
        _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
    }
    
    _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
    _oldTx = _imageView.frame.size.width/_scrollView.frame.size.width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}



@end
