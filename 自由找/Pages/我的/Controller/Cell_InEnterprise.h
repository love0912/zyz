//
//  Cell_InEnterprise.h
//  自由找
//
//  Created by xiaoqi on 16/6/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDomain.h"
#import "InCompanyDomain.h"
@interface Cell_InEnterprise : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_CompanyName;
@property (strong, nonatomic)SiteDomain *sits;
@property (strong, nonatomic)InCompanyDomain *incompany;
@end
