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
#import "ToolBarView.h"
#import "ModifyAreaViewController.h"
#import "AreaRangeViewController.h"
#import "AlertHelper.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
@interface AreaViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    ToolBarView *_toolBar;
}
- (void)loadingArea;
- (void)buttonAddClick;
- (void)buttonEditClick:(id)sender;
- (AreaCrawl*)FindById:(NSString*)guid;
- (void)deleteAreaWithButton:(UIButton*)btn;
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
    
    _toolBar=[[ToolBarView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height+_tableView.frame.origin.y+44, self.view.bounds.size.width, 44)];
    [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
    [_toolBar.button addTarget:self action:@selector(buttonSubmitRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetAreaData";
    args.soapParams=params;
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (request.ServiceResult.success) {
            NSDictionary *dic=(NSDictionary*)[request.ServiceResult json];
            NSArray *source=[dic objectForKey:@"AreaList"];
            self.list=[NSMutableArray arrayWithArray:[AppHelper arrayWithSource:source className:@"AreaCrawl"]];
            [_tableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        
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
//清空
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
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=(NSDictionary*)[request.ServiceResult json];
            if (dic!=nil&&![[dic objectForKey:@"Result"] isEqualToString:@"0"]) {
                boo=YES;
                btn.enabled=YES;
                [self.list removeObjectsInArray:delSource];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.removeList allValues]] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                [self.removeList removeAllObjects];
                [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
                
                [self hideLoadingSuccessWithTitle:@"删除成功!" completed:nil];
            }
        }
        if (!boo) {
            btn.enabled=YES;
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
        [AlertHelper confirmWithTitle:@"删除" confirm:^{
            UIButton *btn=(UIButton*)sender;
            [self deleteAreaWithButton:btn];
        } innnerView:self.view];
    }
}
//新增
- (void)buttonAddClick{
   /**
    AreaRangeViewController *range=[[AreaRangeViewController alloc] init];
    range.AreaName=@"羊台山";
    range.AreaId=@"567fa24e-8546-4e66-a1d4-0ab4adab03ac";
    range.RuleId=@"";
    [self.navigationController pushViewController:range animated:YES];
    [range release];
    return;
      ***/
    ModifyAreaViewController *modify=[[ModifyAreaViewController alloc] init];
    modify.operateType=1;//新增
    [self.navigationController pushViewController:modify animated:YES];
    [modify release];
}
//编辑
- (void)buttonEditClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [_tableView setEditing:!_tableView.editing animated:YES];
    if(_tableView.editing){
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        CGRect r1=_tableView.frame;
        CGRect r=_toolBar.frame;
        r.origin.y=r1.size.height+r1.origin.y-r.size.height;
        
        r1.size.height-=r.size.height;
        
        [UIView animateWithDuration:0.5f animations:^(){
            _toolBar.frame=r;
            _tableView.frame=r1;
        }];
    }
	else {
        if(self.removeList&&[self.removeList count]>0)
        {
            [self.removeList removeAllObjects];
        }
        [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        CGRect r=_toolBar.frame;
        //r.origin.y=self.view.bounds.size.height+44;
        r.origin.y+=r.size.height;
        
        CGRect r1=_tableView.frame;
        //r1.size.height=self.view.bounds.size.height-44;
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
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"areaCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
       
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        cell.textLabel.textColor=[UIColor blackColor];
        
        UIImage *image=[UIImage imageNamed:@"arrow_right_n.png"];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [imageView setImage:image];
        cell.accessoryView=imageView;
        [imageView release];
        
       
       
    }
    cell.textLabel.backgroundColor=[UIColor clearColor];
    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    backgrdView.backgroundColor = indexPath.row%2==0?[UIColor colorFromHexRGB:@"bebeb8"]:[UIColor colorFromHexRGB:@"efeedc"];
    cell.backgroundView = backgrdView;
    
    //cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    //cell.selectedBackgroundView.backgroundColor = indexPath.row%2==0?[UIColor colorFromHexRGB:@"bebeb8"]:[UIColor colorFromHexRGB:@"efeedc"];
    
    [backgrdView release];
    
    
    AreaCrawl *area=self.list[indexPath.row];
    cell.textLabel.text=area.AreaName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        AreaCrawl *area=self.list[indexPath.row];
        ModifyAreaViewController *edit=[[ModifyAreaViewController alloc] init];
        edit.operateType=2;//修改
        edit.AreaId=area.SysID;
        [self.navigationController pushViewController:edit animated:YES];
        [edit release];
    }else{
        if (!self.removeList) {
            self.removeList=[NSMutableDictionary dictionary];
        }
        AreaCrawl *entity=self.list[indexPath.row];
        [self.removeList setValue:indexPath forKey:entity.SysID];
        [_toolBar.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"取消"]) {
        AreaCrawl *entity=self.list[indexPath.row];
        [self.removeList removeObjectForKey:entity.SysID];
        [_toolBar.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
@end
