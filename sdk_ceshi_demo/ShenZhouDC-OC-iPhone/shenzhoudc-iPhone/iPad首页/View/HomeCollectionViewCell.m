//
//  HomeCollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *chengjiaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingJiaLabel;

@end

@implementation HomeCollectionViewCell

+ (instancetype)homeCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *reString = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reString bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:reString];
    return [collectionView dequeueReusableCellWithReuseIdentifier:reString forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeSelf];
    }
    return self;
}

- (void)makeSelf {
    
}
- (void)fillTheCellWithModel:(JieJueModel *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.preview] placeholderImage:[UIImage imageNamed:@"详情页列表默认图"]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",model.price];
    self.titleLabel.text = model.name;
    self.sourceLabel.text = model.companyName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue];
    self.chengjiaoLabel.text = model.orderCount.stringValue;
    self.pingJiaLabel.text = model.goodsCount.stringValue;
//    self.originLabel.text = model.companyName;
//    self.unitLabel.text = [NSString stringWithFormat:@"/%@", model.unit];
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
