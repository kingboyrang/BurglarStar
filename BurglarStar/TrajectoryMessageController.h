//
//  TrajectoryMessageController.h
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupervisionPerson.h"
#import "PullingRefreshTableView.h"
@interface TrajectoryMessageController : BasicViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int pageSize;
    PullingRefreshTableView *_tableView;
}
@property(nonatomic,strong) SupervisionPerson *Entity;
@property (nonatomic) BOOL refreshing;
@property (nonatomic,strong) NSMutableArray *cells;

@property(nonatomic,strong) NSMutableDictionary *removeList;//删除
@property(nonatomic,strong) NSMutableDictionary *readList;//标记已读
@property(nonatomic,readonly) BOOL canShowMessage;//
- (void)receiveParams:(SupervisionPerson*)entity;
@end
