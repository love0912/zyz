//
//  Cell_PayInOut.h
//  自由找
//
//  Created by guojie on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpendDomain.h"

@interface Cell_PayInOut : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;

@property (strong, nonatomic) ExpendDomain *expand;

@end
