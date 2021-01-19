//
//  HomeBottomView.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HomeRefreshBlock)();
typedef void (^ProfileBlock)();

@interface HomeBottomView : UIView
@property (copy,   nonatomic) HomeRefreshBlock refreshBlock;
@property (copy,   nonatomic) ProfileBlock profileBlock;
@end
