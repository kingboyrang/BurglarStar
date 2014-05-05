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
    UIColor *lineColor=[UIColor colorFromHexRGB:@"b6b6b6"];
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
    CGContextSetLineWidth(ctx,0.55);
    CGFloat topY=rect.size.width/3;
    CGContextBeginPath(ctx);
    int total=3;
     for (int i=0; i<total; i++) {
        //画横线
        CGContextMoveToPoint(ctx, 0, topY*(i+1));
        CGContextAddLineToPoint(ctx, topY*total, topY*(i+1));
        //画竖线
        CGContextMoveToPoint(ctx, topY*(i+1), 0);
        CGContextAddLineToPoint(ctx, topY*(i+1), topY*total);
     }
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

@end
