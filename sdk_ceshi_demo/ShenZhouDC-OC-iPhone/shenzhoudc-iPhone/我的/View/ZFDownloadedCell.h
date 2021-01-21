//
//  ZFDownloadedCell.h
//  EWoCartoon
//
//  Created by Moguilay on 16/4/25.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ZFPlayer/ZFPlayer.h>
//#import "ZFDownloadManager.h"

@interface ZFDownloadedCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic)  UIImageView *fileImageView;
@property (strong, nonatomic)  UILabel *fileNameLabel;
@property (strong, nonatomic)  UILabel *sizeLabel;
//@property (nonatomic, strong) ZFSessionModel *sessionModel;
@end
