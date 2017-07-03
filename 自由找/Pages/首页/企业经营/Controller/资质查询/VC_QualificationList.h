//
//  VC_QualificationList.h
//  自由找
//
//  Created by xiaoqi on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "QualificaService.h"
@interface VC_QualificationList : VC_Base<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
