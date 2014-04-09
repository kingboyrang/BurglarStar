//
//  MoreViewController.h
//  LocationService
//
//  Created by aJia on 2013/12/23.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : BasicViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,retain) NSMutableArray *sourceData;
@end
