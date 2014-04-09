//
//  RecordView.m
//  LocationService
//
//  Created by aJia on 2014/1/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "RecordView.h"

@implementation RecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        UIImage *image=[UIImage imageNamed:@"record.png"];
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [_imageView setImage:image];
        [self addSubview:_imageView];
        
       _label=[[UILabel alloc] initWithFrame:CGRectMake(0,(image.size.height-20)/2, frame.size.width, 20)];
        _label.backgroundColor=[UIColor clearColor];
        _label.font=[UIFont boldSystemFontOfSize:14];
        _label.textColor=[UIColor whiteColor];
        _label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
- (void)setRecordCount:(int)total{
    if (total==0) {
        _hasValue=NO;
    }else{
        _hasValue=YES;
        
        NSString *title=[NSString stringWithFormat:@"%d",total];
        CGSize size=[title textSize:[UIFont boldSystemFontOfSize:14] withWidth:DeviceWidth];
        
        _label.text=title;
        CGRect r=_imageView.frame;
        r.size.width=size.width+5;
        r.size.height=r.size.width;
        _imageView.frame=r;
        
        r=_label.frame;
        r.size.width=_imageView.frame.size.width;
        r.origin.y=(_imageView.frame.size.height-size.height)/2;
        _label.frame=r;
        
        r=self.frame;
        r.size=_imageView.frame.size;
        self.frame=r;
        /***
        if (size.width>self.frame.size.width) {
            _label.text=title;
            CGRect r=_imageView.frame;
            r.size.width=size.width+2;
            r.size.height=r.size.width;
            _imageView.frame=r;
            
            r=_label.frame;
            r.size.width=_imageView.frame.size.width;
            _label.frame=r;
            
            r=self.frame;
            r.size=_imageView.frame.size;
            self.frame=r;
            return;
        }
        _label.text=title;
         ***/
    }
}
@end
