//
//  VC_AddEditCompany.h
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_AddEditCompany.h"
typedef void(^AddEditCompanyBlock)(NSString *companyName);
@interface VC_AddEditCompany : VC_Base
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AddEditCompanyBlock addEditCompanyBlock;
@end
