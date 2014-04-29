//
//  ExceptionViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/15.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ExceptionViewController.h"
#import "ExceptionPaoView.h"
#import "ASIServiceHTTPRequest.h"
@interface ExceptionViewController ()
- (void)cleanMap;
- (void)readRemove;
@end

@implementation ExceptionViewController
- (void)dealloc {
    [super dealloc];
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
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self cleanMap];
    CLLocationCoordinate2D coor;
    coor.latitude=[self.Entity.Latitude floatValue];
    coor.longitude=[self.Entity.Longitude floatValue];
    
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
    item.coordinate =coor;
    item.title=@"当前位置";
    [_mapView addAnnotation:item];
    [_mapView setCenterCoordinate:coor animated:YES];
    [_mapView selectAnnotation:item animated:YES];
    [item release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=self.Entity.PName;
	CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _mapView= [[BMKMapView alloc]initWithFrame:r];
    [self.view addSubview:_mapView];
    
    if (self.flagRead) {
        //标记已读
        [self readRemove];
    }
}
//标记已读
- (void)readRemove{
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"BatchHandleAlarmData";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"id", nil], nil];
    ASIHTTPRequest *request=[args request];
    [request setCompletionBlock:^{
        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    
    BMKPinAnnotationView *newAnnotation = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
    NSString *AnnotationViewID = @"renameMark";
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorRed;
        // 从天上掉下效果
        //((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        
        newAnnotation.centerOffset = CGPointMake(0, -(newAnnotation.frame.size.height * 0.5));
        newAnnotation.annotation = annotation;
        
        //自定义气泡
        ExceptionPaoView *_areaPaoView=[[[ExceptionPaoView alloc] initWithFrame:CGRectMake(0, 0, 250, 350)] autorelease];
        [_areaPaoView setDataSource:self.Entity];
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:_areaPaoView];
        newAnnotation.paopaoView=paopao;
        [paopao release];
        
        // 设置可拖拽
        //((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    }
    return newAnnotation;
}

@end
