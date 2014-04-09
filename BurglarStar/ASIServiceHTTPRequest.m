//
//  ASIServiceHTTPRequest.m
//  IOSWebservices
//
//  Created by aJia on 2014/4/2.
//  Copyright (c) 2014年 rang. All rights reserved.
//

#import "ASIServiceHTTPRequest.h"

@implementation ASIServiceHTTPRequest
@synthesize ServiceResult=_sr;
-(void)dealloc{
    if (_sr) {
        [_sr release],_sr=nil;
    }
    [self clearDelegatesAndCancel];
    [super dealloc];
}
+(ASIServiceHTTPRequest*)requestWithArgs:(ASIServiceArgs*)args{
    ASIServiceHTTPRequest *req=[ASIServiceHTTPRequest requestWithURL:[args requestURL]];
    //头部设置
    [req setRequestHeaders:(NSMutableDictionary*)[args headers]];
    //超时设置
    [req setTimeOutSeconds:args.timeOutSeconds];
    //访问方式
    [req setRequestMethod:args.httpWay==ASIServiceHttpGet?@"GET":@"POST"];
    //设置编码
    [req setDefaultResponseEncoding:NSUTF8StringEncoding];
    req.ServiceArgs=args;
    //body内容
    if (args.httpWay!=ASIServiceHttpGet) {
        [req appendPostData:[args.bodyMessage dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return req;
}
-(id)initWithArgs:(ASIServiceArgs*)args
{
    if (self=[super init]) {
        self.serviceArgs=args;
        _sr=nil;
        [self setURL:[args requestURL]];
        //头部设置
        [self setRequestHeaders:(NSMutableDictionary*)[args headers]];
        //超时设置
        [self setTimeOutSeconds:args.timeOutSeconds];
        //访问方式
        [self setRequestMethod:args.httpWay==ASIServiceHttpGet?@"GET":@"POST"];
        //设置编码
        [self setDefaultResponseEncoding:NSUTF8StringEncoding];
        //body内容
        if (args.httpWay!=ASIServiceHttpGet) {
            [self appendPostData:[args.bodyMessage dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return self;
}
- (void)setServiceArgs:(ASIServiceArgs *)args
{
    if (_ServiceArgs!=args) {
        [_ServiceArgs release];
        _ServiceArgs=[args retain];
        _sr=nil;
    }
}
-(ASIServiceResult*)ServiceResult
{
    if (_sr==nil) {
        _sr=[[ASIServiceResult instanceWithRequest:(ASIHTTPRequest*)self ServiceArgs:self.ServiceArgs] retain];
    }
    return _sr;
}
@end
