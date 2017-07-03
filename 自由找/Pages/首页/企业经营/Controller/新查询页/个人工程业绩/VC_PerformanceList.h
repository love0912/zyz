//
//  VC_PerformanceList.h
//  zyz
//
//  Created by 郭界 on 17/1/6.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_PerformanceList : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
