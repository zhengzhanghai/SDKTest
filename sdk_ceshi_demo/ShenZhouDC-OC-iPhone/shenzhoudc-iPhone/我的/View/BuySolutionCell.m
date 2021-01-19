//
//  BuySolutionCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BuySolutionCell.h"

@interface BuySolutionCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation BuySolutionCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *identifier = NSStringFromClass([self class]);
    [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    BuySolutionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (void)setBuyModel:(SolutionBuyModel *)buyModel {
    [_icon sd_setImageWithURL:[NSURL URLWithString:buyModel.coverImg] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    _titleLabel.text = buyModel.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f", buyModel.price.floatValue];
    _timeLabel.text = buyModel.orderTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
