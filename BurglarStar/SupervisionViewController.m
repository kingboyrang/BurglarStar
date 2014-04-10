//
//  SupervisionViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "SupervisionViewController.h"
#import "Account.h"
#import "TKMonitorCell.h"
#import "ToolBarView.h"
#import "AlertHelper.h"
#import "AddSupervision.h"
#import "EditSupervisionHead.h"
#import "TrajectoryViewController.h"
#import "TrajectoryMessageController.h"
#import "EditSupervisionViewController.h"
#import "CallTrajectoryViewController.h"
#import "PersonTrajectoryViewController.h"
#import "ASIServiceHTTPRequest.h"
#import "UIBarButtonItem+TPCategory.h"
#import "BusLocationViewController.h"
@interface SupervisionViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    ToolBarView *_toolBar;
}
- (void)buttonAddClick;
- (void)buttonEditClick:(id)sender;
- (void)loadSupervision;
- (NSArray*)arrayToSupervisions:(NSArray*)source;
- (void)buttonSubmitRemoveClick;
- (void)buttonCancelRemoveClick;
- (SupervisionPerson*)FindById:(NSString*)guid;
- (void)deleteSupervisons;
@end

@implementation SupervisionViewController
- (void)dealloc{
    [super dealloc];
    [_tableView release];
    [_toolBar release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadSupervision];//重新加载资料
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"车辆管理";
    
    UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"添加"  target:self action:@selector(buttonAddClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2=[UIBarButtonItem barButtonWithTitle:@"编辑"  target:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *actionButtonItems = [NSArray arrayWithObjects:btn2,btn1, nil];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
	CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
    //_tableView.bounces=NO;
    [self.view addSubview:_tableView];
    
    _toolBar=[[ToolBarView alloc] initWithFrame:CGRectMake(0, r.size.height+r.origin.y+44, self.view.bounds.size.width, 44)];
    [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
    [_toolBar.button addTarget:self action:@selector(buttonSubmitRemoveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBar];
    
}
- (void)loadSupervision{
    
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    Account *acc=[Account unarchiverAccount];
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetSuperviseInfo";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"WorkNo", nil], nil];
    [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        [self hideLoadingViewAnimated:nil];
        NSDictionary *dic=[request.ServiceResult json];
        if (dic!=nil) {
            NSArray *source=[dic objectForKey:@"Person"];
            self.cells=[NSMutableArray arrayWithArray:[self arrayToSupervisions:source]];
            [_tableView reloadData];
            
        }

    }];
    [request setFailedBlock:^{
        [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
    }];
    [request startAsynchronous];
}
- (NSArray*)arrayToSupervisions:(NSArray*)source{
    if (source&&[source count]>0) {
        NSMutableArray *result=[NSMutableArray arrayWithCapacity:source.count];
        for (NSDictionary *item in source) {
            SupervisionPerson *entity=[[SupervisionPerson alloc] init];
            for (NSString *k in item.allKeys) {
                SEL sel=NSSelectorFromString(k);
                if ([entity respondsToSelector:sel]) {
                    [entity setValue:[item objectForKey:k] forKey:k];
                }

            }
            [result addObject:entity];
            [entity release];
        }
        return result;
    }
    return [NSArray array];
}
-(void)supervisionEditHeadWithEntity:(SupervisionPerson*)entity{
    EditSupervisionHead *edit=[[EditSupervisionHead alloc] init];
    edit.Entity=entity;
    edit.operateType=2;//修改
    [self.navigationController pushViewController:edit animated:YES];
    [edit release];
}
-(void)supervisionMessageWithEntity:(SupervisionPerson*)entity{
    TrajectoryMessageController *message=[[TrajectoryMessageController alloc] init];
    message.Entity=entity;
    [self.navigationController pushViewController:message animated:YES];
    [message release];
}
-(void)supervisionTrajectoryWithEntity:(SupervisionPerson*)entity{
    PersonTrajectoryViewController *trajectory=[[PersonTrajectoryViewController alloc] init];
    trajectory.Entity=entity;
    [self.navigationController pushViewController:trajectory animated:YES];
    [trajectory release];
    /***
    TrajectoryViewController *trajectory=[[TrajectoryViewController alloc] init];
    trajectory.Entity=entity;
    [self.navigationController pushViewController:trajectory animated:YES];
    [trajectory release];
     ***/
}
-(void)supervisionCallWithEntity:(SupervisionPerson*)entity{
    BusLocationViewController *controler=[[BusLocationViewController alloc] init];
    controler.Entity=entity;
    [self.navigationController pushViewController:controler animated:YES];
    [controler release];
}
//取消删除
- (void)buttonCancelRemoveClick{
    if (self.removeList&&self.removeList.count>0) {
        NSArray *indexPaths=[[self.removeList allValues] retain];
        for (NSString *item in indexPaths) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[item intValue] inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:YES]; 
            [self tableView:_tableView didDeselectRowAtIndexPath:indexPath];
        }
        [indexPaths release];
    }else{
       [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
    }
   
}
- (SupervisionPerson*)FindById:(NSString*)guid{
    if (self.cells&&[self.cells count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.ID =='%@'",guid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.cells filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            SupervisionPerson *item=[results objectAtIndex:0];
            return item;
        }
    }
    return nil;

}
//删除
- (void)deleteSupervisons{
    [self showLoadingAnimatedWithTitle:@"正在删除,请稍后..."];
    NSMutableArray *delSource=[NSMutableArray array];
    NSMutableArray *indexPaths=[NSMutableArray array];
    for (NSString *item in self.removeList.allKeys) {
        NSString *row=[self.removeList objectForKey:item];
        [indexPaths addObject:[NSIndexPath indexPathForRow:[row intValue] inSection:0]];
        [delSource addObject:self.cells[[row intValue]]];
    }
    NSString *ids=[NSString stringWithFormat:@"'%@'",[self.removeList.allKeys componentsJoinedByString:@"','"]];
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"DeletePerson";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:ids,@"personID", nil], nil];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if ([[dic objectForKey:@"Result"] isEqualToString:@"1"]) {
                boo=YES;
                [self.cells removeObjectsInArray:delSource];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                [self.removeList removeAllObjects];
                [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
                [self hideLoadingSuccessWithTitle:@"删除成功!" completed:nil];
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"删除失败!" completed:nil];
        }
        
    }];
    [request setFailedBlock:^{
        [self hideLoadingFailedWithTitle:@"删除失败!" completed:nil];
    }];
    [request startAsynchronous];
}
//确认删除
- (void)buttonSubmitRemoveClick{
    if (self.removeList&&[self.removeList count]>0) {
        [AlertHelper confirmWithTitle:@"删除" confirm:^{
            [self deleteSupervisons];
        } innnerView:self.view];
    }
}
//新增
- (void)buttonAddClick{
    AddSupervision *add=[[AddSupervision alloc] init];
    add.operateType=1;//表示新增
    [self.navigationController pushViewController:add animated:YES];
    [add release];
}
//编辑
- (void)buttonEditClick:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [_tableView setEditing:!_tableView.editing animated:YES];
    if(_tableView.editing){
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        CGRect r1=_tableView.frame;
        
        CGRect r=_toolBar.frame;
        r.origin.y=r1.origin.y+r1.size.height-r.size.height;
        r1.size.height-=r.size.height;

        [UIView animateWithDuration:0.5f animations:^(){
            _toolBar.frame=r;
            _tableView.frame=r1;
        }];
    }
	else {
        //[self buttonCancelRemoveClick];
        if (self.removeList&&[self.removeList count]>0) {
            [self.removeList removeAllObjects];
        }
        [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        CGRect r=_toolBar.frame;
        r.origin.y+=r.size.height;
        
        CGRect r1=_tableView.frame;
        r1.size.height+=r.size.height;
        
        [UIView animateWithDuration:0.5f animations:^(){
            _toolBar.frame=r;
            _tableView.frame=r1;
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
    
    static NSString *cellIdentifier=@"SupervisionCell";
    TKMonitorCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[TKMonitorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.monitorView.controler=self;
    }
    cell.backgroundColor=[UIColor clearColor];
    SupervisionPerson *entity=self.cells[indexPath.row];
    [cell.monitorView setDataSource:entity indexPathRow:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EditSupervisionViewController *edit=[[EditSupervisionViewController alloc] init];
        edit.Entity=self.cells[indexPath.row];
        [self.navigationController pushViewController:edit animated:YES];//修改监管目标
        [edit release];
    }else{
        if (!self.removeList) {
            self.removeList=[NSMutableDictionary dictionary];
        }
        SupervisionPerson *entity=self.cells[indexPath.row];
        [self.removeList setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:entity.ID];
        [_toolBar.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"取消"]) {
         SupervisionPerson *entity=self.cells[indexPath.row];
        [self.removeList removeObjectForKey:entity.ID];
        [_toolBar.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
@end
