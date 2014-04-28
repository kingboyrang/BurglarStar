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
        _chkButton.hidden=YES;
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
    
    UIImage *placeImg=[UIImage createRoundedRectImage:[UIImage imageNamed:@"bg02.png"] size:CGSizeMake(70, 84) radius:8.0];
    [self.headImage setImageWithURL:[NSURL URLWithString:entity.Photo] forState:UIControlStateNormal placeholderImage:placeImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            UIImage *img=[UIImage createRoundedRectImage:image size:CGSizeMake(70, 84) radius:8.0];
            [self.headImage setImage:img forState:UIControlStateNormal];
        }
    }];
    //Photo
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat leftX=3;
    CGRect r=_chkButton.frame;
    if (!_chkButton.hidden) {//显示
        r.origin.x=leftX;
        _chkButton.frame=r;
        leftX+=26;
    }else{//隐藏
        r.origin.x=-30;
        _chkButton.hidden=YES;
        _chkButton.frame=r;
    }
    leftX+=2;
    r=_headImage.frame;
    r.origin.x=leftX;
    _headImage.frame=r;
    r=_labName.frame;
    r.origin.x=_headImage.frame.origin.x+_headImage.frame.size.width+3;
    _labName.frame=r;
    
}
- (void)dealloc {
    [_headImage release];
    [_labName release];
    [_arrowButton release];
    [_chkButton release];
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
