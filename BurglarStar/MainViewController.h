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
@interface MainViewController : BasicViewController<BSMenuDelegate>
@property (nonatomic,strong) AdView *scrollAdView;
@end
