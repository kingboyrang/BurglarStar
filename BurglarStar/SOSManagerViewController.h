//
//  SOSManagerViewController.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"
#import "ToolEditView.h"
@interface SOSManagerViewController : BasicViewController
@property (nonatomic,strong) ToolEditView *toolBarView;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,strong) NSMutableDictionary *removeList;
@end
