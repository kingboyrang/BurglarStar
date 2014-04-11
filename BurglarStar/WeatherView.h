//
//  WeatherView.h
//  BurglarStar
//
//  Created by aJia on 2014/4/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIServiceHelper.h"
@interface WeatherView : UIView{
    ASIServiceHelper *_serviceHelper;
}
@property (nonatomic,strong) UIImageView *weatherImage;//天气图标
@property (nonatomic,strong) UILabel *labCurDate;//当前日期
@property (nonatomic,strong) UILabel *labCurCity;//当前城市与天气
@property (nonatomic,strong) UILabel *labCurTemp;//当前温度
@property (nonatomic,strong) UIButton *arrowButton;
- (void)loadCurrentLocationWeather;
@end
