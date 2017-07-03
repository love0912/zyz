//
//  VC_AddCompany.h
//  自由找
//
//  Created by xiaoqi on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "CustomIOSAlertView.h"
typedef void(^AddCompanyBlock2)(BaseDomain *domain);
typedef void(^AddCompanyBlock)(NSString *companyString);
@interface VC_AddCompany : VC_Base<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) AddCompanyBlock addCompanyBlock;
@property (nonatomic, strong) AddCompanyBlock2 AddCompanyBlock2;
@property (weak, nonatomic) IBOutlet UILabel *lb_search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
