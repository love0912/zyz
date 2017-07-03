//
//  VC_InEnterprise.h
//  自由找
//
//  Created by xiaoqi on 16/6/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "VC_AddEditCompany.h"
@interface VC_InEnterprise : VC_Base<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iv_empty;
@property (weak, nonatomic) IBOutlet UILabel *lb_one;
@property (weak, nonatomic) IBOutlet UILabel *lb_two;
@property (weak, nonatomic) IBOutlet UIImageView *iv_tishi;
@property (weak, nonatomic) IBOutlet UILabel *lb_tishiF;
@property (weak, nonatomic) IBOutlet UILabel *lb_tishiS;

@end
