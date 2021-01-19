//
//  ZFDownloadedCell.m
//
//  EWoCartoon
//
//  Created by Moguilay on 16/4/25.
//  Copyright © 2016年 Moguilay. All rights reserved.
//
#import "ZFDownloadedCell.h"

@implementation ZFDownloadedCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (NSString *)reuseIdentifier
{
    static NSString* s_reuseIdentifier = nil;
    if (!s_reuseIdentifier)
    {
        s_reuseIdentifier = NSStringFromClass([ZFDownloadedCell class]);
        
    }
    return s_reuseIdentifier;
}
// 初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        [self makeCell];
    }
    return self;
    
}

-(void)makeCell{
 
    self.fileImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.fileImageView];
    [self.fileImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(130,100));
    }];
    
    
    
    self.fileNameLabel = [[UILabel alloc]init];
    self.fileNameLabel.font=  [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.fileNameLabel];
    [self.fileNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileImageView.mas_right).offset(10);
        make.top.equalTo(self.fileImageView.mas_top).offset(10);
//        make.size.mas_equalTo(CGSizeMake(130,15));
    }];
    

    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.sizeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.sizeLabel];
    [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileImageView.mas_right).offset(10);
        make.bottom.equalTo(self.fileImageView.mas_bottom).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(130,15));
    }];
    
    
    
}

//-(void)setSessionModel:(ZFSessionModel *)sessionModel
//{
//    _sessionModel = sessionModel;
//    [self.fileImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg"] placeholderImage:[UIImage imageNamed:@"占位"]];//sessionModel.vide_ca_icon
//    self.fileNameLabel.text = @"下载完成的视频";//[NSString stringWithFormat:@"%@ %@",sessionModel.video_name,sessionModel.video_ca_name];
//    self.sizeLabel.text = @"缓存完成2.1M";//[NSString stringWithFormat:@"缓存完成:%@",sessionModel.totalSize];
//
//}

@end
