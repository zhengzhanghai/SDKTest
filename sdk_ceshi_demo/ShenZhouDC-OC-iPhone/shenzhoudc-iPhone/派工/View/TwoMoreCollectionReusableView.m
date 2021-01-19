//
//  TwoMoreCollectionReusableView.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "TwoMoreCollectionReusableView.h"
#import "Masonry.h"

@interface TwoMoreCollectionReusableView ()

@property (nonatomic,strong) UIImageView *imageV;
@end

@implementation TwoMoreCollectionReusableView
+ (TwoMoreCollectionReusableView*)twoCustomReusableViewWithCollectionView:(UICollectionView*)collctionView andIndexPath:(NSIndexPath*)indexPath{
    NSString *reString = NSStringFromClass([self class]);
    [collctionView registerClass:[self class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reString];
    return [collctionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reString forIndexPath:indexPath];
}



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUi];
    }
    return self;
}
- (void)tapClickEvent:(UIGestureRecognizer*)sender{
    NSLog(@"展开实施地区");
    if (_classBlock) {
        UIView *view = sender.view;
        if (view.tag == 0) {
            _classBlock(YES);
            view.tag = 1000;
            _imageV.image = [UIImage imageNamed:@"icon_up"];
        }else{
            _classBlock(NO);
            view.tag = 0;
            _imageV.image = [UIImage imageNamed:@"icon_down"];

        }
    }

    
}
- (void)setUpUi{
    __weak typeof(self)weakSelf = self;
    UILabel *Xlabel = [[UILabel alloc]init];
    Xlabel.text = @"实时地区";
    Xlabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:Xlabel];
    [Xlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(12);
        make.top.equalTo(weakSelf).offset(25);
    }];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClickEvent:)];
    [view addGestureRecognizer:tap];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(41, 17));
        make.right.equalTo(weakSelf).offset(-18);
        make.top.equalTo(Xlabel);
    }];
    UILabel *Alllabel = [[UILabel alloc]init];
    Alllabel.text = @"全部";
    Alllabel.font = [UIFont systemFontOfSize:12];
    Alllabel.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1];
    [view addSubview:Alllabel];
    [Alllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.top.equalTo(view);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_down"]];
    [view addSubview:imageV];
    _imageV = imageV;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.centerY.equalTo(Alllabel);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
