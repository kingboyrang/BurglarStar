//
//  MessageView.m
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _chkButton.hidden=YES;
    }
    return self;
}
- (void)setReading:(BOOL)read{
    if (read) {
        self.labName.font=[UIFont systemFontOfSize:15];
    }else{
        self.labName.font=[UIFont boldSystemFontOfSize:15];
    }
}
- (void)setDataSource:(TrajectoryMessage*)entity indexPathRow:(NSInteger)row{
    if (row%2==0) {
        self.backgroundColor=[UIColor colorFromHexRGB:@"bebeb8"];
    }else{
        self.backgroundColor=[UIColor colorFromHexRGB:@"efeedc"];
    }
    self.labName.textColor=[UIColor colorFromHexRGB:@"252930"];
    self.labLimit.textColor=[UIColor colorFromHexRGB:@"252930"];
    self.labTime.textColor=[UIColor colorFromHexRGB:@"252930"];
    self.labAddress.textColor=[UIColor colorFromHexRGB:@"252930"];
    
    self.labName.text=entity.PName;
    self.labLimit.text=entity.Reason;
    self.labTime.text=entity.PCTime;
    self.labAddress.text=entity.Address;
    self.labAddress.numberOfLines=0;
    self.labAddress.lineBreakMode=NSLineBreakByWordWrapping;
    /***
    if (entity.Address&&[entity.Address length]>0) {
        CGSize size=[entity.Address textSize:[UIFont systemFontOfSize:12] withWidth:254];
        if (size.height>15) {
            CGRect r=self.frame;
            r.size.height+=size.height-15;
            self.frame=r;
        }
    }
    CGRect r=self.buttonArrow.frame;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    self.buttonArrow.frame=r;
     ***/
    [self setNeedsLayout];
    CGFloat h1=_btnLocation.frame.origin.y+_btnLocation.frame.size.height+1;
    CGFloat h2=_labAddress.frame.origin.y+_labAddress.frame.size.height+11;
    CGRect r=self.frame;
    r.size.height=h1>h2?h1:h2;
    self.frame=r;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r=_buttonArrow.frame;
    r.origin.x=self.frame.size.width-r.size.width-5;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    _buttonArrow.frame=r;
    
    CGSize size=[_labTime.text textSize:[UIFont systemFontOfSize:13.0] withWidth:r.origin.x];
    r=_labTime.frame;
    r.size=size;
    r.origin.x=_buttonArrow.frame.origin.x-size.width;
    _labTime.frame=r;
    
    size=[_labLimit.text textSize:[UIFont systemFontOfSize:13.0] withWidth:r.origin.x];
    r=_labLimit.frame;
    r.size=size;
    r.origin.x=_labTime.frame.origin.x-size.width-2;
    _labLimit.frame=r;
    
    CGFloat leftX=3;
    r=_chkButton.frame;
    if (!_chkButton.hidden) {//显示
        r.origin.x=leftX;
        r.origin.y=(self.frame.size.height-r.size.height)/2;
        _chkButton.frame=r;
        leftX+=28;
    }else{//聊藏
        r.origin.x=-30;
        _chkButton.frame=r;
        leftX=0;
    }
    r=_btnLocation.frame;
    r.origin.x=leftX>0?leftX-2:leftX;
    _btnLocation.frame=r;


    r=_labName.frame;
    r.origin.x=_chkButton.hidden?11:leftX+8;
    size=[_labName.text textSize:_labName.font withWidth:_labLimit.frame.origin.x-r.origin.x-2];
    r.size=size;
    _labName.frame=r;
    if (_btnLocation.frame.origin.y<size.height+r.origin.y) {//表示要往下移动
        r=_btnLocation.frame;
        r.origin.y=_labName.frame.size.height+_labName.frame.origin.y;
        _btnLocation.frame=r;
    }
    CGFloat w=_buttonArrow.frame.origin.x-_btnLocation.frame.size.width-_btnLocation.frame.origin.x-5;
    CGFloat topY=_btnLocation.frame.origin.y+10;
    size=[_labAddress.text textSize:[UIFont systemFontOfSize:12] withWidth:w];
    _labAddress.frame=CGRectMake(_chkButton.hidden?30:_btnLocation.frame.origin.x+_btnLocation.frame.size.width-5,topY, size.width, size.height);
}

- (void)dealloc {
    [_labName release];
    [_labLimit release];
    [_labTime release];
    [_labAddress release];
    [_buttonArrow release];
    [_chkButton release];
    [_btnLocation release];
    [super dealloc];
}
@end
