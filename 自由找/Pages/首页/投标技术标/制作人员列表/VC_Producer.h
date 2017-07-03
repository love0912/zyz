//
//  VC_Producer.h
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Producer : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
