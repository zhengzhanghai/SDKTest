//
//  SuccessCaseCollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "SuccessCaseCollectionViewCell.h"

@interface SuccessCaseCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *pingJiaCount;

@end

@implementation SuccessCaseCollectionViewCell

+ (instancetype)cell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *reString = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reString bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:reString];
    SuccessCaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reString forIndexPath:indexPath];
    return cell;
}

- (void)refreshCell:(JieJueModel *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"详情页列表默认图"] options:SDWebImageProgressiveDownload];
    self.title.text = model.name;
    self.price.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue];
    self.orderCount.text = model.orderCount.stringValue;
    self.pingJiaCount.text = model.goodsCount.stringValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
