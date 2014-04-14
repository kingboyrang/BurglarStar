//
//  MainViewController.h
//  BurglarStar
//
//  Created by aJia on 2014/4/7.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSMenu.h"
#import "AdView.h"
#import "WeatherView.h"
#import "WeatherPopView.h"
@interface MainViewController : BasicViewController<BSMenuDelegate>
@property (nonatomic,strong) AdView *scrollAdView;
@property (nonatomic,strong) WeatherView *weatherView;
@property (nonatomic,strong) WeatherPopView *weatherPopView;
@end
