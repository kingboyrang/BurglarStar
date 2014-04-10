//
//  ReverseCoordinate.h
//  BurglarStar
//
//  Created by aJia on 2014/4/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ReverseCoordinate : NSObject{
    CLLocationCoordinate2D _coor;
}
+ (id)reverseWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D;
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D;
@end
