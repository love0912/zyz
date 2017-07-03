//
//  VC_Withdrawal_Verify.h
//  自由找
//
//  Created by guojie on 16/8/31.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Withdrawal_Verify : VC_Base

@property (weak, nonatomic) IBOutlet UILabel *lb_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet UIButton *btn_code;
- (IBAction)btn_code_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
- (IBAction)btn_commit_pressed:(id)sender;
@end
