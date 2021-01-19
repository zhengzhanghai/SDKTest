//
//  PhotoSelecterCell.h
//  TakeAway
//
//  Created by zyd on 15/10/13.
//  Copyright © 2015年 Moguilay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoSelecterCell;
@protocol PhotoSelecterCellDelegate <NSObject>

- (void)removeButtonClicked:(PhotoSelecterCell *)cell;

@end


@interface PhotoSelecterCell : UICollectionViewCell

//图片
@property(nonatomic,weak) UIImage *image;
@property(nonatomic , copy) NSString *imageUrl;
@property(nonatomic,weak) UIImageView *imageV;
//删除按钮
@property(nonatomic,weak) UIButton *removeBtn;
//代理
@property(nonatomic,weak) id<PhotoSelecterCellDelegate> delegate;

@end
