//
//  BSMenu.m
//  BurglarStar
//
//  Created by aJia on 2014/4/8.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BSMenu.h"
#import "UIImage+TPCategory.h"

#define MenuSource [NSDictionary dictionaryWithObjectsAndKeys:@"Menu_target.png",@"100",@"Menu_msg.png",@"101",@"Menu_sso.png",@"102",@"Menu_bus.png",@"103",@"Menu_user.png",@"104", nil]

@interface BSMenu ()
- (void)addBarItem:(CGRect)frame tag:(NSInteger)tag;
- (void)buttonMenuClick:(id)sender;
- (void)switchImageView:(UIButton*)btn;
@end

@implementation BSMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UIImage *image=[UIImage imageNamed:@"Menu.png"];
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self.imageView setImage:image];
        [self addSubview:self.imageView];
        
        CGRect r=frame;
        r.size=image.size;
        self.frame=r;
        
        //监控中心
        CGRect targetFrame=CGRectMake(r.size.width/3, 5, r.size.width/3, r.size.height/3-5);
        [self addBarItem:targetFrame tag:100];
        //人物
        CGRect userFrame=CGRectMake(r.size.width/3+8, r.size.height/3+7, r.size.width/4, r.size.height/4);
        [self addBarItem:userFrame tag:104];
        //sos
        CGFloat leftX=userFrame.origin.y-targetFrame.origin.y-targetFrame.size.height;
        CGRect sosFrame=targetFrame;
        sosFrame.origin.y=userFrame.origin.y+userFrame.size.height+leftX;
        [self addBarItem:sosFrame tag:102];
        
        //车辆管理
        CGRect busFrame=targetFrame;
        busFrame.origin.x=userFrame.origin.x-leftX-busFrame.size.width;
        busFrame.origin.y=(r.size.height-busFrame.size.height)/2;
        [self addBarItem:busFrame tag:103];
        //信息提醒
        CGRect msgFrame=busFrame;
        msgFrame.origin.x=userFrame.origin.x+userFrame.size.width+leftX;
        [self addBarItem:msgFrame tag:101];
        
    }
    return self;
}
- (void)addBarItem:(CGRect)frame tag:(NSInteger)tag{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    btn.tag=tag;
    [btn addTarget:self action:@selector(buttonMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    //[btn setTitle:@"中心" forState:UIControlStateNormal];
    //[btn setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self addSubview:btn];
}
- (void)switchImageView:(UIButton*)btn{
    UIImage *image=[UIImage imageNamed:@"Menu.png"];
    [self.imageView setImage:image];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectItemMenu:index:)]) {
        [self.delegate selectItemMenu:btn index:btn.tag];
    }
}
- (void)buttonMenuClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    NSString *imgName=[MenuSource objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    [self.imageView setImage:[UIImage imageNamed:imgName]];
    [self performSelector:@selector(switchImageView:) withObject:btn afterDelay:0.2f];
    
}
@end
