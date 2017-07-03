//
//  VC_Withdrawal.h
//  自由找
//
//  Created by xiaoqi on 16/8/19.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Withdrawal : VC_Base

@property (weak, nonatomic) IBOutlet UITextField *tf_username;
@property (weak, nonatomic) IBOutlet UITextField *tf_cardNumber;
@property (weak, nonatomic) IBOutlet UIButton *btn_bankType;
@property (weak, nonatomic) IBOutlet UITextField *tf_money;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (weak, nonatomic) IBOutlet UILabel *lb_avaliableMoney;
- (IBAction)btn_withdraw_all:(id)sender;
- (IBAction)btn_commit_pressed:(id)sender;
- (IBAction)btn_bankType_pressed:(id)sender;
@end
