//
//  ChanPinTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinTableViewCell.h"

@interface ChanPinTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *tuchaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianZanLabel;
@property (strong, nonatomic) ChanPinModel *model;
@end

@implementation ChanPinTableViewCell

+ (instancetype)cell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    ChanPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)refresh:(JieJueModel *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    self.title.text = model.name;
    self.category.text = @"未知";
    self.tuchaoLabel.text = model.orderCount.stringValue;
    self.dianZanLabel.text = model.goodsCount.stringValue;
}

- (void)config:(ChanPinModel *)model {
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.dataIcon] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    self.title.text = model.dataTitle;
    self.category.text = model.dataTypeName;
    self.tuchaoLabel.text = model.dataMakeComplaints.stringValue;
    self.dianZanLabel.text = model.dataThumbsUp.stringValue;
}

- (void)refresh:(NSString *)icon title:(NSString *)title category:(NSString *)category orderCount:(NSString *)orderCount comment:(NSString *)comment source:(NSString *)source {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    self.title.text = title;
    if (category != nil && ![category isEqualToString:@""]) {
       self.category.text = @"未知";
    }
    self.tuchaoLabel.text = orderCount;
    self.dianZanLabel.text = comment;
}
- (IBAction)clickTuCao:(id)sender {
    if (_clickZanOrCaiBlock) {
        _clickZanOrCaiBlock(_model.id.stringValue, @"2");
    }
}
- (IBAction)clickDianZan:(id)sender {
    if (_clickZanOrCaiBlock) {
        _clickZanOrCaiBlock(_model.id.stringValue, @"1");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
