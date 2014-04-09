//
//  EditSupervisionViewController.h
//  LocationService
//
//  Created by aJia on 2013/12/27.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupervisionPerson.h"
@interface EditSupervisionViewController : BasicViewController
@property(nonatomic,strong) SupervisionPerson *Entity;
@property(nonatomic,strong) NSMutableArray *cells;
- (void)finishSelectedImage:(UIImage*)image;
- (void)finishUploadFileName:(NSString*)fileName;
@end
