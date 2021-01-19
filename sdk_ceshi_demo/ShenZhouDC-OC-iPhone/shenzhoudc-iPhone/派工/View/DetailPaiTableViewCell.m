//
//  DetailPaiTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "DetailPaiTableViewCell.h"
#import "PaiModel.h"
#import "UIImage+Round.h"
@interface DetailPaiTableViewCell ()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *flagLabel;
@property (nonatomic,strong) UILabel *classLabel;
@property (nonatomic,strong) UILabel *corpLabel;
@property (nonatomic,strong) UILabel *flagTwoLabel;
@property (nonatomic,strong) UILabel *classTwoLabel;
@end

@implementation DetailPaiTableViewCell

+ (DetailPaiTableViewCell*)customCellWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath{
    
    NSString *reString = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:reString];
    return [tableView dequeueReusableCellWithIdentifier:reString forIndexPath:indexPath];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUi];
    }
    return  self;
}

- (void)setModel:(PaiModel *)model{
     _model = model;
//    NSURL *url = [NSURL URLWithString:model.icon];
//    [_iconView sd_setImageWithURL:url];
//    _titleLabel.text = model.name;
//    _classLabel.text = [NSString stringWithFormat:@"行业分类:%zd",model.categoryId];
//    _corpLabel.text = model.provinceId.stringValue;
    
}

- (void)setUpUi{
    _iconView = [[UIImageView alloc]init];
    _iconView.image =  [UIImage getRoundImageWithName:@"1"];
    [self.contentView addSubview:_iconView];
    __weak typeof (self) weakSelf = self;
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(16);
        make.top.equalTo(weakSelf.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"软件定义网络(SDN)SDN技术应用于数据中心网络";
    _titleLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.top.equalTo(weakSelf.contentView).offset(11);
    }];
    _flagLabel = [[UILabel alloc]init];
    _flagLabel.text = @"￥999.00";
    _flagLabel.textColor = [UIColor colorWithRed:214.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1];
    _flagLabel.font = [UIFont systemFontOfSize:14];
//    _flagLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_flagLabel];
    [_flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(1);
    }];
    
    _flagTwoLabel = [[UILabel alloc]init];
    _flagTwoLabel.text = @"/套";
    _flagTwoLabel.textColor = [UIColor colorWithRed:165.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1];
    _flagTwoLabel.font = [UIFont systemFontOfSize:14];
    //    _flagLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_flagTwoLabel];
    [_flagTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_flagLabel.mas_right);
        make.centerY.equalTo(_flagLabel);
    }];
    
    _classLabel = [[UILabel alloc]init];
    _classLabel.text = @"企业";
    _classLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1];
    _classLabel.textAlignment = NSTextAlignmentCenter;
    _classLabel.layer.cornerRadius = 3;
    _classLabel.layer.masksToBounds = YES;
    _classLabel.layer.borderWidth = 1;
    _classLabel.layer.borderColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1].CGColor;
    _classLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:_classLabel];
    [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.bottom.equalTo(_iconView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(36, 13));
    }];
    _classTwoLabel = [[UILabel alloc]init];
    _classTwoLabel.text = @"雇主保障";
    _classTwoLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1];
    _classTwoLabel.textAlignment = NSTextAlignmentCenter;
    _classTwoLabel.layer.cornerRadius = 3;
    _classTwoLabel.layer.masksToBounds = YES;
    _classTwoLabel.layer.borderWidth = 1;
    _classTwoLabel.layer.borderColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1].CGColor;
    _classTwoLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:_classTwoLabel];
    [_classTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_classLabel.mas_right).offset(7);
        make.centerY.equalTo(_classLabel);
        make.size.mas_equalTo(CGSizeMake(36, 13));
    }];
    _corpLabel = [[UILabel alloc]init];
    _corpLabel.text = @"北京|成交10笔";
    _corpLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    _corpLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_corpLabel];
    [_corpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(_classLabel);
    }];
}


@end
