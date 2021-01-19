//
//  keyProjectCommentTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "keyProjectCommentTableViewCell.h"
#import "SZStarView.h"

@interface keyProjectCommentTableViewCell ()
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *starLabelOne;
@property (strong, nonatomic) SZStarView *starOne;
@property (strong, nonatomic) UILabel *starLabelTwo;
@property (strong, nonatomic) SZStarView *starTwo;
@property (strong, nonatomic) UILabel *starLabelThree;
@property (strong, nonatomic) SZStarView *starThree;
@property (strong, nonatomic) UILabel *content;
@end

@implementation keyProjectCommentTableViewCell

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(KeyProjectCommentModel *)model {
    _model = model;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[[UIImage alloc] init]];
    _userName.text = model.userName;
    [_starOne setStarWithIndex:model.expertiseLevel.integerValue];
    [_starTwo setStarWithIndex:model.serverAttitude.integerValue];
    [_starThree setStarWithIndex:model.globalAssessment.integerValue];
    _content.text = model.desc;
}

- (void)createUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.userName];
    [self.contentView addSubview:self.starLabelOne];
    [self.contentView addSubview:self.starLabelTwo];
    [self.contentView addSubview:self.starLabelThree];
    [self.contentView addSubview:self.starOne];
    [self.contentView addSubview:self.starTwo];
    [self.contentView addSubview:self.starThree];
    [self.contentView addSubview:self.content];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(5);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_icon.mas_centerY);
    }];
    [_starLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userName.mas_left);
        make.top.mas_equalTo(_icon.mas_bottom).offset(10);
    }];
    [_starLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userName.mas_left);
        make.top.mas_equalTo(_starLabelOne.mas_bottom).offset(10);
    }];
    [_starLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userName.mas_left);
        make.top.mas_equalTo(_starLabelTwo.mas_bottom).offset(10);
    }];
    [_starOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_starLabelOne.mas_right).offset(5);
        make.centerY.mas_equalTo(_starLabelOne.mas_centerY);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    [_starTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_starLabelTwo.mas_right).offset(5);
        make.centerY.mas_equalTo(_starLabelTwo.mas_centerY);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    [_starThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_starLabelThree.mas_right).offset(5);
        make.centerY.mas_equalTo(_starLabelThree.mas_centerY);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userName.mas_left);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_starLabelThree.mas_bottom).offset(15);
        make.bottom.mas_equalTo(-10);
    }];
    
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 15;
        _icon.clipsToBounds = true;
    }
    return _icon;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = UIColorFromRGB(0x666666);
        _userName.font = [UIFont systemFontOfSize:15];
    }
    return _userName;
}

- (UILabel *)starLabelOne {
    if (!_starLabelOne) {
        _starLabelOne = [[UILabel alloc] init];
        _starLabelOne.textColor = UIColorFromRGB(0x666666);
        _starLabelOne.font = [UIFont systemFontOfSize:15];
        _starLabelOne.text = @"专业水平";
    }
    return _starLabelOne;
}

- (UILabel *)starLabelTwo {
    if (!_starLabelTwo) {
        _starLabelTwo = [[UILabel alloc] init];
        _starLabelTwo.textColor = UIColorFromRGB(0x666666);
        _starLabelTwo.font = [UIFont systemFontOfSize:15];
        _starLabelTwo.text = @"服务态度";
    }
    return _starLabelTwo;
}

- (UILabel *)starLabelThree {
    if (!_starLabelThree) {
        _starLabelThree = [[UILabel alloc] init];
        _starLabelThree.textColor = UIColorFromRGB(0x666666);
        _starLabelThree.font = [UIFont systemFontOfSize:15];
        _starLabelThree.text = @"整体评价";
    }
    return _starLabelThree;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = UIColorFromRGB(0x666666);
        _content.font = [UIFont systemFontOfSize:14];
        _content.numberOfLines = 0;
    }
    return _content;
}

- (SZStarView *)starOne {
    if (!_starOne) {
        _starOne = [[SZStarView alloc] init];
        _starOne.userInteractionEnabled = false;
    }
    return _starOne;
}

- (SZStarView *)starTwo {
    if (!_starTwo) {
        _starTwo = [[SZStarView alloc] init];
        _starTwo.userInteractionEnabled = false;
    }
    return _starTwo;
}

- (SZStarView *)starThree {
    if (!_starThree) {
        _starThree = [[SZStarView alloc] init];
        _starThree.userInteractionEnabled = false;
    }
    return _starThree;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
