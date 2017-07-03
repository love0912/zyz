//
//  VC_OrderSubmit.h
//  自由找
//
//  Created by guojie on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_OrderSubmit : VC_Base

@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (weak, nonatomic) IBOutlet UIView *v_coupon;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_coupon;
@property (weak, nonatomic) IBOutlet UILabel *lb_total;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;

- (IBAction)btn_commit_pressed:(id)sender;
- (IBAction)btn_agree_pressed:(id)sender;

- (IBAction)btn_buy_procotol_pressed:(id)sender;
@end
