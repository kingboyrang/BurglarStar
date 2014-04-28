//
//  TKMonitorCell.m
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TKMonitorCell.h"

@implementation TKMonitorCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"MonitorView" owner:self options:nil];
    if (arr&&[arr count]>0) {
        _monitorView=[arr objectAtIndex:0];
        [self.contentView addSubview:_monitorView];
    }
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    /***
    UIImage *img2=[UIImage imageNamed:@"chk.png"];
    _chkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _chkButton.frame=CGRectZero;
    [_chkButton setImage:img2 forState:UIControlStateNormal];
    [_chkButton setImage:[UIImage imageNamed:@"chk-chk.png"] forState:UIControlStateSelected];
    _chkButton.hidden=YES;
    [self.contentView addSubview:_chkButton];
     ***/
	return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}
- (void)changeMSelectedState{
    _monitorView.chkButton.selected=NO;
    self.showCheck=NO;
    _monitorView.chkButton.hidden=YES;
    [_monitorView setNeedsLayout];
}
- (void)mSelectedState:(BOOL)state{
    self.showCheck=YES;
    _monitorView.chkButton.selected=state;
    _monitorView.chkButton.hidden=NO;
    [_monitorView setNeedsLayout];
}
/***
- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftX=5;
    if (self.showCheck) {//显示
        _chkButton.hidden=NO;
        _chkButton.frame=CGRectMake(leftX,(self.frame.size.height-26)/2, 26, 26);
        leftX+=26;
    }else{//隐藏
        _chkButton.hidden=YES;
        _chkButton.frame=CGRectZero;
    }
    leftX+=2;
    
    CGRect r=_monitorView.frame;
    r.origin.x=leftX;
    _monitorView.frame=r;
}
 ***/
@end
