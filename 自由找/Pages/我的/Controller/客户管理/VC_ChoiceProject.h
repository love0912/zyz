//
//  VC_ChoiceProject.h
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Project.h"
typedef void(^ChoiceProjectBlock)(Project *project);

@interface VC_ChoiceProject : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ChoiceProjectBlock choiceProject;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
