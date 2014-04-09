//
//  TKAreaRangeCell.h
//  LocationService
//
//  Created by aJia on 2014/1/6.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVUICalendar.h"
@interface TKAreaRangeCell : UITableViewCell{
@private UILabel *_labLine;
}
@property (nonatomic,strong) CVUICalendar *startField;
@property (nonatomic,strong) CVUICalendar *endField;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,assign) int index;
@property (nonatomic,readonly) NSString *timeSlot;//时间段
@property (nonatomic,readonly) BOOL hasValue;//是否有值
@property (nonatomic,readonly) BOOL hasTimeSlotOut;//判断开始时间是否大于结束时间
@end
