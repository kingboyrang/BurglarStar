//
//  TrajectoryViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TrajectoryViewController.h"
#import "Account.h"
#import "TrajectoryHistory.h"
#import "AppHelper.h"
#import "TKTrajectoryCell.h"
#import "ShowTrajectoryViewController.h"
#import "SingleMapShowViewController.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
@interface TrajectoryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
- (void)loadTrajectory;
- (void)buttonSearchClick;
@end

@implementation TrajectoryViewController
- (void)dealloc{
    [super dealloc];
    [_tableView release],_tableView=nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@--足迹",self.Entity.Name];
    
    UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"地图" target:self action:@selector(buttonMapClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2=[UIBarButtonItem barButtonArrowItemTarget:self action:@selector(buttonSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *actionButtonItems = [NSArray arrayWithObjects:btn2,btn1, nil];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.bounces=NO;
    [self.view addSubview:_tableView];
	
    _trajectorySearch=[[TrajectorySearch alloc] initWithFrame:CGRectMake(0, 44-79, self.view.bounds.size.width, 79)];
    [_trajectorySearch.button addTarget:self action:@selector(buttonSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trajectorySearch];
    [self.view sendSubviewToBack:_trajectorySearch];
    
    [self loadTrajectory];
}
- (void)loadTrajectory{
    
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray arrayWithCapacity:6];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"workno", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"id", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.trajectorySearch.startCalendar.popoverText.popoverTextField.text,@"stime", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.trajectorySearch.endCalendar.popoverText.popoverTextField.text,@"etime", nil]];
    //[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.trajectorySearch.endCalendar.popoverText.popoverTextField.text,@"pointTime", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"ObjectHistoryInfo";
    args.soapParams=params;
    
    [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if ([dic.allKeys containsObject:@"Person"]) {
                boo=YES;
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    NSArray *source=[dic objectForKey:@"Person"];
                    self.cells=[AppHelper arrayWithSource:source className:@"TrajectoryHistory"];
                    [_tableView reloadData];
                }];
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
        }

    }];
    [request setFailedBlock:^{
         [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
    }];
    [request startAsynchronous];
}
//查询
- (void)buttonSearchClick{
    if (![_trajectorySearch compareToDate]) {
        return;
    }
    [self loadTrajectory];
}
//地图
- (void)buttonMapClick{
    ShowTrajectoryViewController *map=[[ShowTrajectoryViewController alloc] init];
    map.list=self.cells;
    map.Entity=self.Entity;
    [self.navigationController pushViewController:map animated:YES];
    [map release];
}
//查询
- (void)buttonSwitchClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    if (btn.selected) {//隐藏
        CGRect r=self.trajectorySearch.frame;
        r.origin.y=44-r.size.height;
        
        CGRect r1=_tableView.frame;
        r1.origin.y=44;
        r1.size.height=self.view.bounds.size.height-r1.origin.y;
        
        [UIView animateWithDuration:0.5f animations:^{
            self.trajectorySearch.frame=r;
            _tableView.frame=r1;
            btn.selected=NO;
             [self.view sendSubviewToBack:self.trajectorySearch];
        }];
    }else{//显示
        [self.view sendSubviewToBack:_tableView];
        
        CGRect r=self.trajectorySearch.frame;
        r.origin.y=44;
        
        CGRect r1=_tableView.frame;
        r1.origin.y=44+r.size.height;
        r1.size.height=self.view.bounds.size.height-r1.origin.y;
        
        [UIView animateWithDuration:0.5f animations:^{
            self.trajectorySearch.frame=r;
            _tableView.frame=r1;
            btn.selected=YES;
            
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"TrajectoryCell";
    TKTrajectoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[TKTrajectoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
    }
    TrajectoryHistory *entity=self.cells[indexPath.row];
    cell.label.text=entity.pctime;
    cell.address.text=entity.address;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrajectoryHistory *entity=self.cells[indexPath.row];
    CGFloat w=self.view.bounds.size.width/2-5;
    CGSize size=[entity.address textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:w];
    if (size.height+10>44) {
        return size.height+10+2;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)] autorelease];
    bgView.backgroundColor=[UIColor colorFromHexRGB:@"d5e1f0"];
    
    NSString *lab1Title=@"时间";
    CGSize size=[lab1Title textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.view.bounds.size.width];
    UILabel *lab1=[[UILabel alloc] initWithFrame:CGRectMake(20,(bgView.frame.size.height-size.height)/2, size.width,size.height)];
    lab1.text=lab1Title;
    lab1.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    lab1.backgroundColor=[UIColor clearColor];
    [bgView addSubview:lab1];
    [lab1 release];
    
    
    NSString *lab2Title=@"位置";
    size=[lab2Title textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.view.bounds.size.width];
    UILabel *lab2=[[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-20,(bgView.frame.size.height-size.height)/2, size.width,size.height)];
    lab2.text=lab2Title;
    lab2.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    lab2.backgroundColor=[UIColor clearColor];
    [bgView addSubview:lab2];
    [lab2 release];
    
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TrajectoryHistory *entity=self.cells[indexPath.row];
    SingleMapShowViewController *map=[[SingleMapShowViewController alloc] init];
    map.Entity=entity;
    map.PersonName=self.Entity.Name;
    [self.navigationController pushViewController:map animated:YES];
    [map release];
}
@end
