//
//  PinView.m
//  LocationService
//
//  Created by aJia on 2014/1/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "PinView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+TPCategory.h"
#import <QuartzCore/QuartzCore.h>

@interface PinView ()
-(bool)checkDevice:(NSString*)name;
@end

@implementation PinView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //字体为14 高度为18
        
        self.backgroundColor=[UIColor clearColor];
        CGFloat topY=0;
        _label=[[UILabel alloc] initWithFrame:CGRectMake(0, topY,frame.size.width,20)];
        _label.font=[UIFont boldSystemFontOfSize:16];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.textColor=[UIColor blackColor];
        _label.numberOfLines=0;
        _label.lineBreakMode=NSLineBreakByWordWrapping;
        [self addSubview:_label];
        
        topY=20;
         UIImage *image1=[UIImage imageNamed:@"bg02.png"];
        _headView=[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image1.size.width)/2, topY, image1.size.width, image1.size.height)];
        [_headView setImage:image1];
        [self addSubview:_headView];
        
        //topY+=image1.size.height-10;
        topY+=image1.size.height;
        UIImage *image2=[UIImage imageNamed:@"pinArrow_r.png"];
        _circuleView=[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image2.size.width)/2, topY, image2.size.width, image2.size.height)];
        [_circuleView setImage:image2];
        [self addSubview:_circuleView];
        [self sendSubviewToBack:_circuleView];
        
    }
    return self;
}
- (UIImage*)getPinImageWithSource:(SupervisionPerson*)entity{
    CGSize size=[entity.Name textSize:[UIFont boldSystemFontOfSize:16] withWidth:self.frame.size.width];
    _label.text=entity.Name;
    if (size.height>20) {
        CGRect r=_label.frame;
        r.size.height=size.height;
        _label.frame=r;
        
        r=_headView.frame;
        r.origin.y=size.height;
        _headView.frame=r;
        
        r=_circuleView.frame;
        //r.origin.y=_headView.frame.origin.y+_headView.frame.size.height-10;
        r.origin.y=_headView.frame.origin.y+_headView.frame.size.height;
        _circuleView.frame=r;
        
        r=self.frame;
        //r.size.height=_circuleView.frame.origin.y+_circuleView.frame.size.height-10;
        r.size.height=_circuleView.frame.origin.y+_circuleView.frame.size.height;
        self.frame=r;
    }
    if ([self checkDevice:@"iPad"]) {//如果为ipad
        UIImage *image=[UIImage getImageFromView:self];
        return [image imageByScalingToSize:CGSizeMake(image.size.width/2, image.size.height/2)];
    }
    return [UIImage getImageFromView:self];
}
- (void)setDataSource:(SupervisionPerson*)entity completed:(void(^)(UIImage *image))finished{
    CGSize size=[entity.Name textSize:[UIFont boldSystemFontOfSize:16] withWidth:self.frame.size.width];
    _label.text=entity.Name;
    if (size.height>20) {
        CGRect r=_label.frame;
        r.size.height=size.height;
        _label.frame=r;
        
        r=_headView.frame;
        r.origin.y=size.height;
        _headView.frame=r;
        
        r=_circuleView.frame;
        //r.origin.y=_headView.frame.origin.y+_headView.frame.size.height-10;
         r.origin.y=_headView.frame.origin.y+_headView.frame.size.height;
        _circuleView.frame=r;
        
        r=self.frame;
        //r.size.height=_circuleView.frame.origin.y+_circuleView.frame.size.height-10;
        r.size.height=_circuleView.frame.origin.y+_circuleView.frame.size.height;
        self.frame=r;
    }
    [_headView setImageWithURL:[NSURL URLWithString:entity.Photo] placeholderImage:[UIImage imageNamed:@"bg02.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            if (image.size.width>90||image.size.height>104) {
                [_headView setImage:[image imageByScalingToSize:CGSizeMake(90, 104)]];
            }else{
                [_headView setImage:image];
            }
        }
        if(finished)
        {
            UIImage *resultImage=[UIImage getImageFromView:self];
            if ([self checkDevice:@"iPad"]) {//如果为ipad
                
                resultImage=[resultImage imageByScalingToSize:CGSizeMake(resultImage.size.width/2, resultImage.size.height/2)];
            }
            finished(resultImage);//取得截图
        }
    }];
    
}
- (void)getMapPinImage:(float)level source:(SupervisionPerson*)entity completed:(void(^)(UIImage *image))finished{
    if (level<6) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        bgView.backgroundColor=[UIColor blackColor];
        bgView.layer.cornerRadius=15;
        bgView.layer.masksToBounds=YES;
        UIImage *image=[UIImage getImageFromView:bgView];
        [bgView release];
        if(finished){
            finished(image);
        }
    }else{
        [self setDataSource:entity completed:finished];
    }
}
-(bool)checkDevice:(NSString*)name
{
    NSString* deviceType = [UIDevice currentDevice].model;
    //NSLog(@"deviceType = %@", deviceType);
    
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}
@end
