//
//  MyKeyProjectSurePayTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyKeyProjectSurePayTableViewCell.h"

@interface MyKeyProjectSurePayTableViewCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIButton *surePayBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
@implementation MyKeyProjectSurePayTableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *identifer = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifer];
    MyKeyProjectSurePayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.indexPath = indexPath;
    return cell;
}

- (void)setBuyModel:(MyKeyProjectBuyModel *)buyModel {
    _buyModel = buyModel;
    _titleLabel.text = buyModel.name;
    _timeLabel.text = buyModel.updateTime;
    _statusLabel.text = [buyModel stasusString];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

- (void)clickSurePay {
    if (_clickSurePayBlock) {
        _clickSurePayBlock(_indexPath, _buyModel);
    }
}

- (void)configWithTitle:(NSString *)title timeStr:(NSString *)timeStr status:(NSString *)statusStr{
    _titleLabel.text = title;
    _timeLabel.text = timeStr;
    _statusLabel.text = statusStr;
}


- (void)configWithBuyModel:(MyKeyProjectBuyModel *)model {
    [self configWithTitle:model.name timeStr:model.updateTime status:[model stasusString]];
}

- (void)makeUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.surePayBtn];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.width.mas_lessThanOrEqualTo((SCREEN_WIDTH-30)*0.4-7);
        
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_lessThanOrEqualTo((SCREEN_WIDTH-30)*0.6-7);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    [_surePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-10);
    }];
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
        _statusLabel.textColor = UIColorFromRGB(0xaaaaaa);
        _statusLabel.font = [UIFont systemFontOfSize:13];
    }
    return _statusLabel;
}

- (UIButton *)surePayBtn {
    if (!_surePayBtn) {
        _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _surePayBtn.layer.cornerRadius = 5;
        _surePayBtn.layer.borderColor = UIColorFromRGB(0x0000ee).CGColor;
        _surePayBtn.layer.borderWidth = 0.5;
        [_surePayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_surePayBtn setTitleColor:UIColorFromRGB(0x0000ee) forState:UIControlStateNormal];
        [_surePayBtn addTarget:self action:@selector(clickSurePay) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _surePayBtn;
}

@end
