//
//  OnlineMapViewController.h
//  LocationService
//
//  Created by aJia on 2013/12/27.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "HotCityView.h"
#import "ViewerMapView.h"
#import "DownloadMapView.h"
#import "OnlineBackDelegate.h"
#import "TKMapCell.h"
@interface OnlineMapViewController : BasicViewController<BMKOfflineMapDelegate,BMKMapViewDelegate,OnlineBackDelegate,HotCityViewDelegate,DownloadMapViewDelegate>{
   BMKOfflineMap* _offlineMap;
   BMKMapView* _mapView;
}
@property (nonatomic,strong) ViewerMapView *viewerMap;
@property (nonatomic,strong) HotCityView *cityMapView;
@property (nonatomic,strong) DownloadMapView *downloadMapView;

@end
