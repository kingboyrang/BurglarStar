//
//  GeneralLoginViewController.h
//  LocationService
//
//  Created by aJia on 2013/12/17.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GeneralLoginViewController : BasicViewController
@property(nonatomic,strong) NSMutableArray *cells;
-(void) showLoadingAnimated:(void (^)(AnimateLoadView *errorView))process;
-(void) showErrorViewAnimated:(void (^)(AnimateErrorView *errorView))process;
-(void) showSuccessViewAnimated:(void (^)(AnimateErrorView *errorView))process;
@end
