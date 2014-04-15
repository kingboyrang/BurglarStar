//
//  HotCityView.h
//  LocationService
//
//  Created by aJia on 2014/1/22.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "OnlineBackDelegate.h"
@protocol HotCityViewDelegate <NSObject>
@optional
- (NSArray*)searchOfflineCitys:(NSString*)city;//搜索离线城市
- (void)addOfflineMapDownload:(BMKOLSearchRecord*)entity;//新增一笔地图下载 
@end

@interface HotCityView : UIView
@property (nonatomic,retain) NSArray *hotCitys;//热门城市
@property (nonatomic,retain) NSArray *countryCitys;//全国城市
@property (nonatomic,retain) NSArray *searchResultCitys;//搜索城市
@property (nonatomic,retain) NSArray *localMaps;//本地下载的离线地图
@property (nonatomic,retain) NSArray *downloadMaps;//正在下载的离线地图
@property (nonatomic,assign) id<HotCityViewDelegate> delegate;
@property (nonatomic,assign) id<OnlineBackDelegate> backDelegate;
- (void)reloadDataSource;//重截数据UITableView
@end
