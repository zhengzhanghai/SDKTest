//
//  PhotoSelecterCell.m
//  TakeAway
//
//  Created by zyd on 15/10/13.
//  Copyright © 2015年 Moguilay. All rights reserved.
//

#import "PhotoSelecterCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoSelecterCell ()


@property(nonatomic,strong) UIButton *removeButton;
@end

@implementation PhotoSelecterCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //界面搭建
        self.backgroundColor = [UIColor whiteColor];
        [self preparedUI];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageV.image = image;
    
}
-(void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
     [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"加载图"]];
}

- (void)preparedUI{
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageV = imageView;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    //删除按钮
    self.removeButton = [[UIButton alloc] init];
    self.removeButton.hidden = YES;
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPressGr];
    
    [self.removeButton addTarget:self action:@selector(removeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.removeButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [self addSubview:self.removeButton];
    self.removeBtn = self.removeButton;
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    
}

- (void)removeButtonClicked{
    NSLog(@"删除");
    [self.delegate removeButtonClicked:self];
    
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture   {
    self.removeButton.hidden = NO;
}
@end
