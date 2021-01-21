//
//  ZFDownloadingCell.h
//  EWoCartoon
//
//  Created by Moguilay on 16/4/25.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>
//#import "ZFDownloadManager.h"

typedef void(^ZFDownloadBlock)(UIButton *);

@interface ZFDownloadingCell : UITableViewCell
+ (NSString *)reuseIdentifier;

@property (strong, nonatomic  )  UIImageView     *fileImageView;
@property (strong, nonatomic  )  UILabel         *fileNameLabel;
@property (strong, nonatomic  )  UIProgressView  *progress;
@property (strong, nonatomic  )  UILabel         *progressLabel;
@property (strong, nonatomic  )  UILabel         *speedLabel;
@property (strong, nonatomic  )  UIButton        *downloadBtn;
@property (strong, nonatomic  )  UILabel         *waitLabel;
@property (nonatomic, copy  ) ZFDownloadBlock downloadBlock;
//@property (nonatomic, strong) ZFSessionModel  *sessionModel;

@end
