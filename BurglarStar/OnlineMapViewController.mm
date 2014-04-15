//
//  OnlineMapViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/27.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "OnlineMapViewController.h"
#import "UIBarButtonItem+TPCategory.h"
@interface OnlineMapViewController ()
- (void)addRightButton;
- (void)cleanMap;
@end

@implementation OnlineMapViewController
- (void)dealloc {
    [super dealloc];
    
    if (_offlineMap != nil) {
        [_offlineMap release];
        _offlineMap = nil;
    }
  
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }

   
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _offlineMap.delegate = self;
    
   
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _offlineMap.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"离线地图";
    

    [self addRightButton];
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    //预揽地图
    _viewerMap=[[ViewerMapView alloc] initWithFrame:r];
    _viewerMap.delegate=self;
    _mapView = [[BMKMapView alloc] initWithFrame:r];
    [_viewerMap addSubview:_mapView];
    [self.view addSubview:_viewerMap];
    //热门城市
   
    _cityMapView=[[HotCityView alloc] initWithFrame:r];
    _cityMapView.delegate=self;
    _cityMapView.backDelegate=self;
    [self.view addSubview:_cityMapView];

    //下载地图
    _downloadMapView=[[DownloadMapView alloc] initWithFrame:r];
    _downloadMapView.delegate=self;
    _downloadMapView.backDelegate=self;
    [self.view addSubview:_downloadMapView];
    
    //初始化离线地图服务
    _offlineMap = [[BMKOfflineMap alloc] init];
    //获取各城市离线地图更新信息
    _downloadMapView.localMaps=[NSMutableArray arrayWithArray:[_offlineMap getAllUpdateInfo]];
    //获取热门城市
    _cityMapView.hotCitys =[_offlineMap getHotCityList];
    //获取支持离线下载城市列表
    _cityMapView.countryCitys =[_offlineMap getOfflineCityList];
}
-(void)cleanMap
{
    [_mapView removeOverlays:_mapView.overlays];
    //[_mapView removeAnnotations:_mapView.annotations];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
}
//返回操作
- (BOOL)backPrevViewController{
    if ([self.title isEqualToString:@"离线地图"]) {
        return YES;
    }else{
        CATransition* transition = [self getAnimation:3 subtype:0];
        [self.view.layer addAnimation:transition forKey:nil];
        //view之间的切换
        [self.view bringSubviewToFront:_downloadMapView];
        
        self.title=@"离线地图";
        [self addRightButton];
    }
    return NO;
}
//添加
- (void)addRightButton{
    UIBarButtonItem *rightBtn=[UIBarButtonItem barButtonWithTitle:@"添加" target:self action:@selector(buttonAddClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=rightBtn;
}
//添加下载地图事件
- (void)buttonAddClick{
    [self viewToDownloadControl];
    self.navigationItem.rightBarButtonItem=nil;
    self.title=@"添加城市";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark OnlineBackDelegate Methods
//切换view
- (void)viewBackToControl:(id)sender{
    if ([sender isKindOfClass:[DownloadMapView class]]) {//返回
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CATransition* transition = [self getAnimation:3 subtype:0];
        [self.view.layer addAnimation:transition forKey:nil];
        //view之间的切换
        [self.view bringSubviewToFront:_downloadMapView];
    }
}
//切换到热门下载页面
- (void)viewToDownloadControl{
    //提示那些城市正在下载
    _cityMapView.localMaps=[_downloadMapView localMaps];
    _cityMapView.downloadMaps=[_downloadMapView downloadMaps];
    [_cityMapView reloadDataSource];
    
    CATransition* transition = [self getAnimation:2 subtype:2];
    [self.view.layer addAnimation:transition forKey:nil];
    //view之间的切换
    [self.view bringSubviewToFront:_cityMapView];
}
#pragma mark DownloadMapViewDelegate Methods
//查看地图
- (void)viewerMapWithCityId:(int)cityId{
    //删除坐标
    [self cleanMap];
    
    //加载城市地图
    BMKOLUpdateElement* localMapInfo;
    localMapInfo = [_offlineMap getUpdateInfo:cityId];
    [_mapView setCenterCoordinate:localMapInfo.pt];
    
    CATransition* transition = [self getAnimation:2 subtype:2];
    [self.view.layer addAnimation:transition forKey:nil];
    //view之间的切换
    [self.view bringSubviewToFront:_viewerMap];
    
    self.title=@"查看离线地图";
    self.navigationItem.rightBarButtonItem=nil;
}
//地图暂停下载
-(void)pauseDownloadWithCityId:(int)cityId{
    _downloadMapView.currentDownloadCityId=cityId;
    [_offlineMap pause:cityId];
    [_downloadMapView updateCellStatusWithCityId:cityId];//更新暂停状态
    
    //以防万一
    if ([_downloadMapView downloadMapsAllPause]) {
        _downloadMapView.currentDownloadCityId=-1;
    }
    
}
//删除地图
- (void)removeMapWithCityId:(int)cityId{
    [_offlineMap remove:cityId];
}
//下载地图
- (void)downloadMapWithCityId:(int)cityId{
    _downloadMapView.currentDownloadCityId=cityId;
    if ([_downloadMapView existslocalSourceByCityId:cityId]) {//更新地图
        [_offlineMap update:cityId];
    }else{//下载地图
        //NSLog(@"开始下载地图!");
        [_offlineMap start:cityId];
    }
}
//判断是否为已下载的地图
- (BOOL)existsLocalMapsWithCityId:(int)cityId{
    NSMutableArray *arr=_downloadMapView.localMaps;
    if (arr&&[arr count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.cityID ==%d",cityId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [arr filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            return YES;
        }
    }
    return NO;
}
#pragma mark HotCityViewDelegate Methods
//搜索离线城市
- (NSArray*)searchOfflineCitys:(NSString*)city{
    return [_offlineMap searchCity:city];
}
//新增一笔地图下载
- (void)addOfflineMapDownload:(BMKOLSearchRecord*)entity{
    /****切换view显示*****/
    CATransition* transition = [self getAnimation:3 subtype:0];
    [self.view.layer addAnimation:transition forKey:nil];
    //切换到下载页面
    [self.view bringSubviewToFront:_downloadMapView];
    
    self.title=@"离线地图";
    [self addRightButton];
    
    //添加地图下载
    [_downloadMapView addMapDownloadItem:entity];
}
#pragma mark BMKOfflineMapDelegate methods
- (void)onGetOfflineMapState:(int)type withState:(int)state{
    
    //NSLog(@"type=%d state=%d",type,state);
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        //更新显示下载进度条
        [_downloadMapView updateMapDownloadProcess:updateInfo];
       // NSLog(@"下载比例 rate=%d",updateInfo.ratio);
        
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        //更新显示下载进度条
        [_downloadMapView updateMapDownloadProcess:updateInfo];
       // NSLog(@"下载比例 rate=%d",updateInfo.ratio);
    }
}
@end
