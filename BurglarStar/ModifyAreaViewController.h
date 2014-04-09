//
//  ModifyAreaViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/2.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface ModifyAreaViewController : BasicViewController<BMKMapViewDelegate>{
    BMKMapView* _mapView;
     CLLocationCoordinate2D _coordinate;
}
@property (nonatomic,assign) int operateType;//1 新增 2:修改
@property (nonatomic,copy) NSString *AreaId;//修改时赋值
@property (nonatomic,retain) NSDictionary *AreaSource;//修改时赋值
@end
