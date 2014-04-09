//
//  ShowTrajectoryViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "TrajectorySearch.h"
#import "SupervisionPerson.h"
@interface ShowTrajectoryViewController : BasicViewController<BMKMapViewDelegate>{
   BMKMapView* _mapView;
}
@property(nonatomic,strong) TrajectorySearch *trajectorySearch;
@property (nonatomic,retain) NSArray *list;
@property (nonatomic,retain) SupervisionPerson *Entity;
@property (nonatomic,copy) NSString *startTime;//开始时间
@property (nonatomic,copy) NSString *endTime;//结束时间
- (void)selectedMetaWithEntity:(SupervisionPerson*)entity;//进放仪表画面
- (BOOL)backPrevViewController;
@end
