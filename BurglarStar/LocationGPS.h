//
//  LocationController.h
//  CaseBulletin
//
//  Created by aJia on 2012/10/26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SVGeocoder.h"

typedef void (^finishLocationBlock)(CLPlacemark *place);
typedef void (^failedLocationBlock)(NSError *error);



@interface LocationGPS : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
    
    finishLocationBlock _finishlocationBlock;
    failedLocationBlock _failedlocationBlock;
}
//单一实例
+ (LocationGPS*)sharedInstance;
//开始定位
-(void)startLocation:(finishLocationBlock)finish failed:(failedLocationBlock)failed;
-(void)startLocation:(void(^)())progress completed:(finishLocationBlock)finish failed:(failedLocationBlock)failed;


@end
