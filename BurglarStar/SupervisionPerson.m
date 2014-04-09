//
//  SupervisionPerson.m
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "SupervisionPerson.h"
#import "NSDate+TPCategory.h"
@implementation SupervisionPerson
-(id)copyWithZone:(NSZone *)zone
{
    SupervisionPerson *copy = [[[self class] allocWithZone: zone] init];
    copy.ID = [self.ID copyWithZone:zone];
    copy.Name = [self.Name copyWithZone:zone];
    copy.isOnline = [self.isOnline copyWithZone:zone];
    copy.GPSStatus = [self.GPSStatus copyWithZone:zone];
    copy.Power = [self.Power copyWithZone:zone];
    copy.Photo = [self.Photo copyWithZone:zone];
    copy.Password = [self.Password copyWithZone:zone];
    copy.IMEI = [self.IMEI copyWithZone:zone];
    copy.DeviceCode = [self.DeviceCode copyWithZone:zone];
    copy.Latitude = [self.Latitude copyWithZone:zone];
    copy.Longitude = [self.Longitude copyWithZone:zone];
    copy.Address = [self.Address copyWithZone:zone];
    copy.angle = [self.angle copyWithZone:zone];
    copy.speed = [self.speed copyWithZone:zone];
    copy.extend = [self.extend copyWithZone:zone];
    copy.oil = [self.oil copyWithZone:zone];
    copy.temper = [self.temper copyWithZone:zone];
    copy.DoorStatus = [self.DoorStatus copyWithZone:zone];
    copy.Phone = [self.Phone copyWithZone:zone];
    copy.OperatingMode = [self.OperatingMode copyWithZone:zone];
    //[newFract setTo:a over:b];
    
    return copy;
}
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
- (NSString*)fileName{
    if (_Photo&&[_Photo length]>0) {
        int pos=[_Photo lastIndexOf:@"/"];
        if (pos!=-1) {
            return [_Photo substringFromIndex:pos+1];
        }
    }
    return @"";
}
- (NSString*)formatDateText{
    if (_PCTime&&[_PCTime length]>0) {
        NSDate *date=[NSDate dateFromString:_PCTime withFormat:@"yyyy/MM/dd HH:mm:ss"];
        return [date stringWithFormat:@"yyyy/MM/dd HH:mm"];
    }
    return @"";
}
@end
