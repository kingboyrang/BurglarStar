//
//  ModifyAreaViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/2.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ModifyAreaViewController.h"
#import "LoginButtons.h"
#import "Account.h"
#import "AreaRuleViewController.h"
#import "AreaPaoView.h"
#import "AlertHelper.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
@interface ModifyAreaViewController (){
    UISlider *_silder;
    UILabel* _labDistance;
    AreaPaoView *_areaPaoView;
}
- (void)buttonNextClick:(id)sender;
- (void)buttonFinishedClick:(id)sender;
- (void)changeSilderValue:(id)sender;
-(void)cleanMap;
- (void)addAreaCompleted:(void(^)(NSString* areaId))completed;
- (void)editAreaCompleted:(void(^)(NSString* areaId))completed;
- (void)loadingEditInfo;
- (void)paintCircularWithCoor:(CLLocationCoordinate2D)coor;
@end

@implementation ModifyAreaViewController
- (void)dealloc {
    [super dealloc];
    [_silder release];
    [_labDistance release];
    if (_areaPaoView) {
         [_areaPaoView release];
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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self cleanMap];
    if (self.operateType==1) {
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
    }else{//修改
        [self loadingEditInfo];
    }
}
//返回列表
- (void)buttonListClick{
   [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:2] animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
-(void)cleanMap
{
    [_mapView removeOverlays:_mapView.overlays];
    //[_mapView removeAnnotations:_mapView.annotations];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"电子围栏";
    UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"1/3" target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2=[UIBarButtonItem barButtonWithTitle:@"列表" target:self action:@selector(buttonListClick) forControlEvents:UIControlEventTouchUpInside];
    NSArray *actionButtonItems = [NSArray arrayWithObjects:btn2,btn1, nil];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    CGRect r=self.view.bounds;
    r.size.height-=44+[self topHeight]+73;
    _mapView= [[BMKMapView alloc]initWithFrame:r];
    
    [self.view addSubview:_mapView];
    _mapView.zoomLevel=16;
    
    
    
    CGFloat topY=r.origin.y+r.size.height+5;
    _labDistance=[[UILabel alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width-10*2, 20)];
    _labDistance.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _labDistance.text=@"100米";
    _labDistance.textColor=[UIColor blackColor];
    _labDistance.textAlignment=NSTextAlignmentRight;
    _labDistance.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_labDistance];
    topY+=25;
    _silder=[[UISlider alloc] initWithFrame:CGRectMake(10, topY, self.view.bounds.size.width-10*2, 23)];
    _silder.minimumValue=0.0;
    _silder.maximumValue=100;
    _silder.value=10.0;
    [_silder addTarget:self action:@selector(changeSilderValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_silder];
    
    LoginButtons *buttons=[[LoginButtons alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44)];
    buttons.cancel.frame=CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 44);
    buttons.submit.frame=CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 44);
    [buttons.cancel setTitle:@"下一步" forState:UIControlStateNormal];
    [buttons.cancel addTarget:self action:@selector(buttonNextClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttons.submit setTitle:@"完成" forState:UIControlStateNormal];
    [buttons.submit addTarget:self action:@selector(buttonFinishedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttons];
    [buttons release];
}
//画圆
- (void)paintCircularWithCoor:(CLLocationCoordinate2D)coor{
    
    [_mapView removeOverlays:_mapView.overlays];
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:_silder.value*10];
    [_mapView addOverlay:circle];
}
//修改时加载信息
- (void)loadingEditInfo{
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.AreaId,@"areaID", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"maptype", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetOneAreaLatLng";
    args.soapParams=params;
    //NSLog(@"soap=%@",args.soapMessage);
    [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic!=nil) {
                NSArray *arr=[dic objectForKey:@"AreaLatLngList"];
                if (arr&&[arr count]>0) {//加载信息
                    boo=YES;
                    [self hideLoadingViewAnimated:nil];
                    self.AreaSource=[arr objectAtIndex:0];
                    
                    _coordinate.latitude = [[self.AreaSource objectForKey:@"Lat"] floatValue];
                    _coordinate.longitude = [[self.AreaSource objectForKey:@"Lng"] floatValue];
                    
                    _silder.value=[[self.AreaSource objectForKey:@"CircleRedius"] floatValue]/10;
                    int meter=(int)_silder.value*10;
                    _labDistance.text=[NSString stringWithFormat:@"%d米",meter];
                    
                    BMKPointAnnotation  *pointAnnotation = [[[BMKPointAnnotation alloc] init] autorelease];
                    pointAnnotation.coordinate =_coordinate;
                    pointAnnotation.title = @"当前位置";
                    [_mapView addAnnotation:pointAnnotation];
                    //这样就可以在初始化的时候将 气泡信息弹出(默认将气泡弹出)
                    [_mapView selectAnnotation:pointAnnotation animated:YES];
                    
                    [self paintCircularWithCoor:_coordinate];//画圆
                }
            }
        }
        if(!boo)
        {
            [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
        }

    }];
    [request setFailedBlock:^{
         [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
    }];
    [request startAsynchronous];
    
   
    
}
- (void)editAreaCompleted:(void(^)(NSString* areaId))completed{
    
    if ([_areaPaoView.field.text length]==0) {
        [AlertHelper initWithTitle:@"提示" message:@"请输入名称!"];
        [_areaPaoView.field becomeFirstResponder];
        return;
    }
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:_areaPaoView.field.text,@"AreaName", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.AreaId,@"theGUID", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_silder.value*10],@"CircleRedius", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"Workno", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"UpdateArea";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"正在修改,请稍后..."];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        NSString *status=@"";
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            status=[dic objectForKey:@"Result"];
            if(dic!=nil&&[status isEqualToString:@"Success"])
            {
                boo=YES;
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    if (completed) {
                        completed(self.AreaId);
                    }
                }];
            }
        }
        NSString *errorMsg=@"修改失败!";
        if ([status isEqualToString:@"Exits"]) {
            errorMsg=@"名称已存在!";
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:errorMsg completed:nil];
        }
    }];
    [request setFailedBlock:^{
        [self hideLoadingFailedWithTitle:@"修改失败!" completed:nil];
    }];
    [request startAsynchronous];
}
//发生改变
- (void)changeSilderValue:(id)sender{
    int meter=(int)_silder.value*10;
     _labDistance.text=[NSString stringWithFormat:@"%d米",meter];
    
    if (_coordinate.latitude>0&&_coordinate.longitude>0) {
        [self paintCircularWithCoor:_coordinate];
    }
}
//下一步
- (void)buttonNextClick:(id)sender{
    if (self.operateType==1) {//新增
        [self addAreaCompleted:^(NSString *areaId) {
            /**以防返回操作时，无法使用***/
            self.AreaId=areaId;
            self.operateType=2;
            
            
            AreaRuleViewController *areaRange=[[AreaRuleViewController alloc] init];
            //areaRange.operateType=1;
            areaRange.AreaId=areaId;
            areaRange.AreaName=_areaPaoView.field.text;
            [self.navigationController pushViewController:areaRange animated:YES];
            [areaRange release];
        }];
    }else{//修改
        [self editAreaCompleted:^(NSString *areaId) {
            AreaRuleViewController *areaRange=[[AreaRuleViewController alloc] init];
            //areaRange.operateType=2;
            areaRange.AreaId=areaId;
            areaRange.AreaName=_areaPaoView.field.text;
            [self.navigationController pushViewController:areaRange animated:YES];
            [areaRange release];
        }];
    }
    
}
- (void)addAreaCompleted:(void(^)(NSString* areaId))completed{
    if ([_areaPaoView.field.text length]==0) {
        [AlertHelper initWithTitle:@"提示" message:@"请输入名称!"];
        [_areaPaoView.field becomeFirstResponder];
        return;
    }
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    
    NSString *latlng=[NSString stringWithFormat:@"%f,%f",_coordinate.latitude,_coordinate.longitude];
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:_areaPaoView.field.text,@"AreaName", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"remark", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:latlng,@"LinePointArystr", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_silder.value*10],@"CircleRedius", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rotundity",@"AreaType", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"Workno", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"AddArea";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"正在新增,请稍后..."];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic!=nil&&![[dic objectForKey:@"Result"] isEqualToString:@"Fail"]&&![[dic objectForKey:@"Result"] isEqualToString:@"Error"]) {
                boo=YES;
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    if (completed) {
                        completed([dic objectForKey:@"Result"]);
                    }
                }];
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"新增失败!" completed:nil];
        }
    }];
    [request setFailedBlock:^{
        [self hideLoadingFailedWithTitle:@"新增失败!" completed:nil];
    }];
    [request startAsynchronous];

}
//完成
- (void)buttonFinishedClick:(id)sender{
    if (self.operateType==1) {//新增
        [self addAreaCompleted:^(NSString *areaId) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{//修改
        [self editAreaCompleted:^(NSString *areaId) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark mapViewDelegate 代理方法
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
    if (annotationView == nil)
    {
        NSUInteger tag =123;
        //ann.tag;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationView-%i", tag];
        annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:AnnotationViewID] autorelease];
         // 设置颜色
        ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置该标注点动画显示
		//((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        if (self.operateType==1) {
            // 设置可拖拽
            ((BMKPinAnnotationView*)annotationView).draggable = YES;
        }
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        //自定义气泡
        _areaPaoView=[[AreaPaoView alloc] initWithFrame:CGRectMake(0, 0, 250, 35+13*2)];
        _areaPaoView.tag=456;
        //修改时设置值
        if (self.AreaSource&&[self.AreaSource count]>0&&[self.AreaSource.allKeys containsObject:@"AreaName"]) {
            _areaPaoView.field.text=[self.AreaSource objectForKey:@"AreaName"];
        }
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:_areaPaoView];
        annotationView.paopaoView=paopao;
        [paopao release];
	}
	return annotationView ;
    /***
    NSString *AnnotationViewID = @"renameMark";
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
		((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
		((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        // 设置可拖拽
		((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    }
    return newAnnotation;
     ***/
    
}
- (void)mapView:(BMKMapView *)mapView1 didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    if (_mapView)
    {
        _mapView.region = region;
        //NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
    _mapView.showsUserLocation=NO;
}
//定位失败

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [mapView setShowsUserLocation:NO];
}
//定位停止
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    _coordinate=mapView.centerCoordinate;
    
    BMKPointAnnotation  *pointAnnotation = [[[BMKPointAnnotation alloc] init] autorelease];
    pointAnnotation.coordinate = mapView.centerCoordinate;
    pointAnnotation.title = @"当前位置";
    [_mapView addAnnotation:pointAnnotation];
    //这样就可以在初始化的时候将 气泡信息弹出(默认将气泡弹出)
    [_mapView selectAnnotation:pointAnnotation animated:YES];
    
    [self paintCircularWithCoor:_coordinate];
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
   
    //CGPoint point = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView];
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
       
    }
    else {
        
    }
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}
//拖动annotation view时view的状态变化
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState
{
    if (newState==BMKAnnotationViewDragStateEnding) {
       _coordinate=[view.annotation coordinate];
    }
}
// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[[BMKCircleView alloc] initWithOverlay:overlay] autorelease];
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
        return circleView;
    }
    return nil;
}
@end
