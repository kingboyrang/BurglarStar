//
//  BusLocationViewController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BusLocationViewController.h"
#import "TrajectoryPaoView.h"
#import "ASIServiceHTTPRequest.h"
@interface BusLocationViewController ()
- (void)cleanMap;
- (void)showPointAnnotation;
- (void)loadDataSource;
@end

@implementation BusLocationViewController
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
    
    [self loadDataSource];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.Entity&&self.Entity.Name&&[self.Entity.Name length]>0) {
        self.title=self.Entity.Name;
    }
    
	CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _mapView= [[BMKMapView alloc]initWithFrame:r];
    [self.view addSubview:_mapView];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
}
- (void)showPointAnnotation{
    if (self.Entity.Latitude&&[self.Entity.Latitude length]>0&&self.Entity.Longitude&&[self.Entity.Longitude length]>0) {
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
}
-(void)cleanMap
{
    [_mapView removeOverlays:_mapView.overlays];
    //[_mapView removeAnnotations:_mapView.annotations];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
}
//重新获取最新信息
- (void)loadDataSource{
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetSingleDetail";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"id", nil], nil];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            NSArray *arr=[dic objectForKey:@"Person"];
            if (arr&&[arr count]>0) {
                NSDictionary *item=[arr objectAtIndex:0];
                self.Entity.Name=[item objectForKey:@"Name"];
                self.Entity.PCTime=[item objectForKey:@"PCTime"];
                self.Entity.Address=[item objectForKey:@"Address"];
                self.Entity.speed=[item objectForKey:@"speed"];
                self.Entity.angle=[item objectForKey:@"angle"];
                self.Entity.oil=[item objectForKey:@"oil"];
                self.Entity.temper=[item objectForKey:@"temper"];
                self.Entity.extend=[item objectForKey:@"extend"];
                //NSLog(@"pctime=%@",self.Entity.PCTime);
                //[self reloadTableSource:self.Entity];
                self.title=self.Entity.Name;
            }
        }
        [self showPointAnnotation];
    }];
    [request setFailedBlock:^{
        [self showPointAnnotation];
    }];
    [request startAsynchronous];
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
