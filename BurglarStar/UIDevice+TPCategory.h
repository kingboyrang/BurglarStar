//
//  UIDevice+DeviceHelper.h
//  CommonLibrary
//
//  Created by rang on 13-1-14.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (TPCategory)
/*
 * @method uniqueDeviceIdentifier设备唯一码
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

//系统版本
+(CGFloat)IOSSystemVersion;
//设备方向
+(UIDeviceOrientation)deviceOrientation;
//判断是否为ipad
+(BOOL)isIPad;
/*
 * Available device memory in MB
 */
@property(readonly) double availableMemory;
@property(readonly) BOOL availableDiskSpace;
/**
 Returns `YES` if the device is a simulator.
 
 @return `YES` if the device is a simulator and `NO` if it is not.
 */
- (BOOL)isSimulator;
//是否支持后台多任务
+ (BOOL)hasMultitasking;
@end
