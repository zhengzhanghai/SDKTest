//
//  PKCCollectionCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PKCCollectionCell.h"

@interface PKCCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation PKCCollectionCell

+ (instancetype)createNibCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    PKCCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)configWithPKG:(PKGProjectModel *)model {
    _titleLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
