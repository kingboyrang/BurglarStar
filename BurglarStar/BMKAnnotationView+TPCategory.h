//
//  BMKAnnotationView+TPCategory.h
//  LocationService
//
//  Created by aJia on 2014/1/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BMKAnnotationView.h"
#import "SupervisionPerson.h"
@interface BMKAnnotationView (TPCategory)
- (void)setPinImageWithEntity:(SupervisionPerson*)entity mapLevel:(float)level;
@end
