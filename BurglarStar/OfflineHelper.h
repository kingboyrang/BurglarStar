//
//  OfflineHelper.h
//  LocationService
//
//  Created by aJia on 2014/1/18.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfflineHelper : NSObject
+(NSString *)getDataSizeString:(int) nSize;
+(void)viewerMapInView:(UIView*)view viewAction:(void(^)())viewerAct deleteAction:(void(^)())deleteAct;
+(void)viewerDownloadMapInView:(UIView*)view viewAction:(void(^)())viewerAct pauseAction:(void(^)())pauseAct deleteAction:(void(^)())deleteAct;
+(void)viewerDownloadMapInView:(UIView*)view viewAction:(void(^)())viewerAct pauseTitle:(NSString*)title pauseAction:(void(^)())pauseAct deleteAction:(void(^)())deleteAct;
@end
