//
//  BMKAnnotationView+TPCategory.m
//  LocationService
//
//  Created by aJia on 2014/1/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BMKAnnotationView+TPCategory.h"
#import "UIImage+TPCategory.h"
#import "PinView.h"

@implementation BMKAnnotationView (TPCategory)
- (void)setPinImageWithEntity:(SupervisionPerson*)entity mapLevel:(float)level{
    if (level<6) {
        self.image=[UIImage imageNamed:@"circule.png"];
         [self setNeedsDisplay];
    }else{ 
        PinView *bgView=[[[PinView alloc] initWithFrame:CGRectMake(0, 0, 90, 174)] autorelease];
        self.image=[bgView getPinImageWithSource:entity];
        [self setNeedsDisplay];
        [bgView setDataSource:entity completed:^(UIImage *image) {
             self.image=image;
            [self setNeedsDisplay];
        }];
    }
}
@end
