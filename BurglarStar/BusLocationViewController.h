//
//  BusLocationViewController.h
//  BurglarStar
//
//  Created by aJia on 2014/4/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"
#import "SupervisionPerson.h"
#import "BMapKit.h"
@interface BusLocationViewController : BasicViewController<BMKMapViewDelegate>{
    BMKMapView* _mapView;
}
@property (nonatomic,retain) SupervisionPerson *Entity;
@end
