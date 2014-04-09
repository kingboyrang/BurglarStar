//
//  BSMenu.h
//  BurglarStar
//
//  Created by aJia on 2014/4/8.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSMenuDelegate <NSObject>
-(void)selectItemMenu:(id)sender index:(NSInteger)itemIndex;
@end

@interface BSMenu : UIView
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,assign) id<BSMenuDelegate> delegate;
@end
