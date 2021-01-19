//
//  RequirementDetailCollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "RequirementDetailCollectionViewCell.h"
#import "TggStarEvaluationView.h"
@interface RequirementDetailCollectionViewCell ()

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *gradeLabel;
@property (nonatomic,strong) TggStarEvaluationView *gradeImage;

@end


@implementation RequirementDetailCollectionViewCell

+ (instancetype)customCollectionViewCellWithCollectionView:(UICollectionView*)collectionView andIndexPath:(NSIndexPath*)indexPath{
    NSString *reString = NSStringFromClass([self class]);
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:reString];
    return [collectionView dequeueReusableCellWithReuseIdentifier:reString forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUi];
    }
    return  self;
}

- (void)setUpUi{
    __weak typeof(self)weakSelf = self;
    _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"详情页列表默认图"]];
    [self.contentView addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(130);
    }];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"神州数码解决方案[旗舰店]";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(_iconImage.mas_bottom).offset(8);
        
    }];
    _gradeLabel = [[UILabel alloc]init];
    _gradeLabel.text = @"评分";
    _gradeLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1];
    _gradeLabel.font = [UIFont systemFontOfSize:12];
    _gradeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_gradeLabel];
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(_titleLabel.mas_bottom).offset(15);
        
    }];
    
    _gradeImage = [TggStarEvaluationView evaluationViewWithChooseStarBlock:nil];
    _gradeImage.starCount = 3;
    _gradeImage.spacing = 0.2;
    _gradeImage.tapEnabled = NO;
    [self.contentView addSubview:_gradeImage];
    [_gradeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gradeLabel.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(90, 15));
        make.centerY.equalTo(_gradeLabel);
    }];
}

- (void)refreshCell:(NSString *)icon title:(NSString *)title {
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"详情页列表默认图"] options:SDWebImageProgressiveDownload];
    _titleLabel.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
