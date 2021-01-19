//
//  KeyProjectBuyerCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectBuyerCell.h"

@interface KeyProjectBuyerCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@end
@implementation KeyProjectBuyerCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *identifer = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifer];
    return [tableView dequeueReusableCellWithIdentifier:identifer];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

- (void)configWithModel:(KeyProjectBuyerModel *)model {
    _titleLabel.text = model.buyerName;
    _timeLabel.text = model.createTime;
}

- (void)configWithTitle:(NSString *)title time:(NSString *)timeStr {
    _titleLabel.text = title;
    _timeLabel.text = timeStr;
}

- (void)makeUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-30);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0xaaaaaa);
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
