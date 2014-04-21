//
//  SOSMessage.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "SOSMessage.h"
#import "NSDate+TPCategory.h"
@implementation SOSMessage
- (NSString*)formatDateText{
    if (_CreateDate&&[_CreateDate length]>0) {
        NSDate *date=[NSDate dateFromString:_CreateDate withFormat:@"yyyy/MM/dd HH:mm:ss"];
        return [date stringWithFormat:@"yyyy/MM/dd"];
    }
    return @"";
}

+ (NSArray*)jsonSerializationSOSMessages:(NSString*)jsonStr
{
   
    if (jsonStr&&[jsonStr length]>0) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
         NSLog(@"dic class=%@",[dic class]);
         NSLog(@"dic=%@",dic);
        NSArray *arr=[dic objectForKey:@"SosList"];
         NSLog(@"class=%@",[arr class]);
         NSLog(@"arr=%@",arr);
        if (arr&&[arr count]>0) {
            NSMutableArray *source=[NSMutableArray arrayWithCapacity:arr.count];
            for (NSDictionary *item in arr) {
                SOSMessage *entity=[[SOSMessage alloc] init];
                entity.SOSPKID=[item objectForKey:@"SOSPKID"];
                entity.CompanyName=[item objectForKey:@"CompanyName"];
                entity.carID=[item objectForKey:@"carID"];
                entity.CarNo=[item objectForKey:@"CarNo"];
                entity.CreateDate=[item objectForKey:@"CreateDate"];
                entity.Image=[item objectForKey:@"Image"];
                entity.Status=[item objectForKey:@"Status"];
                [source addObject:entity];
                [entity release];
            }
            return source;
        }
    }
    return nil;
}
@end
