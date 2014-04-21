//
//  ReadMessageViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/13.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ReadMessageViewController.h"
#import "ToolBarView.h"
#import "MessageCell.h"
#import "TrajectoryMessage.h"
#import "AppHelper.h"
#import "ExceptionViewController.h"
#import "AlertHelper.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
@interface ReadMessageViewController (){
   ToolBarView *_toolBar;
}
- (BOOL)existsFindyById:(NSString*)msgId;
- (void)loadData;
- (NSString*)findByMessageId:(NSString*)msgId;
- (void)deleteMessagesWithButton:(UIButton*)btn;
@end

@implementation ReadMessageViewController
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
    self.title=[NSString stringWithFormat:@"%@--信息",self.Entity.Name];
    
    UIBarButtonItem *rightBtn=[UIBarButtonItem barButtonWithTitle:@"编辑" target:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    
    _tableView =[[PullingRefreshTableView alloc] initWithFrame:r pullingDelegate:self];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    CGFloat topY=_tableView.frame.size.height+_tableView.frame.origin.y+44;
    _toolBar=[[ToolBarView alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];
    [_toolBar.button addTarget:self action:@selector(buttonRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBar];
    
    curPage=0;
    pageSize=10;
}
//编辑
- (void)buttonEditClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [_tableView setEditing:!_tableView.editing animated:YES];
    if(_tableView.editing){//编辑
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
	else {//取消
        if (self.removeList&&[self.removeList count]>0) {
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
//删除信息
- (void)deleteMessagesWithButton:(UIButton*)btn{
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
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"DelPersonMsg";
    args.soapParams=params;
    //NSLog(@"soap=%@",args.soapMessage);
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
                [self.removeList removeAllObjects];
                [_toolBar.button setTitle:@"删除(0)" forState:UIControlStateNormal];//更新操作
                [self hideLoadingSuccessWithTitle:@"删除成功!" completed:nil];
                
                [_tableView reloadData];//重新加载
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
    if (self.removeList&&[self.removeList count]>0) {
        UIButton *btn=(UIButton*)sender;
        [AlertHelper confirmWithTitle:@"删除" confirm:^{
            [self deleteMessagesWithButton:btn];
        } innnerView:self.view];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    args.methodName=@"GetPersonDealAlarmDataPage";
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
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"messageCell";
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        //cell.monitorView.controler=self;
    }
    TrajectoryMessage *entity=self.cells[indexPath.row];
    [cell.messageView setDataSource:entity indexPathRow:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrajectoryMessage *entity=self.cells[indexPath.row];
    if (entity.Address&&[entity.Address length]>0) {
        CGSize size=[entity.Address textSize:[UIFont systemFontOfSize:12] withWidth:253];
        if (size.height>15) {
            return 65+size.height-15;
        }
    }
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ExceptionViewController *control=[[ExceptionViewController alloc] init];
        control.Entity=self.cells[indexPath.row];
        [self.navigationController pushViewController:control animated:YES];
        [control release];
    }else{
        if (!self.removeList) {
            self.removeList=[NSMutableDictionary dictionary];
        }
        TrajectoryMessage *entity=self.cells[indexPath.row];
        [self.removeList setValue:indexPath forKey:entity.ID];
        [_toolBar.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIBarButtonItem *barButton=[self.navigationItem.rightBarButtonItems objectAtIndex:0];
    UIButton *btn=(UIButton*)barButton.customView;
    if ([btn.currentTitle isEqualToString:@"取消"]) {
        TrajectoryMessage *entity=self.cells[indexPath.row];
        [self.removeList removeObjectForKey:entity.ID];
        [_toolBar.button setTitle:[NSString stringWithFormat:@"删除(%d)",self.removeList.count] forState:UIControlStateNormal];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
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
