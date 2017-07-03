//
//  Cell_ProjectResume.h
//  自由找
//
//  Created by xiaoqi on 16/8/16.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProducerDomain.h"
@interface Cell_ProjectResume : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_references;
@property (weak, nonatomic) IBOutlet UILabel *lb_jobTitleOrBidName;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (strong, nonatomic) ProjectExperienceDomain *project;
@end
