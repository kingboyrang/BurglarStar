//
//  Push.m
//  Wisdom
//
//  Created by aJia on 2013/11/4.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "Push.h"
#import "AppHelper.h"
#import "NSDate+TPCategory.h"
@implementation Push

- (NSString*)Message{
    NSMutableString *msg=[NSMutableString stringWithFormat:@"尊敬的用户您好,你的车%@",[self Name]];
    [msg appendFormat:@"于%@至%@",[self StartTime],[self EndTime]];
    [msg appendFormat:@"出现%@异常",[self Content]];
    [msg appendFormat:@",持续%@,请您尽快处理,谢谢--------防盗之星.",[self TimeSpan]];
    return msg;
}
+ (NSArray*)jsonSerializationPushs:(NSString*)jsonStr{
    if (jsonStr&&[jsonStr length]>0) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
        NSArray *arr=[dic objectForKey:@"Person"];
        return [AppHelper arrayWithSource:arr className:@"Push"];
    }
    return nil;
}
- (NSString*)formatDateText{
    if (_CreateDate&&[_CreateDate length]>0) {
        NSDate *date=[NSDate dateFromString:_CreateDate withFormat:@"yyyy/MM/dd HH:mm:ss"];
        return [date stringWithFormat:@"yyyy/MM/dd"];
    }
    return @"";
}
@end
