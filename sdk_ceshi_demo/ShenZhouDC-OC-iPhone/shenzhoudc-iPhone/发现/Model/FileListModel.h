//
//  FileListModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface FileListModel : BaseModel

@property(nonatomic, copy) NSString *fileName;
@property(nonatomic, copy) NSString *fileIcon;
@property(nonatomic, copy) NSString *fileDesp;
@property(nonatomic, copy) NSString *time;



@end
