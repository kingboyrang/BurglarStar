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
    
    _toolBarView=[[ToolBarView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height+_tableView.frame.origin.y+44, self.view.bounds.size.width, 44)];
    [_toolBarView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
    [_toolBarView.button addTarget:self action:@selector(buttonSubmitRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBarView];
    
    isFirstLoad=YES;
}
- (void)loadSosSource{

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
        NSLog(@"xml=%@",request.responseString);
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult json];
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
    [_tableView setEditing:!_tableView.editing animated:YES];
    if(_tableView.editing){
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        CGRect r1=_tableView.frame;
        CGRect r=_toolBarView.frame;
        r.origin.y=r1.size.height+r1.origin.y-r.size.height;
        
        r1.size.height-=r.size.height;
        
        [UIView animateWithDuration:0.5f animations:^(){
            _toolBarView.frame=r;
            _tableView.frame=r1;
        }];
    }
	else {
        if(self.removeList&&[self.removeList count]>0)
        {
            [self.removeList removeAllObjects];
        }
        [_toolBarView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        CGRect r=_toolBarView.frame;
        //r.origin.y=self.view.bounds.size.height+44;
        r.origin.y+=r.size.height;
        
        CGRect r1=_tableView.frame;
        //r1.size.height=self.view.bounds.size.height-44;
        r1.size.height+=r.size.height;
        
        [UIView animateWithDuration:0.5f animations:^(){
            _toolBarView.frame=r;
            _tableView.frame=r1;
        }];
	}
}
//删除
- (void)buttonSubmitRemoveClick:(UIButton*)btn{
    if (self.removeList&&[self.removeList count]>0) {
        [AlertHelper confirmWithTitle:@"删除" confirm:^{
            [self deleteSoSWithButton:btn];
        } innnerView:self.view];
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
            NSDictionary *dic=[request.ServiceResult json];
            if (dic&&[dic count]>0&&[dic.allKeys containsObject:@"Result"]&&[[dic objectForKey:@"Result"] isEqualToString:@"true"]) {
                boo=YES;
                
                [self.list removeObjectsInArray:delSource];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.removeList allValues]] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                [self.removeList removeAllObjects];
                [_toolBarView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
                
                [self hideLoadingSuccessWithTitle:@"删除成功!" completed:nil];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.labName.text=entity.CompanyName;
    cell.labDate.text=entity.formatDateText;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    SOSMessage *entity=self.list[indexPath.row];
    if ([btn.currentTitle isEqualToString:@"编辑"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    }else{
        if (!self.removeList) {
            self.removeList=[NSMutableDictionary dictionary];
        }
        [self.removeList setValue:indexPath forKey:entity.SOSPKID];
        [_toolBarView.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"取消"]) {
        SOSMessage *entity=self.list[indexPath.row];
        [self.removeList removeObjectForKey:entity.SOSPKID];
        [_toolBarView.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
@end
