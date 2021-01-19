//
//  TagView.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagViewDelegate <NSObject>

- (void)getLabelTag:(NSInteger)tag AndIsSelected:(BOOL)isSelected;

@end

@interface TagView : UIView

@property(nonatomic, weak)id<TagViewDelegate>delegate;
@property(nonatomic)UIColor *color;
@property(nonatomic,strong) NSArray *tagsArray;
- (id)initWithFrame:(CGRect)frame AndDataSource:(NSArray *)dataArray;
- (id)initWithDataArray:(NSArray *)array;
- (id)initWithArray:(NSArray *)arr;
@end
