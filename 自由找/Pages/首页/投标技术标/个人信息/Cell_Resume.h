//
//  Cell_Resume.h
//  自由找
//
//  Created by xiaoqi on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProducerDomain.h"

@interface Cell_Resume : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_startTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_endTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_jobTitleOrBidName;
@property (weak, nonatomic) IBOutlet UILabel *lb_companyName;
@property (weak, nonatomic) IBOutlet UILabel *lb_references;


@property (strong, nonatomic) WorkExperienceDomain *work;

@end
