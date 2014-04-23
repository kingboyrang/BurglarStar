//
//  LocationController.m
//  CaseBulletin
//
//  Created by aJia on 2012/10/26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationGPS.h"

@interface LocationGPS()//私有方法
//获取当前位置
-(void) loadCurrentLocation:(CLLocationCoordinate2D)coor2D;
-(void) start;
-(void) stop;
@end

@implementation LocationGPS
+ (LocationGPS *)sharedInstance {
    static dispatch_once_t  onceToken;
    static LocationGPS * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[LocationGPS alloc] init];
    });
    return sSharedInstance;
}
-(void)startLocation:(void(^)())progress completed:(finishLocationBlock)finish failed:(failedLocationBlock)failed{
    if (progress) {
        progress();
    }
    [self startLocation:finish failed:failed];
}
-(void)startLocation:(finishLocationBlock)finish failed:(failedLocationBlock)failed{
    Block_release(_finishlocationBlock);
    Block_release(_failedlocationBlock);
    
    _finishlocationBlock=Block_copy(finish);
    _failedlocationBlock=Block_copy(failed);
    
    [self start];
}
#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
    /***
    if ( abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120) {
        [self stop];//停止定位
        [self loadCurrentLocation:newLocation.coordinate];
    }
     ***/
    [self stop];//停止定位
    [self loadCurrentLocation:newLocation.coordinate];
    //CLLocation *currentLocation = [locations lastObject];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (_failedlocationBlock) {
        _failedlocationBlock(error);
    }
    
    [self stop];//停止定位
}
#pragma mark -
#pragma mark 私有方法
-(void) start {
    [self stop];//先停止
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}
-(void) stop {
    if (locationManager) {
        [locationManager stopUpdatingLocation];
        locationManager.delegate=nil;
        [locationManager release],locationManager=nil;
    }
}
-(void) loadCurrentLocation:(CLLocationCoordinate2D)coor2D{
    
    [SVGeocoder reverseGeocode:coor2D
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        // do something with placemarks, handle errors
                        
                        if ([placemarks count]>0) {
                            SVPlacemark *place=(SVPlacemark*)[placemarks objectAtIndex:0];
                            if (_finishlocationBlock) {
                                _finishlocationBlock(place);
                            }
                        }
                        
                        if (error) {
                            if (_failedlocationBlock) {
                                _failedlocationBlock(error);
                            }
                        }
                       
                        
                    }];

    
}

-(void)dealloc{
    [super dealloc];
    if (locationManager) {
        [locationManager stopUpdatingLocation];
        [locationManager release],locationManager=nil;
    }
    Block_release(_finishlocationBlock);
    Block_release(_failedlocationBlock);
}
@end
