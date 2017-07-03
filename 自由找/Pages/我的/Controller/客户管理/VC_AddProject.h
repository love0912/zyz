//
//  VC_AddProject.h
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Project.h"

@interface VC_AddProject : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  0 -- 添加, 1 -- 编辑
 */
@property (assign, nonatomic) NSInteger type;

@property (nonatomic, strong) Project *project;

- (IBAction)btn_add_pressed:(id)sender;
@end
