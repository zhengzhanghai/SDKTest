//
//  MyKeyProjectImageTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyKeyProjectImageTableViewCell.h"

@interface MyKeyProjectImageTableViewCell ()
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@end

@implementation MyKeyProjectImageTableViewCell

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

- (void)configWithTitle:(NSString *)title timeStr:(NSString *)timeStr status:(NSString *)statusStr imageStr:(NSString *)imageStr{
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    _titleLabel.text = title;
    _timeLabel.text = timeStr;
    _statusLabel.text = statusStr;
}

- (void)configWithModel:(MyKeyProjectModel *)model {
    [self configWithTitle:model.name timeStr:model.createTime status:[model stasusString] imageStr:model.image];
}

- (void)configWithBuyModel:(MyKeyProjectBuyModel *)model {
    [self configWithTitle:model.name timeStr:model.updateTime status:[model stasusString] imageStr:model.image];
}

- (void)makeUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.statusLabel];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(78);
        make.bottom.mas_equalTo(-15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.top.mas_equalTo(_icon.mas_top);
        make.right.mas_equalTo(-15);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.bottom.mas_equalTo(_icon.mas_bottom);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _icon;
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

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = MainColor;
        _statusLabel.font = [UIFont systemFontOfSize:13];
    }
    return _statusLabel;
}

@end
