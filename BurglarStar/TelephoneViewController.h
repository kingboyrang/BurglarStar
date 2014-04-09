//
//  Telephone ViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/6.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupervisionPerson.h"
@interface TelephoneViewController : BasicViewController
@property (nonatomic,retain) SupervisionPerson *Entity;
@property (nonatomic,copy) NSString *Phone;
@end
