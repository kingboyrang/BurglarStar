//
//  TKTextViewCell.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
@interface TKTextViewCell : UITableViewCell
@property (nonatomic,strong) GCPlaceholderTextView *textView;
@property (nonatomic,assign) BOOL hasValue;
@end
