//
//  VC_Mine.h
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_MineCustom.h"
#import "ShareHelper.h"
@interface VC_Mine : VC_Base<UITableViewDelegate, UITableViewDataSource, MineCustomClickDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *mineHeaderView;

@end
