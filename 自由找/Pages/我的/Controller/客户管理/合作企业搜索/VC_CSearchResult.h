//
//  VC_CSearchResult.h
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_CSearchResult : VC_Base<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lb_total;
@end
