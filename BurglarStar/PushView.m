//
//  PushView.m
//  Wisdom
//
//  Created by aJia on 2013/11/4.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "PushView.h"
#import "PushDetail.h"
#import "Push.h"
#import "NSString+TPCategory.h"
#import "NetWorkConnection.h"
#import "Account.h"
#import "UIColor+TPCategory.h"
#import "TKPushDetailCell.h"
#import "ASIServiceHTTPRequest.h"
@interface PushView ()
-(void)loadData;
-(void)showInfoWithTitle:(NSString*)title;
-(void)showUpdateInfoWithTitle:(NSString*)title;
@end

@implementation PushView
-(void)dealloc{
    [super dealloc];
    [_tableView release],_tableView=nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView =[[PullingRefreshTableView alloc] initWithFrame:self.bounds pullingDelegate:self];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor clearColor];
        [self addSubview:_tableView];
       
        currentPage=0;
        pageSize=10;
        maxPage=0;
        self.infoType=1;
    }
    return self;
}
-(void)loadingSourceData{
    if (currentPage==0||self.isReload) {
        [_tableView launchRefreshing];
    }
}
-(void)reloadingSourceData{
    [self initParams];
    [self loadingSourceData];
}
-(void)initParams{
    currentPage=0;
    pageSize=10;
    maxPage=0;
}
-(void)showInfoWithTitle:(NSString*)title{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showMessageWithTitle:)]) {
        [self.delegate showMesssageWithTitle:title];
    }
}
-(void)showUpdateInfoWithTitle:(NSString*)title{
    [self showInfoWithTitle:title];
}
#pragma mark -
#pragma mark 加载数据
-(void)loadData{
    if (![NetWorkConnection IsEnableConnection]) {
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd  = NO;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showErrorNetWork)]) {
            [self.delegate showErrorNetWork];
        }
        return;
    }
    Account *acc=[Account unarchiverAccount];
    if (self.infoType==1&&!acc.isLogin) {
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd  = NO;
        [self showInfoWithTitle:@"当前未登陆,无法加载我的信息!"];
        return;
    }
    if (maxPage!=0&&currentPage>=maxPage) {
        currentPage=maxPage;
        [_tableView tableViewDidFinishedLoadingWithMessage:@"沒有了哦..."];
        _tableView.reachedTheEnd  = YES;
        return;
    }
    currentPage++;
    NSString *uid=@"";
    if (self.infoType==1&&acc.UserId&&[acc.UserId length]>0) {
        uid=acc.UserId;
    }
    if([uid length]==0&&self.infoType==1){
        currentPage--;
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd  = NO;
        [self showInfoWithTitle:@"我的信息!"];
        return;
    }
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",currentPage],@"start", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageSize],@"size", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataPushWebserviceURL;
    args.serviceNameSpace=DataPushNameSpace;
    args.methodName=@"GetPushs";
    args.soapParams=params;
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd  = NO;
        if (self.refreshing) {
            self.refreshing = NO;
        }
        if ([request.ServiceResult.xmlString length]==0) {
            currentPage--;
            [self showInfoWithTitle:@"没有信息哦!"];
            return;
        }
        NSString *xml=[request.ServiceResult.xmlString stringByReplacingOccurrencesOfString:request.ServiceResult.xmlnsAttr withString:@""];
        [request.ServiceResult.xmlParse setDataSource:xml];
        XmlNode *node=[request.ServiceResult.xmlParse soapXmlSelectSingleNode:@"//GetPushsResult"];
        if ([node.Value length]==0) {
            [self showInfoWithTitle:@"没有信息哦!"];
            return;
        }
        NSArray *arr=[node.Value componentsSeparatedByString:@"<;>"];
        int totalCount=[[arr objectAtIndex:0] intValue];
        maxPage=totalCount%pageSize==0?totalCount/pageSize:totalCount/pageSize+1;
        
        xml=[[arr objectAtIndex:1] stringByReplacingOccurrencesOfString:@"xmlns=\"Push[]\"" withString:@""];
        [request.ServiceResult.xmlParse setDataSource:xml];
        NSArray *source=[request.ServiceResult.xmlParse selectNodes:@"//Push" className:@"Push"];
        [self showUpdateInfoWithTitle:[NSString stringWithFormat:@"更新%d笔信息!",source.count]];
        
        
        if (currentPage==1) {
            NSMutableArray *sourceCells=[NSMutableArray array];
            for (int i=0; i<source.count; i++) {
                TKPushDetailCell *cell=[[TKPushDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                [sourceCells addObject:cell];
                [cell release];
            }
            self.cells=sourceCells;
            self.list=[NSMutableArray arrayWithArray:source];
            
            [_tableView reloadData];
        }else{
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:pageSize];
            for (int i=0; i<[source count]; i++) {
                [self.list addObject:[source objectAtIndex:i]];
                NSIndexPath *newPath=[NSIndexPath indexPathForRow:(currentPage-1)*pageSize+i inSection:0];
                [insertIndexPaths addObject:newPath];
                
                TKPushDetailCell *cell=[[TKPushDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                [self.cells addObject:cell];
                [cell release];
            }
            //重新呼叫UITableView的方法, 來生成行.
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
        }
    }];
    [request setFailedBlock:^{
        currentPage--;
        self.refreshing = NO;
        [_tableView tableViewDidFinishedLoading];
        [self showInfoWithTitle:@"没有信息哦!"];
    }];
    [request startAsynchronous];
}
#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TKPushDetailCell *cell=self.cells[indexPath.row];
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    Push *entity=self.list[indexPath.row];
    cell.detailView.labDate.text=[entity.PubDate Trim];
    cell.detailView.labMessage.text=[entity.Subject Trim];
    return cell;
    
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Push *entity=self.list[indexPath.row];
    CGSize size=[entity.Subject textSize:[UIFont boldSystemFontOfSize:14] withWidth:202];
    if (size.height>43){
        return 5+10+size.height+10+3+6;
    }
    return 77;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Push *entity=self.list[indexPath.row];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"详情"
                                                                message:[entity.Subject Trim]
                                                              delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
    
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
