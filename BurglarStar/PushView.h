//
//  PushView.h
//  Wisdom
//
//  Created by aJia on 2013/11/4.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@protocol PushViewDelegate <NSObject>
- (void)showErrorNetWork;
- (void)showMesssageWithTitle:(NSString*)title;
@end


@interface PushView : UIView<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
@private
    PullingRefreshTableView *_tableView;
    int currentPage;
    int pageSize;
    int maxPage;
}
@property (nonatomic) BOOL refreshing;
@property (nonatomic) BOOL isReload;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) int infoType;
@property (nonatomic,assign) id<PushViewDelegate> delegate;
-(void)loadingSourceData;
-(void)reloadingSourceData;
-(void)initParams;
@end
