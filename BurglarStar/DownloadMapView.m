//
//  DownloadMapView.m
//  LocationService
//
//  Created by aJia on 2014/1/23.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "DownloadMapView.h"
#import "OfflineHelper.h"
#import "LoginButtons.h"
#import "RangHeader.h"
//#import "AppUI.h"
@interface DownloadMapView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    //int currentDownloadCityId;//当前正在下载的城市id
}
- (void)buttonPauseClick:(id)sender;
- (void)buttonDownloadClick:(id)sender;
- (void)buttonUpdateClick:(id)sender;
- (BOOL)isLoadingSection;
- (void)viewerDownloadWithEntity:(BMKOLSearchRecord*)entity withRow:(int)row;
- (void)viewerlocalMapWithEntity:(BMKOLUpdateElement*)entity withRow:(int)row;
- (BOOL)existsDownloadSourceByCityId:(int)cityId;
- (int)getDownloadMapRowWithCityId:(int)cityId;//获取下载行
- (NSMutableArray*)getUpdateMapsWithCompleted:(void(^)(NSMutableArray *indexPaths,NSMutableArray *delSource))completed;
@end

@implementation DownloadMapView
- (void)dealloc {
    [super dealloc];
    [_tableView release];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorFromHexRGB:@"e5e2d0"];
        CGRect r=self.bounds;
        r.size.height-=44.0;
        _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        [self addSubview:_tableView];
        
        LoginButtons *buttons=[[LoginButtons alloc] initWithFrame:CGRectMake(0,r.origin.y+r.size.height, self.bounds.size.width, 44)];
        [buttons setLeftButtonsWithCancelTitle:@"全部暂停" confirmTitle:@"全部下载"];
        [buttons.cancel addTarget:self action:@selector(buttonPauseClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttons.submit addTarget:self action:@selector(buttonDownloadClick:) forControlEvents:UIControlEventTouchUpInside];
        UIButton  *downBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        downBtn.frame=CGRectMake(self.bounds.size.width*2/3, buttons.cancel.frame.origin.y, self.bounds.size.width/3,buttons.cancel.frame.size.height);
        [downBtn setTitle:@"全部更新" forState:UIControlStateNormal];
        [downBtn setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateNormal];
        downBtn.titleLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        downBtn.showsTouchWhenHighlighted = YES;
        [downBtn addTarget:self action:@selector(buttonUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addSubview:downBtn];
        
        [self addSubview:buttons];
        [buttons release];

    }
    return self;
}
//返回操作
- (void)buttonHideView{
    if (self.backDelegate&&[self.backDelegate respondsToSelector:@selector(viewBackToControl:)]) {
        [self.backDelegate viewBackToControl:self];
    }
}
//添加地图下载
- (void)buttonAddClick{
    if (self.backDelegate&&[self.backDelegate respondsToSelector:@selector(viewToDownloadControl)]) {
        [self.backDelegate viewToDownloadControl];
    }
}
//添加一个城市地图下载
- (void)addMapDownloadItem:(BMKOLSearchRecord*)entity{
     if (!self.downloadMaps) {
         self.downloadMaps=[[NSMutableArray alloc] init];
     }
     [self.downloadMaps addObject:entity];
     if (self.downloadMaps.count==1) {
     //新增下载行
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
     
     [_tableView beginUpdates];
     [_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
     [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
     [_tableView endUpdates];
     if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadMapWithCityId:)]) {
        [self.delegate downloadMapWithCityId:entity.cityID];//开始下载地图
     }
      return;
     }
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.downloadMaps.count-1 inSection:0];
     [_tableView beginUpdates];
     [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
     [_tableView endUpdates];
}
//更新显示下载进度条
- (void)updateMapDownloadProcess:(BMKOLUpdateElement*)entity{
    int row=[self getDownloadMapRowWithCityId:entity.cityID];
    if (row!=-1) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
        [cell updateProgressInfo:entity];   
    }
}
//暂停地图下载时，更新状态
- (void)updateCellStatusWithCityId:(int)cityId{
    int row=[self getDownloadMapRowWithCityId:cityId];
    if (row!=-1) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
        cell.isPause=YES;
    }
}
//下载完成一项地图
- (void)finishedDownloadWithRow:(TKMapCell*)cell element:(BMKOLUpdateElement*)entity{
    self.currentDownloadCityId=-1;//下载完成
    
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    int sec=1;
    if (self.downloadMaps&&[self.downloadMaps count]==1) {
        [self.downloadMaps removeAllObjects];
        [_tableView beginUpdates];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        sec=0;
    }else{
        [self.downloadMaps removeObjectAtIndex:indexPath.row];
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
    [self.localMaps insertObject:entity atIndex:0];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:sec], nil] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView endUpdates];
    
    //执行下一个地图下载
    if ([self isLoadingSection]) {
        for (int i=0; i<self.downloadMaps.count; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
            if (!cell.isPause) {//未暂停
                BMKOLSearchRecord *entity=self.downloadMaps[i];
                if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadMapWithCityId:)]) {
                    [self.delegate downloadMapWithCityId:entity.cityID];
                }
                break;
            }
        }
    }
}
#pragma mark private Methods
//全部暂停
- (void)buttonPauseClick:(id)sender{
    if ([self isLoadingSection]&&self.currentDownloadCityId!=-1) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(pauseDownloadWithCityId:)]) {
            [self.delegate pauseDownloadWithCityId:self.currentDownloadCityId];
        }
    }
    if ([self isLoadingSection]) {
        for (int i=0; i<self.downloadMaps.count; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
            cell.isPause=YES;//暂停
        }
    }
}
//全部下载
- (void)buttonDownloadClick:(id)sender{
    if ([self isLoadingSection]) {
        for (int i=0; i<self.downloadMaps.count; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
            cell.isPause=NO;//取消暂停
        }
    }
    [self buttonUpdateClick:nil];
    if ([self isLoadingSection]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadMapWithCityId:)]) {
            if (self.currentDownloadCityId==-1) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
                self.currentDownloadCityId=cell.Entity.cityID;
            }
            [self.delegate downloadMapWithCityId:self.currentDownloadCityId];
        }
    }
    
}
//全部更新
- (void)buttonUpdateClick:(id)sender{
    NSMutableArray *result=[self getUpdateMapsWithCompleted:^(NSMutableArray *indexPaths, NSMutableArray *delSource) {
        [self.localMaps removeObjectsInArray:delSource];
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }];
    if (result!=nil&&[result count]>0) {
        if (!self.downloadMaps) {
            self.downloadMaps=[[NSMutableArray alloc] init];
        }
        //插入分区
        int start=self.downloadMaps.count;
        BOOL boo=NO;
        if (self.downloadMaps.count==0) {
            start=0;
            boo=YES;//判断是否添加选区
        }
        [self.downloadMaps addObjectsFromArray:result];
        NSMutableArray *indexPaths=[NSMutableArray array];
        for (int i=start;i<start+result.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:start inSection:0]];
        }
        [_tableView beginUpdates];
        if (boo) {
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
}
//取得有更新的地图
- (NSMutableArray*)getUpdateMapsWithCompleted:(void(^)(NSMutableArray *indexPaths,NSMutableArray *delSource))completed{
    if (self.localMaps&&[self.localMaps count]>0) {
        NSMutableArray *result=[NSMutableArray array];
        NSMutableArray *delSource=[NSMutableArray array];
        NSMutableArray *indexPaths=[NSMutableArray array];
        int sec=0;
        if ([self isLoadingSection]) {
            sec=1;
        }
        int total=0;
        for (BMKOLUpdateElement *item in self.localMaps) {
            BOOL boo=[self existsDownloadSourceByCityId:item.cityID];
            if (!boo&&item.update) {
                BMKOLSearchRecord *entity=[[BMKOLSearchRecord alloc] init];
                entity.cityID=item.cityID;
                entity.cityName=item.cityName;
                entity.size=item.size;
                [result addObject:entity];
                [entity release];
                
                [delSource addObject:item];
                [indexPaths addObject:[NSIndexPath indexPathForRow:total inSection:sec]];
            }
            total++;
        }
        if (completed) {
            completed(indexPaths,delSource);
        }
        return result;
    }
    return nil;
    
}
//获取下载行
- (int)getDownloadMapRowWithCityId:(int)cityId{
    if ([self isLoadingSection]) {
        NSString *match=[NSString stringWithFormat:@"SELF.cityID ==%d",cityId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.downloadMaps filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            return [self.downloadMaps indexOfObject:[results objectAtIndex:0]];
        }
    }
    return -1;
}
//判断更新项是否存在下载列表中
- (BOOL)existsDownloadSourceByCityId:(int)cityId{
    if ([self isLoadingSection]) {
        NSString *match=[NSString stringWithFormat:@"SELF.cityID ==%d",cityId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [self.downloadMaps filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            return YES;
        }
    }
    return NO;
}
//判断是否已下载的地图
- (BOOL)existslocalSourceByCityId:(int)cityId{
    BOOL boo=NO;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(existsLocalMapsWithCityId:)]) {
        boo=[self.delegate existsLocalMapsWithCityId:cityId];
    }
    return boo;
}
- (BOOL)isLoadingSection{
    if (self.downloadMaps&&[self.downloadMaps count]>0) {
        return YES;
    }
    return NO;
}
//判断是否所有的地图都暂停
- (BOOL)downloadMapsAllPause{
    BOOL boo=YES;
    for (int i=0; i<self.downloadMaps.count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
        if (!cell.isPause) {
            boo=NO;
            break;
        }
    }
    return boo;
}
//删除正在下载的地图
- (void)viewerDownloadWithEntity:(BMKOLSearchRecord*)entity withRow:(int)row{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    TKMapCell *cell=(TKMapCell*)[_tableView cellForRowAtIndexPath:indexPath];
    NSString *memo=cell.isPause?@"恢复下载":@"暂停";
    
    [OfflineHelper viewerDownloadMapInView:self viewAction:^{//查看地图
        if (self.delegate&&[self.delegate respondsToSelector:@selector(viewerMapWithCityId:)]) {
            [self.delegate viewerMapWithCityId:entity.cityID];
        }
    } pauseTitle:memo pauseAction:^{
        if ([memo isEqualToString:@"暂停"]) {//暂停下载
            if (self.delegate&&[self.delegate respondsToSelector:@selector(pauseDownloadWithCityId:)]) {
                [self.delegate pauseDownloadWithCityId:entity.cityID];
            }
        }else{//开始下载
            if (self.currentDownloadCityId!=-1) {//有正在下载地图
                cell.isPause=NO;//表示可以下载
                if (cell.Entity.cityID==self.currentDownloadCityId) {//表示当前暂停项等于当前的下载项
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadMapWithCityId:)]) {
                        [self.delegate downloadMapWithCityId:self.currentDownloadCityId];
                    }
                }
                
            }else{//没有正在下载地图
                if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadMapWithCityId:)]) {
                    [self.delegate downloadMapWithCityId:entity.cityID];
                }
            }
        }
    } deleteAction:^{//删除地图
        if (self.delegate&&[self.delegate respondsToSelector:@selector(removeMapWithCityId:)]) {
            [self.delegate removeMapWithCityId:entity.cityID];//删除正在下载的地图
        }
        //删除数据源与数据行
        BOOL boo=NO;
        if (entity.cityID==self.currentDownloadCityId) {
            boo=YES;
        }
        if (self.downloadMaps.count==1) {
            [self.downloadMaps removeAllObjects];
            [_tableView beginUpdates];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            self.currentDownloadCityId=-1;
        }else{
            [self.downloadMaps removeObjectAtIndex:row];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
        }
        //删除正在下载的离线地图
        if (boo&&[self isLoadingSection]) {
            BMKOLSearchRecord *item=self.downloadMaps[0];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadMapWithCityId:)]) {
                [self.delegate downloadMapWithCityId:item.cityID];
            }
        }
    }];
}
//查看或删除已下载的地图
- (void)viewerlocalMapWithEntity:(BMKOLUpdateElement*)entity withRow:(int)row{
    [OfflineHelper viewerMapInView:self viewAction:^{//查看地图
        if(self.delegate&&[self.delegate respondsToSelector:@selector(viewerMapWithCityId:)])
        {
            [self.delegate viewerMapWithCityId:entity.cityID];
        }
        
    } deleteAction:^{//删除
        int sec=0;
        if ([self isLoadingSection]) {
            sec=1;
        }
        //删除数据源
        [self.localMaps removeObjectAtIndex:row];
        //删除离线包
        if (self.delegate&&[self.delegate respondsToSelector:@selector(removeMapWithCityId:)]) {
            [self.delegate removeMapWithCityId:entity.cityID];
        }
        //更新资料行
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:sec], nil] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }];
}
#pragma mark tableView datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self isLoadingSection]) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self isLoadingSection]) {
        if (section==0) {
            return [self.downloadMaps count];
        }
    }
    return  [self.localMaps count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1=@"downloadmapcell";
    if ([self isLoadingSection]) {
        if (indexPath.section==0) {
            TKMapCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell==nil||[cell isKindOfClass:[UITableViewCell class]]) {
                cell=[[[TKMapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1] autorelease];
                cell.controlers=self;
                cell.backgroundColor=[UIColor clearColor];
            }
            BMKOLSearchRecord *entity=self.downloadMaps[indexPath.row];
            [cell setDataSource:entity];
            return cell;
        }
    }
    static NSString *cellIdentifier=@"mapcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil||[cell isKindOfClass:[TKMapCell class]]) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor=[UIColor clearColor];
    }
    BMKOLUpdateElement* item = [self.localMaps objectAtIndex:indexPath.row];
    
    NSString *memo=item.update?[NSString stringWithFormat:@"有更新包 %@",[OfflineHelper getDataSizeString:item.serversize]]:@"完成";
    CGSize size=[memo textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.bounds.size.width];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)", item.cityName, item.cityID];
    cell.textLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    cell.textLabel.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    UILabel *sizelabel =[[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-10-size.width, 0, size.width, size.height)]autorelease];
    sizelabel.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
    sizelabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    sizelabel.text = memo;
    sizelabel.textColor=item.update?[UIColor blueColor]:[UIColor colorFromHexRGB:DeviceFontColorName];
    sizelabel.backgroundColor = [UIColor clearColor];
    cell.accessoryView = sizelabel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title=@"已下载";
    if ([self isLoadingSection]) {
        if (section==0) {
            title=@"正在下载";
        }
    }
    RangHeader *header1=[[[RangHeader alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 35)] autorelease];
    [header1 setLeftTopTitle:title];
    
    return header1;
}
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isLoadingSection]) {
        if (indexPath.section==0) {
            BMKOLSearchRecord *entity=self.downloadMaps[indexPath.row];
            [self viewerDownloadWithEntity:entity withRow:indexPath.row];
        }else{
            BMKOLUpdateElement *entity=self.localMaps[indexPath.row];
            [self viewerlocalMapWithEntity:entity withRow:indexPath.row];
        }
    }else{
        BMKOLUpdateElement *entity=self.localMaps[indexPath.row];
        [self viewerlocalMapWithEntity:entity withRow:indexPath.row];
    }
}
@end
