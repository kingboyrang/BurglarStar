//
//  CallTrajectoryViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "SupervisionPerson.h"
#import "CallPhoneView.h"
@interface CallTrajectoryViewController : BasicViewController<BMKMapViewDelegate>{
   BMKMapView* _mapView;
}
@property (nonatomic,retain) SupervisionPerson *Entity;
@property (nonatomic,strong) CallPhoneView *phoneView;
@property (nonatomic,readonly) BOOL canShowCall;
//拨打电话
- (void)callWithPhone:(NSString*)phone;
@end
