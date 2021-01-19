//
//  VideoCell.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *fileName;
@property (nonatomic, strong) UILabel *despLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *watchLabel;

@end

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)VideoCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:reuseIdentifier];
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubView];
    }
    return self;
}

- (void)addSubView {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.fileName];
    [self.contentView addSubview:self.despLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.fileName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).offset(10);
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(self.mas_top).with.offset(12);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-13-80-6-10);
    }];
    [self.despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fileName.mas_left);
//        make.height.mas_equalTo(18);
        make.top.mas_equalTo(_fileName.mas_bottom).offset(5);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-13-80-6-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fileName.mas_left);
        make.height.mas_equalTo(18);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.top.mas_equalTo(_despLabel.mas_bottom).offset(10);
//        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-13-80-6-10);
    }];
    
    
    
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 14;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)fileName {
    if (!_fileName) {
        _fileName = [[UILabel alloc] init];
        _fileName.font = [UIFont systemFontOfSize:16];
        _fileName.textColor = UIColorFromRGB(0x051B28);
    }
    return _fileName;
}

- (UILabel *)despLabel {
    if (!_despLabel) {
        _despLabel = [[UILabel alloc] init];
        _despLabel.font = [UIFont systemFontOfSize:13];
        _despLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _despLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _timeLabel;
}

- (void)refreshFileListCellWithModel:(VideoModel *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.dataIcon] placeholderImage:[UIImage imageNamed:@""]];
    self.fileName.text = model.dataTitle;
    self.despLabel.text = model.dataDesc;
    self.timeLabel.text = model.dataCreattime;
}


@end
