//
//  MoreMenuView.m
//  BurglarStar
//
//  Created by aJia on 2014/4/14.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MoreMenuView.h"
#import "UIButton+TPCategory.h"
#define MoreMenuImages [NSArray arrayWithObjects:@"area.png",@"onlineMap.png",@"userInfo.png",@"editPwd.png",@"closeAccount.png",@"feedback.png",@"aboutUS.png",@"help.png", nil]

@interface MoreMenuView ()
- (void)buttonMenuClick:(id)sender;
@end

@implementation MoreMenuView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        CGFloat w=frame.size.width/3,h=w;
        NSInteger row=[MoreMenuImages count]%3==0?[MoreMenuImages count]/3:[MoreMenuImages count]/3+1;
        
        NSInteger index=0;
        for (NSInteger i=0; i<row; i++) {
            for (NSInteger j=0; j<3; j++) {
                if (index>=0&&index<[MoreMenuImages count]) {
                    UIButton *btn=[UIButton buttonWithImageName:[MoreMenuImages objectAtIndex:index] target:self
                                                         action:@selector(buttonMenuClick:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=100+index;
                    CGRect r=btn.frame;
                    r.origin.x=(w-r.size.width)/2+j*w;
                    r.origin.y=(h-r.size.height)/2+i*h;
                    btn.frame=r;
                    [self addSubview:btn];
                }else{
                    break;
                }
                index++;
            }
        }
        
       
    }
    return self;
}
//点击事件
- (void)buttonMenuClick:(id)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedMenuItemIndex:sender:)]) {
        UIButton *btn=(UIButton*)sender;
        [self.delegate selectedMenuItemIndex:btn.tag-100 sender:sender];
    }
}
- (void)drawRect:(CGRect)rect
{
    UIColor *lineColor=[UIColor colorFromHexRGB:@"b8b8b8"];
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
    CGContextSetLineWidth(ctx,0.55);
    CGFloat topY=rect.size.width/3;
    /***
     CGContextMoveToPoint(ctx, 0.0, topY);
     CGContextAddLineToPoint(ctx, rect.size.width, topY);
     ***/
    //画横线
    CGPoint strokeSegments[] =
    {
        CGPointMake(0.0, topY),
        CGPointMake(rect.size.width, topY),
        CGPointMake(0.0, topY*2),
        CGPointMake(rect.size.width, topY*2),
        CGPointMake(0.0, topY*3),
        CGPointMake(rect.size.width, topY*3),
    };
    CGContextStrokeLineSegments(ctx, strokeSegments, sizeof(strokeSegments)/sizeof(strokeSegments[0]));
    //画竖线
    CGFloat leftX=rect.size.width/3;
    
    CGPoint verticalSegments[] =
    {
        CGPointMake(leftX, 0),
        CGPointMake(leftX, topY*3),
        CGPointMake(leftX*2,0),
        CGPointMake(leftX*2,topY*3),
    };
    CGContextStrokeLineSegments(ctx, verticalSegments, sizeof(verticalSegments)/sizeof(verticalSegments[0]));
    CGContextStrokePath(ctx);
}

@end
