//
//  PushDetail.m
//  Wisdom
//
//  Created by aJia on 2013/11/4.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "PushDetail.h"
#import "UIColor+TPCategory.h"
#import "UIImage+TPCategory.h"
#import "NSString+TPCategory.h"
@implementation PushDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat topY=5;
        UIImage *image1=[UIImage imageNamed:@"info.png"];
        UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake((88-image1.size.width)/2, 20, image1.size.width,image1.size.height)];
        [imageView1 setImage:image1];
        [self addSubview:imageView1];
        [imageView1 release];
        
        _labDate=[[UILabel alloc] initWithFrame:CGRectMake(0, 20+image1.size.height+2,88,18)];
        _labDate.textColor=[UIColor colorFromHexRGB:@"919293"];
        _labDate.font=[UIFont boldSystemFontOfSize:14];
        _labDate.textAlignment=NSTextAlignmentCenter;
        _labDate.backgroundColor=[UIColor clearColor];
        [self addSubview:_labDate];
        
        
        UIImage *image2=[UIImage imageNamed:@"bubble.png"];
        _msgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(88, topY, image2.size.width, image2.size.height)];
        [_msgImageView setImage:image2];
        [self addSubview:_msgImageView];
        
        CGRect r=CGRectInset(_msgImageView.frame, 10, 10);
        _labMessage=[[UILabel alloc] initWithFrame:r];
        _labMessage.textColor=[UIColor colorFromHexRGB:@"919293"];
        _labMessage.font=[UIFont boldSystemFontOfSize:14];
        _labMessage.numberOfLines=0;
        _labMessage.lineBreakMode=NSLineBreakByWordWrapping;
        _labMessage.backgroundColor=[UIColor clearColor];
        [self addSubview:_labMessage];
        
        UIImage *image3=[UIImage imageNamed:@"line.png"];
        _lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, _msgImageView.frame.origin.y+_msgImageView.frame.size.height+3, self.frame.size.width,image3.size.height)];
        [_lineImageView setImage:image3];
        [self addSubview:_lineImageView];
        
        r=self.frame;
        r.size.height=_lineImageView.frame.origin.y+image3.size.height;
        self.frame=r;
        
        
        
        self.backgroundColor=[UIColor colorFromHexRGB:@"f9f6f7"];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect  r=_labMessage.frame;
    if ([_labMessage.text length]>0) {
        CGSize size=[_labMessage.text textSize:[UIFont boldSystemFontOfSize:14] withWidth:r.size.width];
        if (size.height>_msgImageView.frame.size.height-20) {
            UIImage *leftImage=[UIImage imageNamed:@"bubble.png"];
            UIEdgeInsets leftInsets = UIEdgeInsetsMake(10,10, 10, 10);
            leftImage=[leftImage resizableImageWithCapInsets:leftInsets resizingMode:UIImageResizingModeStretch];
            r=_msgImageView.frame;
            r.size.height=20+size.height;
            [_msgImageView setImage:leftImage];
            _msgImageView.frame=r;
           
            
            r=CGRectInset(_msgImageView.frame, 10, 10);
            _labMessage.frame=r;
            
            r=_lineImageView.frame;
            r.origin.y=_msgImageView.frame.origin.y+_msgImageView.frame.size.height+3;
            _lineImageView.frame=r;
            
            r=self.frame;
            r.size.height=_lineImageView.frame.origin.y+_lineImageView.frame.size.height;
            self.frame=r;
            
            
        }
    }
}

@end
