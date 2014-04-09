//
//  SingleMapShowViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "SingleMapShowViewController.h"
#import "TrajectoryPaoView.h"
#import "SupervisionPerson.h"
#import "MeterViewController.h"
@interface SingleMapShowViewController ()
-(void)cleanMap;
@end

@implementation SingleMapShowViewController
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
    self.title=[NSString stringWithFormat:@"%@ %@",self.PersonName,self.Entity.pctime];
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _mapView= [[BMKMapView alloc]initWithFrame:r];
    [self.view addSubview:_mapView];
}
-(void)viewWillDisappear:(BOOL)animated {
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
- (void)selectedMetaWithEntity:(SupervisionPerson*)entity{
    MeterViewController *meter=[[MeterViewController alloc] init];
    meter.Entity=entity;
    [self.navigationController pushViewController:meter animated:YES];
    [meter release];
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
        TrajectoryPaoView *_areaPaoView=[[[TrajectoryPaoView alloc] initWithFrame:CGRectMake(0, 0, 250, 350)] autorelease];
        [_areaPaoView setDataSourceHistory:self.Entity name:self.PersonName];
        _areaPaoView.controls=self;
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:_areaPaoView];
        newAnnotation.paopaoView=paopao;
        [paopao release];

        // 设置可拖拽
        //((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    }
    return newAnnotation;
}
@end
