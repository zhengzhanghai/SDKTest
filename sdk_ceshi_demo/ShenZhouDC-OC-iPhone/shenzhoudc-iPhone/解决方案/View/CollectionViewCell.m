//
//  CollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()
    @property (weak, nonatomic) IBOutlet UIImageView *icon;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *priceLabel;
    @property (weak, nonatomic) IBOutlet UILabel *priseCountLabel;
    @property (weak, nonatomic) IBOutlet UILabel *chengjiaoCountLabel;
@end

@implementation CollectionViewCell

+ (instancetype)create:(UICollectionView *)coll indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [coll registerNib:nib forCellWithReuseIdentifier:identifier];
    return [coll dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)setModel:(PlanModel *)model {
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    _titleLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue];
    _chengjiaoCountLabel.text = model.orderCount.stringValue;
    _priseCountLabel.text = model.goodsCount.stringValue;
}

- (void)setProductModel:(ChanPinModel *)productModel {
    _productModel = productModel;
    [_icon sd_setImageWithURL:[NSURL URLWithString:productModel.dataIcon] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    _titleLabel.text = productModel.dataTitle;
    _priceLabel.text = productModel.dataCategoryName;
    _chengjiaoCountLabel.text = productModel.dataThumbsUp.stringValue;
    _priseCountLabel.text = productModel.dataThumbsUp.stringValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
