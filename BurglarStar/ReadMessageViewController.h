//
//  ReadMessageViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/13.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"
#import "SupervisionPerson.h"
#import "PullingRefreshTableView.h"
@interface ReadMessageViewController : BasicViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int pageSize;
    PullingRefreshTableView *_tableView;
}
@property (nonatomic,strong) SupervisionPerson *Entity;
@property (nonatomic) BOOL refreshing;
@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,strong) NSMutableDictionary *removeList;//删除
@end
