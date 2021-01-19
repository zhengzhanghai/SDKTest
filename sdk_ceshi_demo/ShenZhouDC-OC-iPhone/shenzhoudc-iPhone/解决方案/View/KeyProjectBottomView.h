//
//  KeyProjectBottomView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyProjectBottomViewType) {
    KeyProjectBottomViewTypeSimple = 0,
    KeyProjectBottomViewTypeCompletion,
    KeyProjectBottomViewTypeBuy
};

@interface KeyProjectBottomView : UIView

@property (copy, nonatomic)   void(^clickItemBlock)(KeyProjectBottomViewType type);

@end
