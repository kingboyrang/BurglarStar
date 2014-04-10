//
//  AdModel.h
//  Wisdom
//
//  Created by aJia on 2013/10/29.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject
@property(nonatomic,copy) NSString *advertName;
@property(nonatomic,copy) NSString *thumb;
@property(nonatomic,copy) NSString *webURl;
+(NSMutableArray*)sourceModels;
@end
