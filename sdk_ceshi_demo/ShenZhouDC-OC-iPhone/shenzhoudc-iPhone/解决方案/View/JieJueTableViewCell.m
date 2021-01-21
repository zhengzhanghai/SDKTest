//
//  JieJueTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueTableViewCell.h"

@interface JieJueTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhanLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation JieJueTableViewCell

+ (JieJueTableViewCell *)jieJueCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    JieJueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)refreshCell:(JieJueModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.preview] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue];
    self.orderLabel.text = model.orderCount.stringValue;
    self.zhanLabel.text = model.goodsCount.stringValue;
    self.originLabel.text = model.companyName;
//    self.unitLabel.text = [NSString stringWithFormat:@"/%@", model.unit];
}

- (void)refreshWithPlan:(PlanModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue];
    self.orderLabel.text = model.orderCount.stringValue;
    self.zhanLabel.text = model.goodsCount.stringValue;
    self.originLabel.text = @"";
    self.unitLabel.text = @"";
}

- (void)refreshWithBuySolution:(SolutionBuyModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", model.price.floatValue];
    self.orderLabel.text = @"";
    self.zhanLabel.text = @"";
    self.originLabel.text = @"";
    self.unitLabel.text = @"";
}

- (void)refreshWithPublishSolution:(SolutionPublishModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    self.nameLabel.text = model.name;
    self.priceLabel.text = @"";
    self.orderLabel.text = @"";
    self.zhanLabel.text = @"";
    self.originLabel.text = @"";
    self.unitLabel.text = @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
