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
@end
