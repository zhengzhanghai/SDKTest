//
//  ProductCollectionCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/9/8.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductCollectionCell.h"

@implementation ProductCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}

- (void)clickPriseBtn {
    _priseBtn.userInteractionEnabled = false;
    if (_clickItemBlock) {
        _clickItemBlock(1, _indexPath);
    }
}

- (void)clickBadBtn {
    _badBtn.userInteractionEnabled = false;
    if (_clickItemBlock) {
        _clickItemBlock(0, _indexPath);
    }
}

- (void)setProductModel:(ChanPinModel *)productModel {
    _productModel = productModel;
    [_icon sd_setImageWithURL:[NSURL URLWithString:productModel.dataIcon] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    _titleLabel.text = productModel.dataTitle;
    _categrayLabel.text = productModel.dataCategoryName;
    _badLabel.text = productModel.dataMakeComplaints.stringValue;
    _priseLabel.text = productModel.dataThumbsUp.stringValue;
    _priseBtn.userInteractionEnabled = true;
    _badBtn.userInteractionEnabled = true;
}

+ (instancetype)create:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:identifier];
    ProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (void)makeUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.categrayLabel];
    [self.contentView addSubview:self.priseBtn];
    [self.priseBtn addSubview:self.priseIcon];
    [self.priseBtn addSubview:self.priseLabel];
    [self.contentView addSubview:self.badBtn];
    [self.badBtn addSubview:self.badIcon];
    [self.badBtn addSubview:self.badLabel];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(_icon.mas_width).multipliedBy(126.0/166.0);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_icon.mas_bottom).offset(10);
    }];
    [_priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [_priseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    [_priseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_priseIcon.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [_badBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_priseBtn.mas_left).offset(-10);
        make.centerY.mas_equalTo(_priseBtn.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    [_badIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    [_badLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_badIcon.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [_categrayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_badBtn.mas_left).offset(-10);
        make.centerY.mas_equalTo(_priseBtn.mas_centerY);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0x1e1e1e);
    }
    return _titleLabel;
}

- (UILabel *)categrayLabel {
    if (!_categrayLabel) {
        _categrayLabel = [[UILabel alloc] init];
        _categrayLabel.font = [UIFont systemFontOfSize:12];
        _categrayLabel.textColor = UIColorFromRGB(0xaaaaaa);
    }
    return _categrayLabel;
}

- (UIButton *)priseBtn {
    if (!_priseBtn) {
        _priseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priseBtn addTarget:self action:@selector(clickPriseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priseBtn;
}

- (UIImageView *)priseIcon {
    if (!_priseIcon) {
        _priseIcon = [[UIImageView alloc] init];
        _priseIcon.image = [UIImage imageNamed:@"prise_ed"];
    }
    return _priseIcon;
}

- (UILabel *)priseLabel {
    if (!_priseLabel) {
        _priseLabel = [[UILabel alloc] init];
        _priseLabel.font = [UIFont systemFontOfSize:12];
        _priseLabel.textColor = UIColorFromRGB(0x3d3d3d);
    }
    return _priseLabel;
}

- (UIButton *)badBtn {
    if (!_badBtn) {
        _badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_badBtn addTarget:self action:@selector(clickBadBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _badBtn;
}

- (UIImageView *)badIcon {
    if (!_badIcon) {
        _badIcon = [[UIImageView alloc] init];
        _badIcon.image = [UIImage imageNamed:@"bad_ed"];
    }
    return _badIcon;
}

- (UILabel *)badLabel {
    if (!_badLabel) {
        _badLabel = [[UILabel alloc] init];
        _badLabel.font = [UIFont systemFontOfSize:12];
        _badLabel.textColor = UIColorFromRGB(0x3d3d3d);
    }
    return _badLabel;
}
@end
