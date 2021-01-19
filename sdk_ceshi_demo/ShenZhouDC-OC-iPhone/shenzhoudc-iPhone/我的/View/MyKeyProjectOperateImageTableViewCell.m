//
//  MyKeyProjectOperateImageTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyKeyProjectOperateImageTableViewCell.h"

@interface MyKeyProjectOperateImageTableViewCell()
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIButton *surePayBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation MyKeyProjectOperateImageTableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *identifer = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifer];
    MyKeyProjectOperateImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.indexPath = indexPath;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

- (void)clickSurePay {
    if (_clickBtnBlock) {
        _clickBtnBlock();
    }
}

- (void)configWithTitle:(NSString *)title timeStr:(NSString *)timeStr status:(NSString *)statusStr {
    _titleLabel.text = title;
    _timeLabel.text = timeStr;
    _statusLabel.text = statusStr;
}

- (void)setModel:(MyKeyProjectModel *)model {
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.image]];
    _titleLabel.text = model.name;
    _timeLabel.text = model.createTime;
    _statusLabel.text = [model stasusString];
    if (model.status.integerValue == 6) {
        [_surePayBtn setTitle:@"开工" forState:UIControlStateNormal];
    }
}

- (void)setBuyModel:(MyKeyProjectBuyModel *)buyModel {
    _buyModel = buyModel;
    [_icon sd_setImageWithURL:[NSURL URLWithString:buyModel.image]];
    _titleLabel.text = buyModel.name;
    _timeLabel.text = buyModel.updateTime;
    _statusLabel.text = [buyModel stasusString];
    if (buyModel.status.integerValue == 4) {
        [_surePayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    }
}


- (void)makeUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.surePayBtn];
    
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
    [_surePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
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

- (UIButton *)surePayBtn {
    if (!_surePayBtn) {
        _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _surePayBtn.layer.cornerRadius = 5;
        _surePayBtn.layer.borderColor = MainColor.CGColor;
        _surePayBtn.layer.borderWidth = 0.5;
        _surePayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_surePayBtn setTitle:@"" forState:UIControlStateNormal];
        [_surePayBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [_surePayBtn addTarget:self action:@selector(clickSurePay) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _surePayBtn;
}

@end
