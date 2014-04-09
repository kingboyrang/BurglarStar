//
//  SupervisionExtend.h
//  LocationService
//
//  Created by aJia on 2013/12/25.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupervisionExtend : BasicViewController
@property(nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,copy) NSString *PersonId;
@property (nonatomic,copy) NSString *DeviceCode;
@property (nonatomic,copy) NSString *SysID;
@property (nonatomic,assign) int operateType;//1:新增 2:修改
@end
