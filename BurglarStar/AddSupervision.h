//
//  AddSupervision.h
//  LocationService
//
//  Created by aJia on 2013/12/25.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AddSupervision : BasicViewController
@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) int operateType;//1 新增 2:修改
@property (nonatomic,copy) NSString *PersonID;//修改时才赋值
@property (nonatomic,copy) NSString *DeviceCode;//修改时才赋值
@property (nonatomic,copy) NSString *PhoneName;//修改时才赋值
- (void)finishSelectedImage:(UIImage*)image;
- (void)finishUploadFileName:(NSString*)fileName;
@end
