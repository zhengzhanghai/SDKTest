//
//  ImageScrollView.h
//  KKKKK
//
//  Created by zzh on 2017/8/7.
//  Copyright © 2017年 nebula. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageScrollToEdge) {
    ImageScrollToEdgeTop,
    ImageScrollToEdgeBottom,
    ImageScrollToEdgeLeft,
    ImageScrollToEdgeRight
};

@interface ImageFlexibleView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (copy, nonatomic)   void(^imageScrollBlock)(ImageScrollToEdge edgeDirection, CGFloat offext);

@end
