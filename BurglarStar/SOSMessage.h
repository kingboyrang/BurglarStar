//
//  SOSMessage.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOSMessage : NSObject
@property (nonatomic,copy) NSString *SOSPKID;//SOS报警的唯一ID
@property (nonatomic,copy) NSString *CompanyName;//用户名称
@property (nonatomic,copy) NSString *carID;//车牌id
@property (nonatomic,copy) NSString *CarNo;//用户车牌名称
@property (nonatomic,copy) NSString *CreateDate;//创建日期
@property (nonatomic,copy) NSString *Image;//图片地址
@property (nonatomic,copy) NSString *Status;//1为未处理，2为已处理

@property (nonatomic,readonly) NSString *formatDateText;//

+ (NSArray*)jsonSerializationSOSMessages:(NSString*)jsonStr;
@end
