//
//  CallTrajectoryViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "CallTrajectoryViewController.h"
#import "TelephoneViewController.h"
#import "ASIServiceHTTPRequest.h"
//#import <CoreTelephony/CTCallCenter.h>
//#import <CoreTelephony/CTCall.h>


//extern NSString *CTSettingCopyMyPhoneNumber();

@interface CallTrajectoryViewController ()
- (void)loadingPhones;
- (void)cleanMap;
@end



@implementation CallTrajectoryViewController


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
    _mapView.delegate = self;
    
    [self cleanMap];
    CLLocationCoordinate2D coor;
    coor.latitude=[self.Entity.Latitude floatValue];
    coor.longitude=[self.Entity.Longitude floatValue];
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
    item.coordinate = coor;
    item.title=self.Entity.Address;
    [_mapView addAnnotation:item];
    [_mapView setCenterCoordinate:coor];
    [_mapView selectAnnotation:item animated:YES];
    [item release];
    
    
    [self loadingPhones];//加载电话
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@--电话",self.Entity.Name];
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
   
    _mapView= [[BMKMapView alloc]initWithFrame:r];
    [self.view addSubview:_mapView];
    
    CGFloat topY=self.view.bounds.size.height;
    _phoneView=[[CallPhoneView alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 119)];
    _phoneView.controlers=self;
    //_phoneView.labPhone.text=self.Entity.Phone;
    [self.view addSubview:_phoneView];
    
    
}
- (BOOL)canShowCall{
    if (self.Entity&&self.Entity.ID&&[self.Entity.ID length]>0) {
        return YES;
    }
    return NO;
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
//拨打电话
- (void)callWithPhone:(NSString*)phone{
    TelephoneViewController *tele=[[TelephoneViewController alloc] init];
    tele.Phone=phone;
    tele.Entity=self.Entity;
    [self.navigationController pushViewController:tele animated:YES];
    [tele release];
}
//加载电话
- (void)loadingPhones{
    //NSString *num =CTSettingCopyMyPhoneNumber();
    //[[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"simNo", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"personId", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.DeviceCode,@"DeviceCode", nil]];
    
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetCanTeleNo";
    args.soapParams=params;
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        NSDictionary *dic=[request.ServiceResult json];
        if (dic!=nil) {
            //_phoneView.labPhone.text=[dic objectForKey:@"Phone"];//要打出去的电话号码
            //NSString *type=[dic objectForKey:@"Type"];//1 ： 表示亲情和监听号码都不能打，能左右活动的按钮
            [_phoneView setCallPhone:[dic objectForKey:@"Phone"] type:[dic objectForKey:@"Type"]];
        }

    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    CGRect r=_phoneView.frame;
    r.origin.y-=r.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        _phoneView.frame=r;
    }];
}
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    CGRect r=_phoneView.frame;
    r.origin.y+=r.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        _phoneView.frame=r;
    }];
}
@end
