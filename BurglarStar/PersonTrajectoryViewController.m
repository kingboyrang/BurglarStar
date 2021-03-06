//
//  PersonTrajectoryViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "PersonTrajectoryViewController.h"
#import "Account.h"
#import "NSDate+TPCategory.h"
#import "AppHelper.h"
#import "TrajectoryHistory.h"
#import "TKTrajectoryCell.h"
#import "SingleMapShowViewController.h"
#import "ShowTrajectoryViewController.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
@interface PersonTrajectoryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    BOOL isFirstLoad;
}
- (void)loadingHistory;
- (void)buttonSkipClick:(UIButton*)btn;
@end

@implementation PersonTrajectoryViewController
- (void)dealloc{
    [super dealloc];
    [_tableView release],_tableView=nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.Entity&&self.Entity.ID&&[self.Entity.ID length]>0) {
        [self loadingHistory];
    }else{
        self.cells=[NSArray array];
        [_tableView reloadData];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstLoad=YES;
    if (self.Entity&&self.Entity.Name&&[self.Entity.Name length]>0) {
        //self.title=[NSString stringWithFormat:@"%@--足迹",self.Entity.Name];
        self.title=self.Entity.Name;
    }
    
    UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"地图" target:self action:@selector(buttonMapLinesClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2=[UIBarButtonItem barButtonArrowItemTarget:self action:@selector(buttonSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *actionButtonItems = [NSArray arrayWithObjects:btn2,btn1, nil];
    self.navigationItem.rightBarButtonItems = actionButtonItems;

    
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bounces=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _trajectorySearch=[[TrajectorySearch alloc] initWithFrame:CGRectMake(0,-79, self.view.bounds.size.width, 79)];
    [_trajectorySearch.button addTarget:self action:@selector(buttonSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trajectorySearch];
    [self.view sendSubviewToBack:_trajectorySearch];
}
- (BOOL)canShowTrajectory{
    if (self.Entity&&self.Entity.ID&&[self.Entity.ID length]>0) {
        return YES;
    }
    return NO;
}
//显示地图路线
- (void)buttonMapLinesClick{
   if(self.cells&&[self.cells count]>0)
   {
       ShowTrajectoryViewController *show=[[ShowTrajectoryViewController alloc] init];
       show.list=self.cells;
       show.Entity=self.Entity;
       show.startTime=_trajectorySearch.startCalendar.popoverText.popoverTextField.text;
       show.endTime=_trajectorySearch.endCalendar.popoverText.popoverTextField.text;
       [self.navigationController pushViewController:show animated:YES];
       [show release];
   }
}
//查询
- (void)buttonSearchClick{
    if (![_trajectorySearch compareToDate]) {
        return;
    }
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if (btn.selected) {
        CGRect r=self.trajectorySearch.frame;
        r.origin.y=-r.size.height;
        
        CGRect r1=_tableView.frame;
        r1.origin.y=0;
        r1.size.height+=r.size.height;
        
        [UIView animateWithDuration:0.5f animations:^{
            self.trajectorySearch.frame=r;
            _tableView.frame=r1;
            btn.selected=NO;
            [self.view sendSubviewToBack:self.trajectorySearch];
        }];
    }
    [self loadingHistory];
}
//查询
- (void)buttonSwitchClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    if (btn.selected) {//隐藏
        CGRect r=self.trajectorySearch.frame;
        r.origin.y=-r.size.height;
        
        CGRect r1=_tableView.frame;
        r1.origin.y=0;
        r1.size.height+=r.size.height;
        
        [UIView animateWithDuration:0.5f animations:^{
            self.trajectorySearch.frame=r;
            _tableView.frame=r1;
            btn.selected=NO;
            [self.view sendSubviewToBack:self.trajectorySearch];
        }];
    }else{//显示
        [self.view sendSubviewToBack:_tableView];
        
        CGRect r=self.trajectorySearch.frame;
        r.origin.y=0;
        
        CGRect r1=_tableView.frame;
        r1.origin.y=r.size.height;
        r1.size.height-=r1.origin.y;
        
        [UIView animateWithDuration:0.5f animations:^{
            self.trajectorySearch.frame=r;
            _tableView.frame=r1;
            btn.selected=YES;
            
        }];
    }
}
- (void)loadingHistory{
    //表示网络未连接
    if (![self hasNetWork]) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"workno", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"id", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.trajectorySearch.startCalendar.popoverText.popoverTextField.text,@"stime", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.trajectorySearch.endCalendar.popoverText.popoverTextField.text,@"etime", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"ObjectHistoryInfo";
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.soapParams=params;
    if (isFirstLoad) {
         [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    }
   
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if ([dic.allKeys containsObject:@"Person"]) {
                if (isFirstLoad) {
                    isFirstLoad=NO;
                }
                boo=YES;
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    NSArray *source=[dic objectForKey:@"Person"];
                    self.cells=[AppHelper arrayWithSource:source className:@"TrajectoryHistory"];
                    [_tableView reloadData];
                }];
            }
        }
        if (!boo) {
            if (isFirstLoad) {
                isFirstLoad=NO;
                [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
            }
        }
    }];
    [request setFailedBlock:^{
        if (isFirstLoad) {
            isFirstLoad=NO;
            [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
        }
        
    }];
    [request startAsynchronous];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//页面跳转处理
- (void)buttonSkipClick:(UIButton*)btn{
    id v=[btn superview];
    while (![v isKindOfClass:[UITableViewCell class]]) {
        v=[v superview];
    }
    UITableViewCell *cell=(UITableViewCell*)v;
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    TrajectoryHistory *entity=self.cells[indexPath.row];
    SingleMapShowViewController *map=[[SingleMapShowViewController alloc] init];
    map.Entity=entity;
    map.PersonName=self.Entity.Name;
    [self.navigationController pushViewController:map animated:YES];
    [map release];
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
        cell.label.font=[UIFont fontWithName:DeviceFontName size:14];
        cell.label.textColor=[UIColor colorFromHexRGB:@"252930"];
        cell.address.textColor=[UIColor colorFromHexRGB:@"252930"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.arrowButton addTarget:self action:@selector(buttonSkipClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    TrajectoryHistory *entity=self.cells[indexPath.row];
    cell.label.text=entity.formatDateStr;
    cell.address.text=entity.address;

    if (indexPath.row%2==0) {
         [cell.arrowButton setImage:[UIImage imageNamed:@"arrow_right_n.png"] forState:UIControlStateNormal];
         cell.contentView.backgroundColor=[UIColor colorFromHexRGB:@"efeedc"];
    }else{
         [cell.arrowButton setImage:[UIImage imageNamed:@"arrow_right_s.png"] forState:UIControlStateNormal];
        cell.contentView.backgroundColor=[UIColor colorFromHexRGB:@"bebeb8"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrajectoryHistory *entity=self.cells[indexPath.row];
    CGFloat w=self.view.bounds.size.width-110-26-5;
    CGSize size=[entity.address textSize:[UIFont fontWithName:DeviceFontName size:14] withWidth:w];
    if (size.height>18) {
        return size.height-18+44;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)] autorelease];
    //bgView.backgroundColor=[UIColor colorFromHexRGB:@"d5e1f0"];
    UIImage *img=[UIImage imageNamed:@"tab_head_bg"];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [imgView setImage:img];
    [bgView addSubview:imgView];
    [imgView release];
    
    NSString *lab1Title=@"时间";
    CGSize size=[lab1Title textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.view.bounds.size.width];
    UILabel *lab1=[[UILabel alloc] initWithFrame:CGRectMake((102-size.width)/2,(bgView.frame.size.height-size.height)/2, size.width,size.height)];
    lab1.text=lab1Title;
    lab1.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    lab1.backgroundColor=[UIColor clearColor];
    lab1.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    [bgView addSubview:lab1];
    [lab1 release];
    
    CGFloat w=self.view.bounds.size.width-102;
    NSString *lab2Title=@"位置";
    size=[lab2Title textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.view.bounds.size.width];
    UILabel *lab2=[[UILabel alloc] initWithFrame:CGRectMake(102+(w-size.width)/2,(bgView.frame.size.height-size.height)/2, size.width,size.height)];
    lab2.text=lab2Title;
    lab2.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    lab2.backgroundColor=[UIColor clearColor];
    lab2.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    [bgView addSubview:lab2];
    [lab2 release];
    
    
    return bgView;
}
/***
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TrajectoryHistory *entity=self.cells[indexPath.row];
    SingleMapShowViewController *map=[[SingleMapShowViewController alloc] init];
    map.Entity=entity;
    map.PersonName=self.Entity.Name;
    [self.navigationController pushViewController:map animated:YES];
    [map release];
}
 ***/
@end
