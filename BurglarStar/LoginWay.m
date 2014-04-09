//
//  LoginWay.m
//  LocationService
//
//  Created by aJia on 2013/12/17.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "LoginWay.h"
@interface LoginWay ()
- (void)changeLoginWay:(id)sender;
@end

@implementation LoginWay
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UIImage *image=[UIImage imageNamed:@"log_top.png"];
        CGRect r=self.bounds;
        r.size=image.size;
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:r];
        [imageView setImage:image];
        [self addSubview:imageView];
        [imageView release];
        
       
        UIImage *img_ger=[UIImage imageNamed:@"btn_ger.png"];
        UIButton *btn_ger=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_ger.tag=100;
        btn_ger.frame=CGRectMake(10, image.size.height, img_ger.size.width, img_ger.size.height);
        [btn_ger setImage:img_ger forState:UIControlStateNormal];
        [btn_ger setImage:[UIImage imageNamed:@"btn_ger_s.png"] forState:UIControlStateSelected];
        [btn_ger addTarget:self action:@selector(changeLoginWay:) forControlEvents:UIControlEventTouchUpInside];
        btn_ger.selected=YES;
        [self addSubview:btn_ger];
        
        
        UIImage *img_tel=[UIImage imageNamed:@"btn_tel.png"];
        UIButton *btn_tel=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_tel.tag=101;
        btn_tel.frame=CGRectMake(30+img_ger.size.width, image.size.height, img_tel.size.width, img_tel.size.height);
        [btn_tel setImage:img_tel forState:UIControlStateNormal];
        [btn_tel setImage:[UIImage imageNamed:@"btn_tel_s.png"] forState:UIControlStateSelected];
        [btn_tel addTarget:self action:@selector(changeLoginWay:) forControlEvents:UIControlEventTouchUpInside];
        btn_tel.selected=NO;
        [self addSubview:btn_tel];
    }
    return self;
}
- (void)changeLoginWay:(id)sender{
    UIButton *btn=(UIButton*)sender;
    UIButton *btn1=(UIButton*)[self viewWithTag:btn.tag==100?101:100];
    btn.selected=YES;
    btn1.selected=NO;
    int index=btn.tag-100;
    SEL sel=NSSelectorFromString(@"selectedMenuItemIndex:");
    if (self.controlers&&[self.controlers respondsToSelector:sel]) {
        [self.controlers performSelector:sel withObject:[NSNumber numberWithInt:index]];
    }
}
- (void)setSelectedItemIndex:(int)index{
    int pos=100+index;
    UIButton *btn=(UIButton*)[self viewWithTag:pos];
    [self changeLoginWay:btn];
}
- (void)setWaySelectedItemIndex:(int)index{
    int pos=100+index;
    UIButton *btn=(UIButton*)[self viewWithTag:pos];
    [self changeLoginWay:btn];
}
@end
