//
//  TKDynamicPasswordCell.m
//  LocationService
//
//  Created by aJia on 2013/12/17.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TKDynamicPasswordCell.h"
#import "NSString+TPCategory.h"
#import "NSDate+TPCategory.h"
@interface TKDynamicPasswordCell (){
    int second;
}
- (void)timerFireMethod:(NSTimer*)theTimer;
- (void)startTimer;
@end

@implementation TKDynamicPasswordCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
	
	_textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.borderStyle=UITextBorderStyleRoundedRect;
	_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.delegate=self;
    _textField.secureTextEntry=YES;
	[self.contentView addSubview:_textField];
    
    UIImage *leftImage=[UIImage imageNamed:@"buttonBg_01.png"];
    UIEdgeInsets leftInsets = UIEdgeInsetsMake(5,10, 5, 10);
    leftImage=[leftImage resizableImageWithCapInsets:leftInsets resizingMode:UIImageResizingModeStretch];

    _button=[UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame=CGRectMake(0, 0, 80, 35);
    [_button setBackgroundImage:leftImage forState:UIControlStateNormal];
    [_button setTitle:@"免费获取" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font=[UIFont boldSystemFontOfSize:DeviceFontSize];
    [self.contentView addSubview:_button];
    
	return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)hasValue{
    NSString *title=[_textField.text Trim];
    if ([title length]>0) {
        return YES;
    }
    return NO;
}
- (void)resetOrgin{
    second=1;
    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    _textField.text=@"";
    [_textField resignFirstResponder];
    [_button setTitle:@"免费获取" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.enabled=YES;
    _hasVeryFailed=NO;
}
- (void)startTimerWithTime:(NSString*)time process:(void(^)(NSTimeInterval afterInterval))process{
    _hasVeryFailed=NO;
    _button.enabled=NO;
   
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd KK:mm:ss"];
    NSDate *fromdate=[format dateFromString:time];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    _minDate = [fromdate  dateByAddingTimeInterval: frominterval];
    [format release];
    
    _maxDate=[_minDate dateByAddingMinutes:3];
    
    
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd KK:mm:ss"];
    NSString *formatString=[format1 stringFromDate:[NSDate date]];
    
    NSDate *date = [format1 dateFromString:formatString];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    [format1 release];


    NSTimeInterval s1=[_minDate timeIntervalSinceDate:localeDate];
    if (s1>0) {
        if (process) {
            process(s1);
        }
        second=180;
        [self performSelector:@selector(startTimer) withObject:nil afterDelay:s1];
    }else{
        if (process) {
            process(0);
        }
        NSTimeInterval s=[_maxDate timeIntervalSinceDate:localeDate];
        //两个日期之间相隔多少秒
        second=(int)s;
        if (second<=0||second>180) {
            [_button setTitle:@"重新获取" forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _button.enabled=YES;
            _hasVeryFailed=YES;
            if (self.controlers&&[self.controlers respondsToSelector:@selector(dynamicCodeTimeOut)]) {
                [self.controlers performSelector:@selector(dynamicCodeTimeOut) withObject:nil];
            }
            return;
        }
        [self startTimer];
    }
}
- (void)startTimer{
    [_button setTitle:[NSString stringWithFormat:@"%d秒",second] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    second--;
    if (second<=0) {
        [theTimer invalidate];
        [_button setTitle:@"重新获取" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.enabled=YES;
        _hasVeryFailed=YES;
        if (self.controlers&&[self.controlers respondsToSelector:@selector(dynamicCodeTimeOut)]) {
            [self.controlers performSelector:@selector(dynamicCodeTimeOut) withObject:nil];
        }
    }else{
        [_button setTitle:[NSString stringWithFormat:@"%d秒",second] forState:UIControlStateNormal];
        
    }
}
- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect r=CGRectInset(self.contentView.bounds, 10, 4);
    r.size.width=self.frame.size.width-r.origin.x*2-_button.frame.size.width-5;
	_textField.frame =r;
    
    r=_button.frame;
    r.origin.x=_textField.frame.size.width+_textField.frame.origin.x+5;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    _button.frame=r;
}

@end
