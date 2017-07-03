//
//  VC_Certification.h
//  自由找
//
//  Created by xiaoqi on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_CertificationRadio.h"
#import "Cell_CertificationOverview.h"
@interface VC_Certification : VC_Base<CertificationRadioDelegate,CertificationOverviewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
