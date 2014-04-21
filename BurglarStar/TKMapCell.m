//
//  TKMapCell.m
//  LocationService
//
//  Created by aJia on 2013/12/30.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TKMapCell.h"
#import "UIDevice+TPCategory.h"
#import "OfflineHelper.h"
@interface TKMapCell (){
    BOOL isFinished;
}
@end

@implementation TKMapCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    _labTitle=[[UILabel alloc] initWithFrame:CGRectZero];
    _labTitle.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    _labTitle.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _labTitle.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_labTitle];
    
    _labprocess=[[UILabel alloc] initWithFrame:CGRectZero];
    _labprocess.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    _labprocess.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _labprocess.backgroundColor=[UIColor clearColor];
    _labprocess.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_labprocess];
    
    _progressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame=CGRectZero;
    [self.contentView addSubview:_progressView];
    

    isFinished=NO;
    
	return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}

- (void)setDataSource:(BMKOLSearchRecord*)entity{
    self.Entity=entity;
    NSString *title=entity.cityName;
    //转换包大小
    NSString*packSize = [OfflineHelper getDataSizeString:entity.size];
    _labTitle.text=[NSString stringWithFormat:@"%@(%@)",title,packSize];
    
    if ([_labprocess.text length]==0) {
        _labprocess.text=@"等待下载 0%";
    }
}
- (void)updateProgressInfo:(BMKOLUpdateElement*)updateInfo{
    if (self.isPause) {
        self.isPause=NO;
    }
    _labprocess.text=[NSString stringWithFormat:@"正在下载 %d%%",updateInfo.ratio];
    _progressView.progress=updateInfo.ratio/100.0;
    if (updateInfo.ratio==100) {//表示下载完成
        isFinished=YES;
         SEL sel=NSSelectorFromString(@"finishedDownloadWithRow:element:");
        if (self.controlers&&[self.controlers respondsToSelector:sel]) {
            [self.controlers performSelector:sel withObject:self withObject:updateInfo];
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = CGRectInset(self.contentView.bounds, 10, 5);
    r.size.width=r.size.width/2+10;
    r.size.height=20;
    _labTitle.frame=r;
    
    r.size.width=120;
    r.origin.x=self.frame.size.width-10-r.size.width;
    _labprocess.frame=r;
    
    
    r=CGRectInset(self.contentView.bounds, 10, 5);
    r.origin.y=_labTitle.frame.origin.y+_labTitle.frame.size.height+2;
    r.size.height=5;
    _progressView.frame=r;
}
@end
