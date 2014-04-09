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
        self.labName.font=[UIFont systemFontOfSize:16];
    }else{
        self.labName.font=[UIFont boldSystemFontOfSize:16];
    }
}
- (void)setDataSource:(TrajectoryMessage*)entity{
    self.labName.text=entity.PName;
    self.labLimit.text=entity.Reason;
    self.labTime.text=entity.PCTime;
    self.labAddress.text=entity.Address;
    self.labAddress.numberOfLines=0;
    self.labAddress.lineBreakMode=NSLineBreakByWordWrapping;
    if (entity.Address&&[entity.Address length]>0) {
        CGSize size=[entity.Address textSize:[UIFont systemFontOfSize:16] withWidth:280];
        if (size.height>20) {
            CGRect r=self.frame;
            r.size.height+=size.height-20;
            self.frame=r;
        }
    }
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
    [super dealloc];
}
@end
