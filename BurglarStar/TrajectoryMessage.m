//
//  TrajectoryMessage.m
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TrajectoryMessage.h"
#import "NSDate+TPCategory.h"
@implementation TrajectoryMessage
- (NSString*)formatDateText{
    if (_PCTime&&[_PCTime length]>0) {
        NSDate *date=[NSDate dateFromString:_PCTime withFormat:@"yyyy/MM/dd HH:mm:ss"];
        return [date stringWithFormat:@"yyyy/MM/dd HH:mm"];
    }
    return @"";
}
-(CGFloat)getRowHeight:(CGFloat)width showChecked:(BOOL)show{
    CGSize size=[self.PCTime textSize:[UIFont systemFontOfSize:13] withWidth:width-31];
    CGFloat nameH=width-size.width-31-2;
    size=[self.Reason textSize:[UIFont systemFontOfSize:13] withWidth:nameH];
    nameH-=size.width+2;
    nameH-=!show?11:28+8;
    size=[self.PName textSize:[UIFont boldSystemFontOfSize:15] withWidth:nameH];
    CGFloat topY=size.height+9+10;
    CGFloat h1=size.height+9+35+1;
    
    
    CGFloat lefx=show?30:26+30;
    CGFloat w=width-26-5-lefx;
    size=[self.Address textSize:[UIFont systemFontOfSize:12] withWidth:w];
    CGFloat h2=size.height+11+topY;
    
    return h1>h2?h1:h2;
}
@end
