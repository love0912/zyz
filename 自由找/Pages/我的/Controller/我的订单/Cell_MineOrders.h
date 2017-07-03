//
//  Cell_MineOrders.h
//  自由找
//
//  Created by xiaoqi on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoDomain.h"

@interface Cell_MineOrders : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_projectName;
@property (weak, nonatomic) IBOutlet UIImageView *iv_orderStautes;
@property (weak, nonatomic) IBOutlet UIImageView *iv_projectType;
@property (weak, nonatomic) IBOutlet UILabel *lb_projectType;
@property (weak, nonatomic) IBOutlet UILabel *lb_buyNumbers;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_productType;

@property (strong, nonatomic) OrderInfoDomain *order;

@end
