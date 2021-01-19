//
//  ZFDownloadingCell.m
//  EWoCartoon
//
//  Created by Moguilay on 16/4/25.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "ZFDownloadingCell.h"
//#import "ZFSessionModel.h"
@interface ZFDownloadingCell ()

@end

@implementation ZFDownloadingCell

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
        s_reuseIdentifier = NSStringFromClass([ZFDownloadingCell class]);
        
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
    self.fileNameLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.fileNameLabel];
    [self.fileNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileImageView.mas_right).offset(10);
        make.top.equalTo(self.fileImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(130,15));
    }];
    
    
    self.progress = [[UIProgressView alloc]init];
    self.progress.progressTintColor = [UIColor colorWithRed:243/255.0 green:79/255.0 blue:133/255.0 alpha:1.0];
    [self.contentView addSubview:self.progress];
    [self.progress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileImageView.mas_right).offset(10);
        make.centerY.equalTo(self.fileImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(
                                         SCREEN_WIDTH - 195,
                                         5
                                         ));
    }];
    
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont systemFontOfSize:12.0f];
    self.progressLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileImageView.mas_right).offset(10);
        make.top.equalTo(self.progress.mas_bottom).offset(10);
//        make.size.mas_equalTo(CGSizeMake(130,15));
    }];
    
    
    self.speedLabel = [[UILabel alloc]init];
    self.speedLabel.font = [UIFont systemFontOfSize:12.0f];
    self.speedLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.speedLabel];
    [self.speedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progress.mas_right);
        make.top.equalTo(self.progress.mas_bottom).offset(30);
    }];
    
    
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.downloadBtn];
    [self.downloadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.downloadBtn addTarget:self action:@selector(clickDownload:) forControlEvents:UIControlEventTouchUpInside];
    [self.downloadBtn setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
    [self.downloadBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [self.downloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(130,15));
    }];
//    
//    self.waitLabel = [[UILabel alloc]init];
//    self.waitLabel.font = [UIFont systemFontOfSize:12.0f];
//    self.waitLabel.textColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:self.waitLabel];
//    self.waitLabel.text = @"正在加载资源";
//    [self.waitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.fileImageView.mas_right).offset(10.0);
//        make.top.equalTo(self.progressLabel.mas_bottom).offset(0.0);
//        make.size.mas_equalTo(CGSizeMake(100,15));
//    }];
//
}
/**
 *  暂停、下载
 *
 *  @param sender UIButton
 */
- (void)clickDownload:(UIButton *)sender {
    sender.selected = !sender.selected;
//    if (sender.selected) {
//        self.sessionModel.downloadState = DownloadStateSuspended;
//    }
//    if (self.downloadBlock) {
//        self.sessionModel.downloadState = DownloadStateStart;
//        self.downloadBlock(sender);
//    }
}

/**
 *  model setter
 *
 *  @param sessionModel sessionModel 
 */
//- (void)setSessionModel:(ZFSessionModel *)sessionModel
//{
//    _sessionModel = sessionModel;
//    
//    
//    [self.fileImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg"] placeholderImage:[UIImage imageNamed:@"占位"]];//sessionModel.vide_ca_icon
//    self.fileNameLabel.text = @"正在下载的视频";//[NSString stringWithFormat:@"%@ %@",sessionModel.video_name,sessionModel.video_ca_name];
//    NSUInteger receivedSize = ZFDownloadLength(sessionModel.url);
//    NSString *writtenSize = [NSString stringWithFormat:@"%.1f %@",
//                                                     [sessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
//                                                     [sessionModel calculateUnit:(unsigned long long)receivedSize]];
//    CGFloat progress = 1.0 * receivedSize / sessionModel.totalLength;
//    self.progressLabel.text = @"1M/3.5M";//[NSString stringWithFormat:@"缓存中:%@/%@ (%.1f%%)",writtenSize,sessionModel.totalSize,progress*100];
//    self.progress.progress = progress;
//    self.speedLabel.text = @"已暂停";
//    
//}


@end
