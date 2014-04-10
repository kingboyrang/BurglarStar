//
//  AdModel.m
//  Wisdom
//
//  Created by aJia on 2013/10/29.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "AdModel.h"

@implementation AdModel
+(NSMutableArray*)sourceModels{
    NSString *name=@"",*path=@"";
    NSMutableArray *arr=[NSMutableArray array];
    for (int i=1;i<5;i++) {
        name=[NSString stringWithFormat:@"top_00%d",i];
        path=[[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        AdModel *item=[[[AdModel alloc] init] autorelease];
        item.advertName=@"";
        item.thumb=path;
        item.webURl=[NSString stringWithFormat:@"http://www.ibdcloud.com/APP/top_00%d.htm",i];
        [arr addObject:item];
    }
    return arr;
}
@end
