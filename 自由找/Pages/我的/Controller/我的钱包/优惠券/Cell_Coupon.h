//
//  Cell_Coupon.h
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponDomain.h"

@interface Cell_Coupon : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc1;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc2;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc3;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_tag_disable;

@property (strong, nonatomic) CouponDomain *coupon;

@end
