//
//  TrajectoryHistory.m
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TrajectoryHistory.h"
#import "NSDate+TPCategory.h"
@implementation TrajectoryHistory
- (NSString*)directionText{
    if (_angle&&[_angle length]>0) {
        CGFloat f=[_angle floatValue];
        if ((f>0&&f<22.5)||(f>337.5&&f<=360)) {
            return @"北";
        }
        if (f>=22.5&&f<67.5) {
            return @"东北";
        }
        if (f>=67.5&&f<112.5) {
            return @"东";
        }
        if (f>=112.5&&f<157.5) {
            return @"东南";
        }
        if (f>=157.5&&f<202.5) {
            return @"南";
        }
        if (f>=202.5&&f<247.5) {
            return @"西南";
        }
        if (f>=247.5&&f<292.5) {
            return @"西";
        }
    }
    return @"西北";
}
- (NSString*)extendText{
    if (_extend&&[_extend length]>0) {
        if ([_extend isEqualToString:@"0"]) {
            return @"停转";
        }
        if ([_extend isEqualToString:@"1"]) {
            return @"正转";
        }
    }
    return @"反转";
}
- (NSString*)formatDateText{
    if (_pctime&&[_pctime length]>0) {
        NSDate *date=[NSDate dateFromString:_pctime withFormat:@"yyyy/MM/dd HH:mm:ss"];
        return [date stringWithFormat:@"yyyy/MM/dd HH:mm"];
    }
    return @"";
}
@end
