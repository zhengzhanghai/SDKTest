//
//  SuccessCaseCollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "DetailCaseCollectionViewCell.h"
#import "PaiModel.h"
@interface DetailCaseCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *pingJiaCount;

@end

@implementation DetailCaseCollectionViewCell

+ (instancetype)cell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *reString = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reString bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:reString];
    DetailCaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reString forIndexPath:indexPath];
    return cell;
}

- (void)setModel:(PaiModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"详情页列表默认图"] options:SDWebImageProgressiveDownload];
    self.title.text = model.nickName;
}

- (void)refreshCell {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"购买方案-缩略图"] options:SDWebImageProgressiveDownload];
    self.title.text = @"成功案例";
    self.price.text = @"¥123.00";
    self.orderCount.text = @"100";
    self.pingJiaCount.text = @"200";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
