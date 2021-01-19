//
//  ProductCategoryCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductCategoryCell.h"

@interface ProductCategoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ProductCategoryCell

+ (instancetype)createWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    ProductCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configWIthIcon:(NSString *)icon title:(NSString *)title {
    [_icon sd_setImageWithURL:[NSURL URLWithString:icon]];
//    _icon.image = [UIImage imageNamed:@"产品"];
    _titleLabel.text = title;
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
