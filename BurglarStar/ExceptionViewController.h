//
//  ExceptionViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/15.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrajectoryMessage.h"
#import "BMapKit.h"
@interface ExceptionViewController : BasicViewController<BMKMapViewDelegate>{
    BMKMapView* _mapView;
}
@property (nonatomic,retain) TrajectoryMessage *Entity;
//@property (nonatomic,copy) NSString *PersonName;
//- (void)selectedMetaWithEntity:(SupervisionPerson*)entity;//进放仪表画面
@end
