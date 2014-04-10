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

typedef void (^finishLocationBlock)(SVPlacemark *place);
typedef void (^failedLocationBlock)(NSError *error);

@protocol LocationHelperDelegate <NSObject>
@optional
-(void)finishLocation:(SVPlacemark*)marks;
-(void)faildLocation:(NSError*)error;
@end

@interface LocationGPS : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
    
    finishLocationBlock _finishlocationBlock;
    failedLocationBlock _failedlocationBlock;
}
//单一实例
+ (LocationGPS*)sharedInstance;
//开始定位
-(void)startLocation:(id<LocationHelperDelegate>)theDelegate;
-(void)startLocation:(finishLocationBlock)finish failed:(failedLocationBlock)failed;
-(void)startLocation:(void(^)())progress completed:(finishLocationBlock)finish failed:(failedLocationBlock)failed;

@property(nonatomic,assign) id<LocationHelperDelegate> delegate;
@end
