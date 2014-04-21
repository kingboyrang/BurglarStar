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
        // Initialization code
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
    if (entity.Address&&[entity.Address length]>0) {
        CGSize size=[entity.Address textSize:[UIFont systemFontOfSize:12] withWidth:253];
        if (size.height>15) {
            CGRect r=self.frame;
            r.size.height+=size.height-15;
            self.frame=r;
        }
    }
    CGRect r=self.buttonArrow.frame;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    self.buttonArrow.frame=r;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_labName release];
    [_labLimit release];
    [_labTime release];
    [_labAddress release];
    [_buttonArrow release];
    [super dealloc];
}
- (IBAction)buttonLocationClick:(id)sender {
}

- (IBAction)buttonSkipClick:(id)sender {
}
@end
