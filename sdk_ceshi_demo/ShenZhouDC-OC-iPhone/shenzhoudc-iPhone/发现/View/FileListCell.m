//
//  FileListCell.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FileListCell.h"
#import "VideoModel.h"


@interface FileListCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *fileName;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *fileDesp;

@end

@implementation FileListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)FileListCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:reuseIdentifier];
    FileListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
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
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.fileDesp];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.fileName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).offset(6);
        make.height.mas_equalTo(22);
        make.top.mas_equalTo(_icon.mas_top).with.offset(-8);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-13-80-6-10);
    }];
    
    
    [self.fileDesp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_fileName.mas_left);
        make.top.equalTo(_fileName.mas_bottom).offset(8);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-13-80-6-10);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_fileName.mas_left);
        make.bottom.equalTo(_icon.mas_bottom).offset(8);
    
    }];
    
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"购买方案-小缩略图.png" ofType:nil];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        _icon.image = [UIImage imageNamed:@"购买方案-小缩略图"];
//        _icon.layer.cornerRadius = 14;
//        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)fileName {
    if (!_fileName) {
        _fileName = [[UILabel alloc] init];
        _fileName.text = @"this is the file name";
        _fileName.font = [UIFont systemFontOfSize:16];
        _fileName.textColor = UIColorFromRGB(0x051B28);
    }
    return _fileName;
}


- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.text = @"2016-03-28";
        _time.font = [UIFont systemFontOfSize:12];
        _time.textColor = UIColorFromRGB(0x9F9F9F);
    }
    return _time;
}

- (UILabel *)fileDesp {
    if (!_fileDesp) {
        _fileDesp = [[UILabel alloc] init];
        _fileDesp.text = @"file description text is here...";
        _fileDesp.font = [UIFont systemFontOfSize:14];
        _fileDesp.textColor = UIColorFromRGB(0x051B28);
//        _fileDesp.numberOfLines = 0;
    }
    return _fileDesp;
}

- (void)refreshFileListCellWithModel:(VideoModel *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.dataIcon] placeholderImage:[UIImage imageNamed:@""]];
    self.fileDesp.text = model.dataDesc;
    self.fileName.text = model.dataTitle;
    self.time.text = model.dataCreattime;//时间格式需要转换
}


@end
