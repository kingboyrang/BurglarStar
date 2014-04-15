//
//  DownloadMapView.h
//  LocationService
//
//  Created by aJia on 2014/1/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineBackDelegate.h"
#import "TKMapCell.h"
@protocol DownloadMapViewDelegate <NSObject>
@optional
- (void)viewerMapWithCityId:(int)cityId;//查看地图
- (void)pauseDownloadWithCityId:(int)cityId;//地图暂停下载
- (void)removeMapWithCityId:(int)cityId;//删除地图
- (void)downloadMapWithCityId:(int)cityId;//下载地图
- (BOOL)existsLocalMapsWithCityId:(int)cityId;//判断是否为已下载的地图
@end

@interface DownloadMapView : UIView
//@property (nonatomic,strong) NavBarView* navBarView;
@property (nonatomic,retain) NSMutableArray *localMaps;//已下载的地图
@property (nonatomic,retain) NSMutableArray *downloadMaps;//正在下载的地图
@property (nonatomic,assign) int currentDownloadCityId;//当前正在下载的城市id
@property (nonatomic,assign) id<DownloadMapViewDelegate> delegate;
@property (nonatomic,assign) id<OnlineBackDelegate> backDelegate;
- (BOOL)existslocalSourceByCityId:(int)cityId;
- (void)addMapDownloadItem:(BMKOLSearchRecord*)entity;
- (void)updateMapDownloadProcess:(BMKOLUpdateElement*)entity;//更新地图下载进度
- (void)updateCellStatusWithCityId:(int)cityId;//暂停地图下载时，更新状态
//地图下载完成
- (void)finishedDownloadWithRow:(TKMapCell*)cell element:(BMKOLUpdateElement*)updateInfo;
//判断是否所有的地图都暂停
- (BOOL)downloadMapsAllPause;
@end
