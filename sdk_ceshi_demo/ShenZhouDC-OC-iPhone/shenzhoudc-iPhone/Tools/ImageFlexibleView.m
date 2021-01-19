//
//  ImageScrollView.m
//  KKKKK
//
//  Created by zzh on 2017/8/7.
//  Copyright © 2017年 nebula. All rights reserved.
//

#import "ImageFlexibleView.h"

@interface ImageFlexibleView()<UIScrollViewDelegate>
@property (assign, nonatomic) BOOL isGes;
@property (assign, nonatomic) CGFloat oldTx;
//@property (assign, nonatomic) CGPoint oldOffect;
@end
@implementation ImageFlexibleView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _oldTx = 1;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.bounces = false;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    _imageView.userInteractionEnabled = true;
    
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinAction:)];
    [_imageView addGestureRecognizer:pinGes];
}

- (void)pinAction:(UIPinchGestureRecognizer *)pin {
    if (pin.state == UIGestureRecognizerStateBegan) {
        _isGes = true;
    }
    
    CGFloat newTx = _oldTx+pin.velocity/100;
    if (newTx > 3.5 || newTx < 0.5) {
        return ;
    }
    NSLog(@" +++++++    %.4f", newTx);
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
    CGFloat ratioX = 0.5;
    CGFloat ratioY = 0.5;
    if (_imageView.width >= _scrollView.width) {
        ratioX = (_scrollView.width/2 + _scrollView.contentOffset.x)/_scrollView.contentSize.width;
        ratioY = (_scrollView.height/2 + _scrollView.contentOffset.y)/_scrollView.contentSize.height;
    }
    
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
    
    if (_imageView.width >= _scrollView.width) {
        CGFloat offectX = ratioX*_scrollView.contentSize.width - _scrollView.width/2;
        CGFloat offectY = ratioY*_scrollView.contentSize.height - _scrollView.height/2;
        _scrollView.contentOffset = CGPointMake(offectX, offectY);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isGes) {
        if (!_imageScrollBlock) {
            return;
        }
        if (_scrollView.contentOffset.x <= 0) {
            _imageScrollBlock(ImageScrollToEdgeLeft, _scrollView.contentOffset.x);
            [_scrollView setContentOffset:scrollView.contentOffset animated:false];
        } else if (_scrollView.contentOffset.x+self.frame.size.width >= _scrollView.contentSize.width) {
            _imageScrollBlock(ImageScrollToEdgeRight, _scrollView.contentOffset.x+self.frame.size.width-_scrollView.contentSize.width);
            [_scrollView setContentOffset:scrollView.contentOffset animated:false];
        } else if (_scrollView.contentOffset.y <= 0) {
            _imageScrollBlock(ImageScrollToEdgeTop, 0);
            [_scrollView setContentOffset:scrollView.contentOffset animated:false];
        } else if (_scrollView.contentOffset.y+self.frame.size.height >= _scrollView.contentSize.height-1) {
            _imageScrollBlock(ImageScrollToEdgeBottom, 0);
            [_scrollView setContentOffset:scrollView.contentOffset animated:false];
        }
    }
}

@end
