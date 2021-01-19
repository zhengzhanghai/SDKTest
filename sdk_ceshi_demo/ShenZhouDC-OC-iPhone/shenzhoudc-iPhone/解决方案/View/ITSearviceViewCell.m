//
//  ITSearviceViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ITSearviceViewCell.h"

@interface ITSearviceViewCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *searviceTimeLabel;
@property (strong, nonatomic) UILabel *technologyLabel;
@end

@implementation ITSearviceViewCell

+ (instancetype)create:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)setSerModel:(ITServiceModel *)serModel {
    _serModel = serModel;
    
    _titleLabel.text = serModel.serviceContent;
    _locationLabel.text = serModel.serviceAddress;
    _searviceTimeLabel.text = [NSString stringWithFormat:@"服务时间：%@", serModel.serviceTime];
    _technologyLabel.text = [NSString stringWithFormat:@"技术方向：%@", [serModel getTechnicalDirectionString]];
    ;
}

- (void)createUI {
    self.contentView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(7);
        make.bottom.mas_equalTo(0);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = UIColorFromRGB(0x1E1E1E);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.numberOfLines = 0;
    [bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
    }];
    
    UIImageView *locationIcon = [[UIImageView alloc] init];
    locationIcon.image = [UIImage imageNamed:@"location"];
    [bgView addSubview:locationIcon];
    [locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.textColor = UIColorFromRGB(0x787878);
    _locationLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_locationLabel];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(locationIcon.mas_right).offset(5);
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(locationIcon.mas_centerY);
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = UIColorFromRGB(0xEBEBEB);
    [bgView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(locationIcon.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    _searviceTimeLabel = [[UILabel alloc] init];
    _searviceTimeLabel.textColor = UIColorFromRGB(0x787878);
    _searviceTimeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:_searviceTimeLabel];
    [_searviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(sepLine.mas_bottom).offset(15);
    }];
    
    _technologyLabel = [[UILabel alloc] init];
    _technologyLabel.textColor = UIColorFromRGB(0x787878);
    _technologyLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:_technologyLabel];
    [_technologyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(_searviceTimeLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-15);
    }];
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
