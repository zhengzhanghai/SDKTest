//
//  StarView.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView

+ (instancetype)createToSuperView:(UIView *)superView;
- (void)star:(NSInteger)stars;
@end
