//
//  FileResourceModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

typedef NS_ENUM(NSInteger, FileResourceModelType) {
    FileResourceModelTypeImage,
    FileResourceModelTypePDF
};

@interface FileResourceModel : BaseModel
@property (copy, nonatomic)   NSString *filePath;
@property (assign, nonatomic) FileResourceModelType type;
@end
