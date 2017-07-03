//
//  VC_AddCustomer.h
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_AddCustomer : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  0 -- 添加, 1 -- 编辑
 */
@property (assign, nonatomic) NSInteger type;

- (IBAction)btn_save_pressed:(id)sender;

@end
