//
//  PaiGongCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/5.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PaiGongCell.h"

@interface PaiGongCell ()
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *serviceTimeLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@end
@implementation PaiGongCell

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[self class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
}

- (void)configWithTitle:(NSString *)title address:(NSString *)address serviceTime:(NSString *)serviceTime technologyType:(NSString *)technologyType {
    _titleLabel.text = title;
    _addressLabel.text = address;
    _serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间:%@", serviceTime];
    _typeLabel.text = [NSString stringWithFormat:@"技术方向:%@", technologyType];;
    
    [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([GlobleFunction computingLabelSizeWith:address andWidth:SCREEN_WIDTH/2 andHeight:30.f andFont:_addressLabel.font].width+5.f);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    self.contentView.backgroundColor = UIColorFromRGB(0xeeeeee);
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(0.f);
        make.bottom.mas_equalTo(-5.f);
    }];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont systemFontOfSize:13.f];
    _addressLabel.textColor = UIColorFromRGB(0x999999);
    [bgView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(10.f);
        make.width.mas_lessThanOrEqualTo(50.f);
    }];
    
    UIImageView *addressIcon = [[UIImageView alloc] init];
    addressIcon.image = [UIImage imageNamed:@"order_address_blue"];
    [bgView addSubview:addressIcon];
    [addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addressLabel.mas_left);
        make.centerY.equalTo(_addressLabel.mas_centerY);
        make.width.mas_equalTo(15.f);
        make.height.mas_equalTo(15.f);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.numberOfLines = 2;
    [bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(_addressLabel.mas_top);
        make.right.equalTo(addressIcon.mas_left).offset(-10.f);
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = UIColorFromRGB(0xeeeeee);
    [bgView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(1.f);
    }];
    
    _serviceTimeLabel = [[UILabel alloc] init];
    _serviceTimeLabel.font = [UIFont systemFontOfSize:14.f];
    _serviceTimeLabel.textColor = UIColorFromRGB(0x666666);
    [bgView addSubview:_serviceTimeLabel];
    [_serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.equalTo(sepLine.mas_bottom).offset(10.f);
    }];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = [UIFont systemFontOfSize:14.f];
    _typeLabel.textColor = UIColorFromRGB(0x666666);
    [bgView addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.equalTo(_serviceTimeLabel.mas_bottom).offset(10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
