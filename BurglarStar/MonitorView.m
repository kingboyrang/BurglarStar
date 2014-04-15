//
//  MonitorView.m
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "MonitorView.h"
#import "UIButton+WebCache.h"
#import "UIImage+TPCategory.h"
@implementation MonitorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDataSource:(SupervisionPerson*)entity indexPathRow:(NSInteger)row{
    self.Entity=entity;
    
    //CGSize size=[entity.Name textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:68];
    self.labName.text=entity.Name;
    self.labName.font=[UIFont fontWithName:DeviceFontName size:12];
    self.labName.textColor=[UIColor blackColor];
    self.labName.numberOfLines=0;
    self.labName.lineBreakMode=NSLineBreakByWordWrapping;
    
    if (row%2==0) {
        [self.arrowButton setImage:[UIImage imageNamed:@"arrow_right_n.png"] forState:UIControlStateNormal];
        self.backgroundColor=[UIColor colorFromHexRGB:@"efeedc"];
        self.labName.textColor=[UIColor colorFromHexRGB:@"252930"];
        
    }else{
        [self.arrowButton setImage:[UIImage imageNamed:@"arrow_right_s.png"] forState:UIControlStateNormal];
        self.backgroundColor=[UIColor colorFromHexRGB:@"bebeb8"];
        self.labName.textColor=[UIColor colorFromHexRGB:@"eae7d1"];
    }
    
    /***
    CGRect r=self.labName.frame;
    r.size=size;
    r.origin.y=(self.frame.size.height-size.height)/2;
    self.labName.frame=r;
    
    NSLog(@"r=%@",NSStringFromCGRect(r));
     ***/
    
   
    [self.headImage setImageWithURL:[NSURL URLWithString:entity.Photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg02.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            if (image.size.width>70||image.size.height>84) {
                [self.headImage setImage:[image imageByScalingToSize:CGSizeMake(70, 84)] forState:UIControlStateNormal];
            }else{
               [self.headImage setImage:image forState:UIControlStateNormal];
            }
        }
    }];
    //Photo
}

- (void)dealloc {
    [_headImage release];
    [_labName release];
    [_arrowButton release];
    [super dealloc];
}
- (IBAction)buttonEditHead:(id)sender {
    SEL sel=NSSelectorFromString(@"supervisionEditHeadWithEntity:");
    if (self.controler&&[self.controler respondsToSelector:sel]) {
        [self.controler performSelector:sel withObject:self.Entity];
    }
}

- (IBAction)buttonMessageClick:(id)sender {
    SEL sel=NSSelectorFromString(@"supervisionMessageWithEntity:");
    if (self.controler&&[self.controler respondsToSelector:sel]) {
        [self.controler performSelector:sel withObject:self.Entity];
    }
}

- (IBAction)buttonTrajectoryClick:(id)sender {
    SEL sel=NSSelectorFromString(@"supervisionTrajectoryWithEntity:");
    if (self.controler&&[self.controler respondsToSelector:sel]) {
        [self.controler performSelector:sel withObject:self.Entity];
    }
}

- (IBAction)buttonCallClick:(id)sender {
    SEL sel=NSSelectorFromString(@"supervisionCallWithEntity:");
    if (self.controler&&[self.controler respondsToSelector:sel]) {
        [self.controler performSelector:sel withObject:self.Entity];
    }
}
@end
