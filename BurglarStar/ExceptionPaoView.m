//
//  ExceptionPaoView.m
//  LocationService
//
//  Created by aJia on 2014/1/15.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ExceptionPaoView.h"
#import "TKLabelLabelCell.h"
#import "TKTrajectoryPaoCell.h"
@interface ExceptionPaoView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
- (CGFloat)getTableHeight;
- (void)relayout;
@end

@implementation ExceptionPaoView
- (void)dealloc{
    [super dealloc];
    [_tableView release],_tableView=nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //气泡view的背景图片 － 被分为左边背景和右边背景两个部分
        //UIEdgeInsets insets = UIEdgeInsetsMake(13,8, 13, 8);
        UIImage *imageNormal, *imageHighlighted;
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *leftBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                 highlightedImage:imageHighlighted];
        leftBgd.frame=CGRectMake(0, 0, frame.size.width/2, frame.size.height);
        leftBgd.tag = 11;
        
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *rightBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                  highlightedImage:imageHighlighted];
        rightBgd.frame=CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height);
        rightBgd.tag = 12;
        
        [self addSubview:leftBgd];
        [self addSubview:rightBgd];
        [leftBgd release];
        [rightBgd release];
        
        CGRect r=self.bounds;
        r.size.height-=11;
        r.origin.y=5;
        _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.bounces=NO;
        [self addSubview:_tableView];
        
        TKLabelLabelCell *cell1=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell1.label.text=@"名称:";
        
        TKLabelLabelCell *cell2=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell2.label.text=@"时间:";
        
        TKLabelLabelCell *cell3=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell3.label.text=@"原因:";
        
        TKLabelLabelCell *cell4=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell4.label.text=@"位置:";
        
        /***
        TKTrajectoryPaoCell *cell4=[[TKTrajectoryPaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell4.label.text=@"方向:";
        cell4.label2.text=@"速度:";
        
        TKTrajectoryPaoCell *cell5=[[TKTrajectoryPaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell5.label.text=@"转动:";
        cell5.label2.text=@"油表:";
        
        TKLabelLabelCell *cell6=[[TKLabelLabelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell6.label.text=@"温度:";
         ***/
        
        self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4, nil];
    }
    return self;
}
- (void)setDataSource:(TrajectoryMessage*)entity{
    TKLabelLabelCell *cell1=self.cells[0];
    cell1.showLabel.text=entity.PName;
    
    TKLabelLabelCell *cell2=self.cells[1];
    cell2.showLabel.text=entity.PCTime;
    
    TKLabelLabelCell *cell3=self.cells[2];
    cell3.showLabel.text=entity.Reason;
    
    TKLabelLabelCell *cell4=self.cells[3];
    cell4.showLabel.text=entity.Address;
    

    [_tableView reloadData];
    
    //重设大小
    [self relayout];
    
}
- (CGFloat)getTableHeight{
    CGFloat total=0;
    for (int i=0; i<self.cells.count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        total+=[_tableView.delegate tableView:_tableView heightForRowAtIndexPath:indexPath];
    }
    return total;
}
- (void)relayout{
    //重设大小
    CGRect r=_tableView.frame;
    r.size.height=[self getTableHeight];
    _tableView.frame=r;
    
    r=self.frame;
    r.size.height=_tableView.frame.size.height+5+13;
    self.frame=r;
    
    UIImageView *leftBgd=(UIImageView*)[self viewWithTag:11];
    leftBgd.frame=CGRectMake(0, 0, r.size.width/2, r.size.height);
    
    UIImageView *rightBgd=(UIImageView*)[self viewWithTag:12];
    rightBgd.frame=CGRectMake(r.size.width/2, 0, r.size.width/2, r.size.height);
}

#pragma mark - table source & delete Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cells count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=self.cells[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.cells[indexPath.row] isKindOfClass:[TKLabelLabelCell class]]) {
        TKLabelLabelCell *cell=self.cells[indexPath.row];
        CGSize size=[cell.showLabel.text textSize:[UIFont fontWithName:DeviceFontName size:12] withWidth:self.frame.size.width-(10+28+2+5)];
        if (size.height+5>20) {
            return size.height+5;
        }
        return 20;
    }
    TKTrajectoryPaoCell *cell=self.cells[indexPath.row];
    CGSize size1=[cell.showLabel1.text textSize:[UIFont fontWithName:DeviceFontName size:12] withWidth:self.frame.size.width/2-(4+10+33)];
    CGSize size2=[cell.showLabel2.text textSize:[UIFont fontWithName:DeviceFontName size:12] withWidth:self.frame.size.width-(self.frame.size.width/2+28+10)-7];
    CGFloat w=size1.height>size2.height?size1.height:size2.height;
    if (w+5>20) {
        return w+5;
    }
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

@end
