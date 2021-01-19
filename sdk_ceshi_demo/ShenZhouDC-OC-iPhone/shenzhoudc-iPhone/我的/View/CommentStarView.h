//
//  CommentStarView.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^starBlock)(int);

@interface CommentStarView : UIView
@property(nonatomic , copy) starBlock starBlock;

- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star;
@end
