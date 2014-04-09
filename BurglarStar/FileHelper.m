//
//  FileHelper.m
//  Eland
//
//  Created by aJia on 13/10/4.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper
+(BOOL)existsFilePath:(NSString*)path{
   NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){ //如果不存在
        return NO;
    }
    return YES;
}
@end
