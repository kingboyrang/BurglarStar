//
//  OfflineHelper.m
//  LocationService
//
//  Created by aJia on 2014/1/18.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "OfflineHelper.h"
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
@implementation OfflineHelper
#pragma mark 包大小转换工具类（将包大小转换成合适单位）
+(NSString *)getDataSizeString:(int) nSize
{
	NSString *string = nil;
	if (nSize<1024)
	{
		string = [NSString stringWithFormat:@"%dB", nSize];
	}
	else if (nSize<1048576)
	{
		string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
	}
	else if (nSize<1073741824)
	{
		if ((nSize%1048576)== 0 )
        {
			string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
		else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
	}
	else	// >1G
	{
		string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
	}
	
	return string;
}
+(void)viewerMapInView:(UIView*)view viewAction:(void(^)())viewerAct deleteAction:(void(^)())deleteAct{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    RIButtonItem *viewerBtn=[RIButtonItem item];
    viewerBtn.label=@"查看地图";
    viewerBtn.action=viewerAct;
    
    RIButtonItem *delBtn=[RIButtonItem item];
    delBtn.label=@"删除";
    delBtn.action=deleteAct;
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:viewerBtn,delBtn, nil];
    [sheet showInView:view];
    [sheet release];
}
+(void)viewerDownloadMapInView:(UIView *)view viewAction:(void (^)())viewerAct pauseAction:(void (^)())pauseAct deleteAction:(void (^)())deleteAct{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    RIButtonItem *viewerBtn=[RIButtonItem item];
    viewerBtn.label=@"查看地图";
    viewerBtn.action=viewerAct;
    
    RIButtonItem *pauseBtn=[RIButtonItem item];
    pauseBtn.label=@"暂停";
    pauseBtn.action=pauseAct;
    
    RIButtonItem *delBtn=[RIButtonItem item];
    delBtn.label=@"删除";
    delBtn.action=deleteAct;
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:viewerBtn,pauseBtn,delBtn, nil];
    [sheet showInView:view];
    [sheet release];
}
+(void)viewerDownloadMapInView:(UIView*)view viewAction:(void(^)())viewerAct pauseTitle:(NSString*)title pauseAction:(void(^)())pauseAct deleteAction:(void(^)())deleteAct{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    RIButtonItem *viewerBtn=[RIButtonItem item];
    viewerBtn.label=@"查看地图";
    viewerBtn.action=viewerAct;
    
    RIButtonItem *pauseBtn=[RIButtonItem item];
    pauseBtn.label=title;
    pauseBtn.action=pauseAct;
    
    RIButtonItem *delBtn=[RIButtonItem item];
    delBtn.label=@"删除";
    delBtn.action=deleteAct;
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:viewerBtn,pauseBtn,delBtn, nil];
    [sheet showInView:view];
    [sheet release];

}
@end
