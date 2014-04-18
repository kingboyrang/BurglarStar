//
//  TrajectorySearch.m
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TrajectorySearch.h"
#import "NSDate+TPCategory.h"
#import "AlertHelper.h"
#import <QuartzCore/QuartzCore.h>
@interface TrajectorySearch (){
    CGFloat leftX;
   
}

@end

@implementation TrajectorySearch
- (void)dealloc{
    [super dealloc];
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *img=[UIImage imageNamed:@"search_bg.png"];
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width, img.size.height)];
        [imgView setImage:img];
        [self addSubview:imgView];
        [imgView release];
        //self.backgroundColor=[UIColor colorFromHexRGB:@"e5e1e1"];
        
        NSString *title=@"时间";
        CGSize size=[title textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:frame.size.width];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5, (frame.size.height-size.height)/2,size.width, size.height)];
        label.text=title;
        label.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor blackColor];
        label.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
        leftX=label.frame.origin.x+size.width+5;
        [self addSubview:label];
        [label release];
        
        NSDate *time=[NSDate date];
        
        _startCalendar = [[CVUICalendar alloc] initWithFrame:CGRectZero];
        _startCalendar.popoverText.popoverTextField.layer.borderWidth=2.0;
        _startCalendar.popoverText.popoverTextField.layer.cornerRadius=5.0;
        _startCalendar.popoverText.popoverTextField.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
        _startCalendar.popoverText.popoverTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _startCalendar.popoverText.popoverTextField.borderStyle=UITextBorderStyleRoundedRect;
        _startCalendar.popoverText.popoverTextField.backgroundColor = [UIColor whiteColor];
        _startCalendar.popoverText.popoverTextField.font = [UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        _startCalendar.popoverText.popoverTextField.placeholder=@"开始时间";
        _startCalendar.datePicker.datePickerMode=UIDatePickerModeDateAndTime;
        [_startCalendar.dateForFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
        //_startCalendar.datePicker.maximumDate=[NSDate date];
        _startCalendar.popoverText.popoverTextField.text=[[time dateByAddingMinutes:-60] stringWithFormat:@"yyyy/MM/dd HH:mm"];
        [self addSubview:_startCalendar];
        
        
        _endCalendar = [[CVUICalendar alloc] initWithFrame:CGRectZero];
        _endCalendar.popoverText.popoverTextField.layer.borderWidth=2.0;
        _endCalendar.popoverText.popoverTextField.layer.cornerRadius=5.0;
        _endCalendar.popoverText.popoverTextField.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
        _endCalendar.popoverText.popoverTextField.borderStyle=UITextBorderStyleRoundedRect;
        _endCalendar.popoverText.popoverTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _endCalendar.popoverText.popoverTextField.backgroundColor = [UIColor whiteColor];
        _endCalendar.popoverText.popoverTextField.font = [UIFont fontWithName:DeviceFontName size:DeviceFontSize];
         _endCalendar.popoverText.popoverTextField.placeholder=@"结束时间";
        _endCalendar.datePicker.datePickerMode=UIDatePickerModeDateAndTime;
        //_endCalendar.datePicker.maximumDate=[NSDate date];
        [_endCalendar.dateForFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
        _endCalendar.popoverText.popoverTextField.text=[time stringWithFormat:@"yyyy/MM/dd HH:mm"];
        [self addSubview:_endCalendar];
        

        /**
        UIImage *leftImage=[UIImage imageNamed:@"btn_round_bg.png"];
        leftImage=[leftImage stretchableImageWithLeftCapWidth:10 topCapHeight:16];
       **/
        UIImage *leftImage=[UIImage imageNamed:@"buttonBg_01.png"];
        UIEdgeInsets leftInsets = UIEdgeInsetsMake(5,10, 5, 10);
        leftImage=[leftImage resizableImageWithCapInsets:leftInsets resizingMode:UIImageResizingModeStretch];
        
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(frame.size.width-75, (frame.size.height-35)/2, 70, 35);
        [_button setBackgroundImage:leftImage forState:UIControlStateNormal];
        [_button setTitle:@"搜索" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont boldSystemFontOfSize:DeviceFontSize];
        [self addSubview:_button];
        
        
    }
    return self;
}
- (BOOL)compareToDate{
    //两个时间的比较
    if ([_startCalendar.popoverText.popoverTextField.text length]>0&&[_endCalendar.popoverText.popoverTextField.text length]>0) {
        //NSDate *dateA=_startCalendar.datePicker.date;
        // NSDate *dateB=_endCalendar.datePicker.date;
        NSDate *dateA=[NSDate dateFromString:_startCalendar.popoverText.popoverTextField.text withFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *dateB=[NSDate dateFromString:_endCalendar.popoverText.popoverTextField.text withFormat:@"yyyy/MM/dd HH:mm"];
        NSComparisonResult result = [dateA compare:dateB];
        if (result == NSOrderedDescending)
        {
            [AlertHelper initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@不能大于%@!",_startCalendar.popoverText.popoverTextField.placeholder,_endCalendar.popoverText.popoverTextField.placeholder]];
            return NO;
        }
    }
    return YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat total=_button.frame.origin.x-leftX-5;
    _startCalendar.frame=CGRectMake(leftX, (self.frame.size.height-35-5-35)/2, total, 35);
   
    
   CGRect r=_startCalendar.frame;
    r.origin.y+=r.size.height+5;
    _endCalendar.frame=r;
}
@end
