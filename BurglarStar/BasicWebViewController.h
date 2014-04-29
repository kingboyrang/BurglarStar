//
//  BasicWebViewController.h
//  BurglarStar
//
//  Created by aJia on 2014/4/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicWebViewController : BasicViewController
@property (nonatomic,copy) NSString *webURL;
@property (nonatomic,assign) NSInteger webType;//5:意见反馈 6:关于我们 7:帮助
@end
