//
//  CVUICalendar.h
//  CalendarDemo
//
//  Created by rang on 13-3-11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVUIPopoverView.h"
#import "CVUIPopoverText.h"
@interface CVUICalendar : UIView<CVUIPopoverTextDelegate,CVUIPopoverViewDelegate>

@property(nonatomic,retain) CVUIPopoverText *popoverText;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain,setter = setDateForFormat:) NSDateFormatter *dateForFormat;
@property(nonatomic,retain) CVUIPopoverView *popoverView;
@property(nonatomic,assign) BOOL isClearEmpty;
-(void)setDateForFormat:(NSDateFormatter *)format;
@end
