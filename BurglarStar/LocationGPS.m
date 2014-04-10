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
-(void) loadCurrentLocation:(CLLocation*)location;
-(void) start;
-(void) stop;
@end

@implementation LocationGPS
@synthesize delegate;
+ (LocationGPS *)sharedInstance {
    static dispatch_once_t  onceToken;
    static LocationGPS * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[LocationGPS alloc] init];
    });
    return sSharedInstance;
}
-(id) init {
    if (self = [super init]) {
        if (!locationManager) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        }
        //[self start];
        
    }
    return self;
}
-(void)startLocation:(id<LocationHelperDelegate>)theDelegate{
    self.delegate=theDelegate;
    [self start];
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
    if ( abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120) {
        [self loadCurrentLocation:newLocation];
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(faildLocation:)]) {
        [self.delegate faildLocation:error];
        if (_failedlocationBlock) {
            _failedlocationBlock(error);
        }
    }
    
    [self stop];//停止定位
}
#pragma mark -
#pragma mark 私有方法
-(void) start {
    [locationManager startUpdatingLocation];
}

-(void) stop {
    [locationManager stopUpdatingLocation];
}
-(void) loadCurrentLocation:(CLLocation*)location{
    float lat=location.coordinate.latitude;
    float log=location.coordinate.longitude;
    [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(lat,log)
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        // do something with placemarks, handle errors
                        
                        if ([placemarks count]>0) {
                            SVPlacemark *place=(SVPlacemark*)[placemarks objectAtIndex:0];
                           
                            
                            if (self.delegate&&[self.delegate respondsToSelector:@selector(finishLocation:info:)]) {
                                [self.delegate finishLocation:place];
                            }
                            if (_finishlocationBlock) {
                                _finishlocationBlock(place);
                            }
                        }
                        
                        if (error) {
                            if (self.delegate&&[self.delegate respondsToSelector:@selector(faildLocation:)]) {
                                [self.delegate faildLocation:error];
                            }
                            if (_failedlocationBlock) {
                                _failedlocationBlock(error);
                            }
                        }
                        [self stop];//停止定位
                        
                    }];

    
}

-(void)dealloc{
    [super dealloc];
    [locationManager release];
    Block_release(_finishlocationBlock);
    Block_release(_failedlocationBlock);
}
@end
