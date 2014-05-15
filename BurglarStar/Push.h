//
//  Push.h
//  Wisdom
//
//  Created by aJia on 2013/11/4.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Push : NSObject
@property(nonatomic,copy) NSString *Content;//异常内容
@property(nonatomic,copy) NSString *CreateDate;//推送时间
@property(nonatomic,copy) NSString *StartTime;//异常开始时间
@property(nonatomic,copy) NSString *EndTime;//异常结束时间
@property(nonatomic,copy) NSString *Name;//出现异常车牌
@property(nonatomic,copy) NSString *TimeSpan;//异常持续时间

@property(nonatomic,copy) NSString *Message;//界面显示信息
@property (nonatomic,readonly) NSString *formatDateText;//时间

+ (NSArray*)jsonSerializationPushs:(NSString*)jsonStr;
@end
