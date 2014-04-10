//
//  ReverseCoordinate.m
//  BurglarStar
//
//  Created by aJia on 2014/4/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ReverseCoordinate.h"

@interface ReverseCoordinate ()
//@property (nonatomic,retain) MKReverseGeocoder *reverseGeocoder;
@end

@implementation ReverseCoordinate
+ (id)reverseWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D
{
    return [[[self alloc] initWithCoordinate2D:coordinate2D] autorelease];
}
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D
{
    if (self=[super init]) {
        _coor=coordinate2D;
        //self.reverseGeocoder=[[MKReverseGeocoder alloc] init];
        
    }
    return self;
}
@end
