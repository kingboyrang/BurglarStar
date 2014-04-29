//
//  TrajectoryMessageController.m
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TrajectoryMessageController.h"
#import "MessageCell.h"
#import "TrajectoryMessage.h"
#import "LoginButtons.h"
#import "Account.h"
#import "AppHelper.h"
#import "ReadMessageViewController.h"
#import "ExceptionViewController.h"
#import "AlertHelper.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
@interface TrajectoryMessageController (){
    LoginButtons *_toolBar;
    LoginButtons *_confirmBar;
    int operType;//1:表示删除 2:表示已读
}
- (void)loadData;
- (void)buttonEditClick:(id)sender;
- (void)buttonRemoveClick:(id)sender;
- (void)buttonReadClick:(id)sender;
- (BOOL)existsFindyById:(NSString*)msgId;
- (NSString*)findByMessageId:(NSString*)msgId;
- (BOOL)showCheckedFindById:(NSString*)areaId;
- (void)flagReadButton:(UIButton*)btn;
- (void)flagDeleteButton:(UIButton*)btn;
@end

@implementation TrajectoryMessageController
- (void)dealloc{
    [super dealloc];
    [_toolBar release];
    [_confirmBar release];
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
   
    if (curPage==0) {
        if (self.Entity&&self.Entity.ID&&[self.Entity.ID length]>0) {
            [_tableView launchRefreshing];
        }else{
            if (self.cells&&[self.cells count]>0) {
                [self.cells removeAllObjects];
            }else{
                self.cells=[NSMutableArray array];
            }
            [_tableView reloadData];
        }
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"最新信息";
    //self.title=[NSString stringWithFormat:@"%@-最新信息",self.Entity.Name];
    UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"历史"  target:self action:@selector(buttonHistoryClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2=[UIBarButtonItem barButtonWithTitle:@"编辑"  target:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *actionButtonItems = [NSArray arrayWithObjects:btn2,btn1, nil];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    
    _tableView =[[PullingRefreshTableView alloc] initWithFrame:r pullingDelegate:self];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    CGFloat topY=r.size.height+r.origin.y+44;
     _confirmBar=[[LoginButtons alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [_confirmBar.cancel addTarget:self action:@selector(buttonCancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBar.submit addTarget:self action:@selector(buttonSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBar];
    
    _toolBar=[[LoginButtons alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [_toolBar.cancel setTitle:@"删除(0)" forState:UIControlStateNormal];
    [_toolBar.submit setTitle:@"标记已读(0)" forState:UIControlStateNormal];
    [_toolBar.cancel addTarget:self action:@selector(buttonRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar.submit addTarget:self action:@selector(buttonReadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBar];
   
    operType=-1;
    curPage=0;
    pageSize=10;
}
//取消
- (void)buttonCancleClick:(UIButton*)btn{
    [self.view sendSubviewToBack:_confirmBar];
}
//确认
- (void)buttonSubmitClick:(UIButton*)btn{
    if (operType==1) {
        [self flagDeleteButton:btn];
    }
    if (operType==2) {
        [self flagReadButton:btn];
    }
}
//进入已读取信息列表
- (void)buttonHistoryClick{
    ReadMessageViewController *read=[[ReadMessageViewController alloc] init];
    read.Entity=self.Entity;
    [self.navigationController pushViewController:read animated:YES];
    [read release];
}
- (void)receiveParams:(SupervisionPerson*)entity{
    self.Entity=entity;
    curPage=0;
    pageSize=10;
}
- (BOOL)canShowMessage{
    if (self.Entity&&self.Entity.ID&&[self.Entity.ID length]>0) {
        return YES;
    }
    return NO;
}
- (BOOL)existsFindyById:(NSString*)msgId{
    if (self.cells&&[self.cells count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.ID =='%@'",msgId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.cells filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            return YES;
        }
    }
    return NO;
}
- (NSString*)findByMessageId:(NSString*)msgId{
    if (self.cells&&[self.cells count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.ID =='%@'",msgId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.cells filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            TrajectoryMessage *item=[results objectAtIndex:0];
            return item.PCTime;
        }
    }
    return @"";
}
//标记已读信息
- (void)flagReadButton:(UIButton*)btn{
    btn.enabled=NO;
    NSMutableArray *delSource=[NSMutableArray array];
    for (NSIndexPath *item in [self.removeList allValues]) {
        [delSource addObject:self.cells[item.row]];
    }
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"BatchHandleAlarmData";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[self.readList.allKeys componentsJoinedByString:@","],@"id", nil], nil];
    [self showLoadingAnimatedWithTitle:@"正在标记已读操作,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        btn.enabled=YES;
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=(NSDictionary*)[request.ServiceResult json];
            if (dic!=nil&&[[dic objectForKey:@"Result"] isEqualToString:@"true"]) {
                boo=YES;
            }
        }
        if (boo) {
            [self.cells removeObjectsInArray:delSource];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:[self.readList allValues] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            
            [self.readList removeAllObjects];
            [self.removeList removeAllObjects];
            [_toolBar.submit setTitle:@"标记已读(0)" forState:UIControlStateNormal];//更新操作
            [_toolBar.cancel setTitle:@"删除(0)" forState:UIControlStateNormal];//更新操作
            [self hideLoadingSuccessWithTitle:@"标记已读操作成功!" completed:nil];
            [self.view sendSubviewToBack:_confirmBar];
            [_tableView reloadData];//重新加载
            operType=-1;
        }else{
            [self hideLoadingFailedWithTitle:@"标记已读操作失败!" completed:nil];
        }
        
    }];
    [request setFailedBlock:^{
        btn.enabled=YES;
        [self hideLoadingFailedWithTitle:@"标记已读操作失败!" completed:nil];
    }];
    [request startAsynchronous];
}
//删除未读信息
- (void)flagDeleteButton:(UIButton*)btn{
    btn.enabled=NO;
    NSMutableArray *delSource=[NSMutableArray array];
    for (NSIndexPath *item in [self.removeList allValues]) {
        [delSource addObject:self.cells[item.row]];
    }
    
    NSMutableArray *ids=[NSMutableArray array];
    for (NSString *msgid in self.removeList.allKeys) {
        [ids addObject:[NSString stringWithFormat:@"%@,%@",msgid,[self findByMessageId:msgid]]];
    }
    
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[ids componentsJoinedByString:@"$"],@"idAndTime", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil]];
    //[params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"time", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"DelPersonMsg";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"正在删除,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
         btn.enabled=YES;
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic!=nil&&[[dic objectForKey:@"Result"] isEqualToString:@"true"]) {
                boo=YES;
                [self.cells removeObjectsInArray:delSource];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:[self.removeList allValues] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                //更新操作
                [self.readList removeAllObjects];
                [self.removeList removeAllObjects];
                [_toolBar.submit setTitle:@"标记已读(0)" forState:UIControlStateNormal];//更新操作
                [_toolBar.cancel setTitle:@"删除(0)" forState:UIControlStateNormal];//更新操作
                [self hideLoadingSuccessWithTitle:@"删除成功!" completed:nil];
                [self.view sendSubviewToBack:_confirmBar];
                [_tableView reloadData];//重新加载
                operType=-1;
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
- (void)buttonRemoveClick:(id)sender{
    operType=-1;
    if (self.removeList&&[self.removeList count]>0) {
        operType=1;
        [self.view bringSubviewToFront:_confirmBar];
    }
}
//标记已读
- (void)buttonReadClick:(id)sender{
     operType=-1;
    if (self.readList&&[self.readList count]>0) {
         operType=2;
        [self.view bringSubviewToFront:_confirmBar];
    }
}
//编辑
- (void)buttonEditClick:(id)sender{
    CGRect r1=_tableView.frame;
    CGRect r=_toolBar.frame;
    UIButton *btn=(UIButton*)sender;
    BOOL boo=NO;
    if([btn.currentTitle isEqualToString:@"编辑"]){//编辑
        boo=YES;
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        r.origin.y=r1.size.height+r1.origin.y-r.size.height;
        r1.size.height-=r.size.height;
    }
	else {//取消
        if (self.readList&&[self.readList count]>0) {
            [self.readList removeAllObjects];
        }
        if (self.removeList&&[self.removeList count]>0) {
            [self.removeList removeAllObjects];
        }
        [_toolBar.submit setTitle:@"标记已读(0)" forState:UIControlStateNormal];
        [_toolBar.cancel setTitle:@"删除(0)" forState:UIControlStateNormal];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.view sendSubviewToBack:_confirmBar];
        r.origin.y+=r.size.height;
        r1.size.height+=r.size.height;
    }
    if (self.cells&&[self.cells count]>0) {
        for (NSInteger i=0;i<self.cells.count;i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            MessageCell *cell=(MessageCell*)[_tableView cellForRowAtIndexPath:indexPath];
            if (boo) {
                [cell mSelectedState:NO];
            }else{
                [cell changeMSelectedState];
            }
        }
    }
    [UIView animateWithDuration:0.5f animations:^(){
        _confirmBar.frame=r;
        _toolBar.frame=r;
        _tableView.frame=r1;
    } completion:^(BOOL finished) {
        if (finished) {
            [_tableView reloadData];
        }
    }];

}
//加载数据
- (void)loadData{
    //表示网络未连接
    if (![self hasNetWork]) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    curPage++;
    
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"workno", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"personid", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",curPage],@"curPage", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageSize],@"pageSize", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetPersonAlarmDataPage";
    args.soapParams=params;
     ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd  = NO;
        if (self.refreshing) {
            self.refreshing = NO;
        }
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic!=nil) {
                NSArray *source=[dic objectForKey:@"Person"];
                NSArray *list=[AppHelper arrayWithSource:source className:@"TrajectoryMessage"];
                if (list&&[list count]>0) {
                    boo=YES;
                    if (curPage==1) {
                        self.cells=[NSMutableArray arrayWithArray:list];
                        [_tableView reloadData];
                        [self showSuccessViewWithHide:^(AnimateErrorView *successView) {
                            successView.labelTitle.text=[NSString stringWithFormat:@"更新%d笔信息!",list.count];
                        } completed:nil];
                    }else{
                        NSMutableArray *insertIndexPaths = [NSMutableArray array];
                        int total=0;
                        NSInteger s=self.cells.count;
                        for (int i=0; i<[list count]; i++) {
                            TrajectoryMessage *entity=list[i];
                            if ([self existsFindyById:entity.ID]) {continue;}
                            [self.cells addObject:[list objectAtIndex:i]];
                            NSIndexPath *newPath=[NSIndexPath indexPathForRow:s+total inSection:0];
                            [insertIndexPaths addObject:newPath];
                            total++;
                        }
                        [self showSuccessViewWithHide:^(AnimateErrorView *successView) {
                            successView.labelTitle.text=[NSString stringWithFormat:@"更新%d笔信息!",insertIndexPaths.count];
                        } completed:nil];
                        //重新呼叫UITableView的方法, 來生成行.
                        [_tableView beginUpdates];
                        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                        [_tableView endUpdates];
                        [self showSuccessViewWithHide:^(AnimateErrorView *successView) {
                            successView.labelTitle.text=[NSString stringWithFormat:@"更新%d笔信息!",insertIndexPaths.count];
                        } completed:nil];
                    }
                }
                
            }
        }
        if (!boo) {
            curPage--;
            [self showErrorViewWithHide:^(AnimateErrorView *errorView) {
                errorView.labelTitle.text=@"没有更新信息哦!";
                errorView.backgroundColor=[UIColor colorFromHexRGB:@"0e4880"];
            } completed:nil];
        }
    }];
    [request setFailedBlock:^{
        curPage--;
        [self showErrorViewWithHide:^(AnimateErrorView *errorView) {
            errorView.labelTitle.text=@"没有更新信息哦!";
            errorView.backgroundColor=[UIColor colorFromHexRGB:@"0e4880"];
        } completed:nil];
    }];
    [request startAsynchronous];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)showCheckedFindById:(NSString*)areaId{
    if (self.removeList&&[self.removeList count]>0) {
        if ([self.removeList.allKeys containsObject:areaId]) {
            return YES;
        }
    }
    return NO;
}
//页面跳转
- (void)buttonSkipClick:(UIButton*)btn{
    id v=[btn superview];
    while (![v isKindOfClass:[UITableViewCell class]]) {
        v=[v superview];
    }
    UITableViewCell *cell=(UITableViewCell*)v;
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    TrajectoryMessage *entity=self.cells[indexPath.row];
    ExceptionViewController *control=[[ExceptionViewController alloc] init];
    control.flagRead=YES;
    control.Entity=entity;
    [self.navigationController pushViewController:control animated:YES];
    [control release];
    //删除行
    if (self.removeList&&[self.removeList count]>0&&[self.removeList.allKeys containsObject:entity.ID]) {
        [self.removeList removeObjectForKey:entity.ID];
    }
    if (self.readList&&[self.readList count]>0&&[self.readList.allKeys containsObject:entity.ID]) {
        [self.readList removeObjectForKey:entity.ID];
    }
    [self.cells removeObjectAtIndex:indexPath.row];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [_tableView reloadData];//重新加载
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
    if (!self.removeList) {
        self.removeList=[NSMutableDictionary dictionary];
    }
    if (!self.readList) {
        self.readList=[NSMutableDictionary dictionary];
    }
    TrajectoryMessage *entity=self.cells[indexPath.row];
    if (btn.selected) {//选中
        [self.removeList setValue:indexPath forKey:entity.ID];
        [self.readList setValue:indexPath forKey:entity.ID];
        [_toolBar.cancel setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
        [_toolBar.submit setTitle:[NSString stringWithFormat:@"标记已读(%d)",self.readList.count] forState:UIControlStateNormal];
    }else{//不选中
        [self.removeList removeObjectForKey:entity.ID];
        [self.readList removeObjectForKey:entity.ID];
        [_toolBar.cancel setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
        [_toolBar.submit setTitle:[NSString stringWithFormat:@"标记已读(%d)",self.readList.count] forState:UIControlStateNormal];
    }
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"messageCell";
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.messageView.buttonArrow addTarget:self action:@selector(buttonSkipClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messageView.chkButton addTarget:self action:@selector(buttonChkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.backgroundColor=[UIColor clearColor];
    TrajectoryMessage *entity=self.cells[indexPath.row];
    [cell.messageView setDataSource:entity indexPathRow:indexPath.row];
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {//隐藏
        [cell changeMSelectedState];
    }else{//显示
        [cell mSelectedState:[self showCheckedFindById:entity.ID]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrajectoryMessage *entity=self.cells[indexPath.row];
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    BOOL boo=[btn.currentTitle isEqualToString:@"编辑"]?NO:YES;
    return [entity getRowHeight:self.view.bounds.size.width showChecked:boo];
}
#pragma mark - PullingRefreshTableViewDelegate
//下拉加载
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}
//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}
#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableView tableViewDidEndDragging:scrollView];
}
@end
