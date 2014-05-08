//
//  AreaViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/27.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "AreaViewController.h"
#import "Account.h"
#import "AreaCrawl.h"
#import "AppHelper.h"
#import "ToolEditView.h"
#import "ModifyAreaViewController.h"
#import "AreaRangeViewController.h"
#import "AlertHelper.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
#import "TKAreaCell.h"
@interface AreaViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    ToolEditView *_toolBar;
    BOOL isFirstLoad;
}
- (void)loadingArea;
- (void)buttonAddClick;
- (void)buttonEditClick:(id)sender;
- (AreaCrawl*)FindById:(NSString*)guid;
- (void)deleteAreaWithButton:(UIButton*)btn;
- (BOOL)showCheckedFindById:(NSString*)areaId;//判断是否存在选中的项
@end

@implementation AreaViewController
- (void)dealloc{
    [super dealloc];
    [_toolBar release];
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
    [self loadingArea];//重新加载资料

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"电子围栏";
    isFirstLoad=YES;
    
    UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"添加" target:self action:@selector(buttonAddClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2=[UIBarButtonItem barButtonWithTitle:@"编辑" target:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    _toolBar=[[ToolEditView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height+_tableView.frame.origin.y+44, self.view.bounds.size.width, 44)];
    [_toolBar.toolBar.submit addTarget:self action:@selector(deleteAreaWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar.barView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
    [_toolBar.barView.button addTarget:self action:@selector(buttonSubmitRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBar];
    
    
}
- (void)loadingArea{
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray arrayWithCapacity:6];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"workno", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"areaID", nil]];
    
    if (isFirstLoad) {
        [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    }
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetAreaData";
    args.soapParams=params;
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (isFirstLoad) {
            isFirstLoad=NO;
            [self hideLoadingViewAnimated:nil];
        }
        if (request.ServiceResult.success) {
            NSDictionary *dic=(NSDictionary*)[request.ServiceResult json];
            NSArray *source=[dic objectForKey:@"AreaList"];
            self.list=[NSMutableArray arrayWithArray:[AppHelper arrayWithSource:source className:@"AreaCrawl"]];
            [_tableView reloadData];
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
- (AreaCrawl*)FindById:(NSString*)guid{
    if (self.list&&[self.list count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.SysID =='%@'",guid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.list filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            AreaCrawl *item=[results objectAtIndex:0];
            return item;
        }
    }
    return nil;
}
- (void)deleteAreaWithButton:(UIButton*)btn{
    btn.enabled=NO;
    
    NSMutableArray *delSource=[NSMutableArray array];
    for (NSString *sysid in self.removeList.allKeys) {
        AreaCrawl *entity=[self FindById:sysid];
        if (entity!=nil) {
            [delSource addObject:entity];
        }
    }
    [self showLoadingAnimatedWithTitle:@"正在删除,请稍后..."];
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"DelArea";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[self.removeList.allKeys componentsJoinedByString:@","],@"areaID", nil], nil];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        btn.enabled=YES;
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=(NSDictionary*)[request.ServiceResult json];
            if (dic!=nil&&![[dic objectForKey:@"Result"] isEqualToString:@"0"]) {
                boo=YES;
                [self.list removeObjectsInArray:delSource];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.removeList allValues]] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                [self.removeList removeAllObjects];
                [_toolBar.barView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
                [_toolBar sendToolBarBack];
                
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
//删除
- (void)buttonSubmitRemoveClick:(id)sender{
    if (self.removeList&&[self.removeList count]>0) {
        [_toolBar sendBarViewBack];
    }
}
//新增
- (void)buttonAddClick{
    ModifyAreaViewController *modify=[[ModifyAreaViewController alloc] init];
    modify.operateType=1;//新增
    [self.navigationController pushViewController:modify animated:YES];
    [modify release];
}
//编辑
- (void)buttonEditClick:(UIButton*)btn{
    CGRect r1=_tableView.frame;
    CGRect r=_toolBar.frame;
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
        [_toolBar.barView.button setTitle:@"删除(0)" forState:UIControlStateNormal];
        [_toolBar sendToolBarBack];
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        r.origin.y+=r.size.height;
        r1.size.height+=r.size.height;
    }
    if (self.list&&[self.list count]>0) {
        for (NSInteger i=0;i<self.list.count;i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            TKAreaCell *cell=(TKAreaCell*)[_tableView cellForRowAtIndexPath:indexPath];
            if (boo) {
                [cell mSelectedState:NO];
            }else{
                [cell changeMSelectedState];
            }
            
        }
    }
    [UIView animateWithDuration:0.5f animations:^(){
        _toolBar.frame=r;
        _tableView.frame=r1;
    } completion:^(BOOL finished) {
        if (finished) {
            [_tableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
     AreaCrawl *entity=self.list[indexPath.row];
    if (!self.removeList) {
        self.removeList=[NSMutableDictionary dictionary];
    }
    if (btn.selected) {//选中
        [self.removeList setValue:indexPath forKey:entity.SysID];
        [_toolBar.barView.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
        
    }else{//不选中
        [self.removeList removeObjectForKey:entity.SysID];
        [_toolBar.barView.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
//页面跳转处理
- (void)buttonSkipClick:(UIButton*)btn{
    id v=[btn superview];
    while (![v isKindOfClass:[UITableViewCell class]]) {
        v=[v superview];
    }
    UITableViewCell *cell=(UITableViewCell*)v;
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    AreaCrawl *area=self.list[indexPath.row];
    ModifyAreaViewController *edit=[[ModifyAreaViewController alloc] init];
    edit.operateType=2;//修改
    edit.AreaId=area.SysID;
    [self.navigationController pushViewController:edit animated:YES];
    [edit release];
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"areaCell";
    TKAreaCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[TKAreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.chkButton addTarget:self action:@selector(buttonChkClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.arrowButton addTarget:self action:@selector(buttonSkipClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row%2==0) {
        [cell.arrowButton setImage:[UIImage imageNamed:@"arrow_right_n.png"] forState:UIControlStateNormal];

        
    }else{
        [cell.arrowButton setImage:[UIImage imageNamed:@"arrow_right_s.png"] forState:UIControlStateNormal];
    }
    
    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    backgrdView.backgroundColor = indexPath.row%2==0?[UIColor colorFromHexRGB:@"efeedc"]:[UIColor colorFromHexRGB:@"bebeb8"];
    cell.backgroundView = backgrdView;
    [backgrdView release];
    AreaCrawl *area=self.list[indexPath.row];
    cell.labName.text=area.AreaName;
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {//隐藏
        [cell changeMSelectedState];
    }else{//显示
        [cell mSelectedState:[self showCheckedFindById:area.SysID]];
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
