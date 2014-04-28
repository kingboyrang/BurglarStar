//
//  SOSManagerViewController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "SOSManagerViewController.h"
#import "UIBarButtonItem+TPCategory.h"
#import "TKSOSCell.h"
#import "SOSMessage.h"
#import "ASIServiceHTTPRequest.h"
#import "AlertHelper.h"
#import "SOSAddViewController.h"
#import "SOSEditHandleController.h"
#import "SOSEditNotHandleController.h"
#import "BusLocationViewController.h"
@interface SOSManagerViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    BOOL isFirstLoad;
}
- (void)buttonSOSAdd;
- (void)buttonSOSEdit:(UIButton*)btn;
- (void)buttonSubmitRemoveClick:(UIButton*)btn;
- (void)loadSosSource;
- (SOSMessage*)FindById:(NSString*)guid;
- (void)deleteSoSWithButton:(UIButton*)btn;
- (void)buttonLocationClick:(UIButton*)btn;
- (BOOL)showCheckedFindById:(NSString*)areaId;
@end

@implementation SOSManagerViewController
- (void)dealloc{
    [super dealloc];
    [_tableView release];
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
    [self loadSosSource];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"SOS报警";
    UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"添加" target:self action:@selector(buttonSOSAdd) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2=[UIBarButtonItem barButtonWithTitle:@"编辑" target:self action:@selector(buttonSOSEdit:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *actionButtonItems = [NSArray arrayWithObjects:btn2,btn1, nil];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bounces=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _toolBarView=[[ToolEditView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height+_tableView.frame.origin.y+44, self.view.bounds.size.width, 44)];
    [_toolBarView.toolBar.submit addTarget:self action:@selector(deleteSoSWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView.barView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
    [_toolBarView.barView.button addTarget:self action:@selector(buttonSubmitRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBarView];
    
    isFirstLoad=YES;
}
- (void)loadSosSource{
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    Account *acc=[Account unarchiverAccount];
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"GetUserSosList";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"UserID", nil], nil];
    //NSLog(@"soap=%@",args.bodyMessage);
    if (isFirstLoad) {
       [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    }
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (isFirstLoad) {
            isFirstLoad=NO;
            [self hideLoadingViewAnimated:nil];
        }
        if (request.ServiceResult.success) {
            [request.ServiceResult.xmlParse setDataSource:request.ServiceResult.filterXml];
            XmlNode *node=[request.ServiceResult.xmlParse selectSingleNode:request.ServiceResult.xpath];
            NSArray *arr=[SOSMessage jsonSerializationSOSMessages:node.InnerText];
            if (arr&&[arr count]>0) {
                self.list=[NSMutableArray arrayWithArray:arr];
                [_tableView reloadData];
            }
        }
    }];
    [request setFailedBlock:^{
        if (isFirstLoad) {
            isFirstLoad=NO;
            [self hideLoadingFailedWithTitle:@"资料加载失败！" completed:nil];
        }
    }];
    [request startAsynchronous];
}
//添加
- (void)buttonSOSAdd{
    SOSAddViewController *add=[[SOSAddViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
    [add release];
}
//编辑
- (void)buttonSOSEdit:(UIButton*)btn{
    CGRect r1=_tableView.frame;
    CGRect r=_toolBarView.frame;
    BOOL boo=NO;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {
        boo=YES;
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        r.origin.y=r1.size.height+r1.origin.y-r.size.height;
        r1.size.height-=r.size.height;
        
    }else{
        if(self.removeList&&[self.removeList count]>0)
        {
            [self.removeList removeAllObjects];
        }
        [_toolBarView.barView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
        [_toolBarView bringSubviewToFront:_toolBarView.barView];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        r.origin.y+=r.size.height;
        r1.size.height+=r.size.height;
    }
    if (self.list&&[self.list count]>0) {
        for (NSInteger i=0;i<self.list.count;i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            TKSOSCell *cell=(TKSOSCell*)[_tableView cellForRowAtIndexPath:indexPath];
            if (boo) {
                [cell mSelectedState:NO];
            }else{
               [cell changeMSelectedState];
            }
            
        }
    }
    [UIView animateWithDuration:0.5f animations:^(){
        _toolBarView.frame=r;
        _tableView.frame=r1;
    } completion:^(BOOL finished) {
        if (finished) {
            [_tableView reloadData];
        }
    }];
}
//删除
- (void)buttonSubmitRemoveClick:(UIButton*)btn{
    if (self.removeList&&[self.removeList count]>0) {
        [_toolBarView sendBarViewBack];
    }
}
- (void)deleteSoSWithButton:(UIButton*)btn{
    btn.enabled=NO;
    NSMutableArray *delSource=[NSMutableArray array];
    for (NSString *sysid in self.removeList.allKeys) {
        SOSMessage *entity=[self FindById:sysid];
        if (entity!=nil) {
            [delSource addObject:entity];
        }
    }
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"DelSOSInfo";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[self.removeList.allKeys componentsJoinedByString:@","],@"SOSPKID", nil], nil];
    [self showLoadingAnimatedWithTitle:@"正在删除,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        btn.enabled=YES;
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            [request.ServiceResult.xmlParse setDataSource:request.ServiceResult.filterXml];
            XmlNode *node=[request.ServiceResult.xmlParse selectSingleNode:request.ServiceResult.xpath];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if (dic&&[dic count]>0&&[dic.allKeys containsObject:@"Result"]&&[[[dic objectForKey:@"Result"] Trim] isEqualToString:@"true"]) {
                boo=YES;
                [self.list removeObjectsInArray:delSource];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.removeList allValues]] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                [self.removeList removeAllObjects];
                [_toolBarView.barView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
                [_toolBarView bringSubviewToFront:_toolBarView.barView];
                
                [self hideLoadingSuccessWithTitle:@"删除成功!" completed:nil];
                [_tableView reloadData];
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"删除失败!" completed:nil];
        }
    }];
    [request setFailedBlock:^{
        btn.enabled=YES;
        [self hideLoadingFailedWithTitle:@"删除失败!" completed:nil];
    }];
    [request startAsynchronous];
}
- (SOSMessage*)FindById:(NSString*)guid{
    if (self.list&&[self.list count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.SOSPKID =='%@'",guid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.list filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            SOSMessage *item=[results objectAtIndex:0];
            return item;
        }
    }
    return nil;
}
//当前定位
- (void)buttonLocationClick:(UIButton*)btn{
    id v=[btn superview];
    while (![v isKindOfClass:[UITableViewCell class]]) {
        v=[v superview];
    }
    UITableViewCell *cell=(UITableViewCell*)v;
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    SOSMessage *entity=self.list[indexPath.row];
    
    SupervisionPerson *person=[[[SupervisionPerson alloc] init] autorelease];
    person.ID=entity.carID;
    person.Name=entity.CarNo;
    
    BusLocationViewController *bus=[[BusLocationViewController alloc] init];
    bus.Entity=person;
    [self.navigationController pushViewController:bus animated:YES];
    [bus release];
    
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
     SOSMessage *entity=self.list[indexPath.row];
    
    if ([entity.Status isEqualToString:@"1"]) {//未处理
        SOSEditNotHandleController *edit=[[SOSEditNotHandleController alloc] init];
        edit.Entity=entity;
        [self.navigationController pushViewController:edit animated:YES];
        [edit release];
    }else{//已处理
        SOSEditHandleController *edit=[[SOSEditHandleController alloc] init];
        edit.Entity=entity;
        [self.navigationController pushViewController:edit animated:YES];
        [edit release];
    }
}
//选中处理
- (void)buttonChkClick:(UIButton*)btn{
    btn.selected=!btn.selected;
    
    id v=[btn superview];
    while (![v isKindOfClass:[UITableViewCell class]]) {
        v=[v superview];
    }
    UITableViewCell *cell=(UITableViewCell*)v;
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    SOSMessage *entity=self.list[indexPath.row];
    if (!self.removeList) {
        self.removeList=[NSMutableDictionary dictionary];
    }
    if (btn.selected) {//选中
        [self.removeList setValue:indexPath forKey:entity.SOSPKID];
        [_toolBarView.barView.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
        
    }else{//不选中
        [self.removeList removeObjectForKey:entity.SOSPKID];
        [_toolBarView.barView.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SosCell";
    TKSOSCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[TKSOSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        [cell.button addTarget:self action:@selector(buttonLocationClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.chkButton addTarget:self action:@selector(buttonChkClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.arrowButton addTarget:self action:@selector(buttonSkipClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row%2==0) {
        [cell.arrowButton setImage:[UIImage imageNamed:@"arrow_right_n.png"] forState:UIControlStateNormal];
        cell.contentView.backgroundColor=[UIColor colorFromHexRGB:@"efeedc"];
        cell.labName.textColor=[UIColor colorFromHexRGB:@"252930"];
        cell.labDate.textColor=[UIColor colorFromHexRGB:@"252930"];
    }else{
        [cell.arrowButton setImage:[UIImage imageNamed:@"arrow_right_s.png"] forState:UIControlStateNormal];
        cell.contentView.backgroundColor=[UIColor colorFromHexRGB:@"bebeb8"];
        cell.labName.textColor=[UIColor colorFromHexRGB:@"eae7d1"];
        cell.labDate.textColor=[UIColor colorFromHexRGB:@"eae7d1"];
    }
    SOSMessage *entity=self.list[indexPath.row];
    cell.labName.text=entity.CarNo;
    cell.labDate.text=entity.CreateDate;
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {//隐藏
        [cell changeMSelectedState];
    }else{//显示
        [cell mSelectedState:[self showCheckedFindById:entity.SOSPKID]];
    }
    return cell;
}
- (BOOL)showCheckedFindById:(NSString*)areaId{
    if (self.removeList&&[self.removeList count]>0) {
        if ([self.removeList.allKeys containsObject:areaId]) {
            return YES;
        }
    }
    return NO;
}
@end
