//
//  VC_ForgetPwd.h
//  自由找
//
//  Created by xiaoqi on 16/6/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_ForgetPwd : VC_Base
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_perInput_height;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_showpass;
- (IBAction)btn_login_pressed:(id)sender;
- (IBAction)btn_code_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_code;
- (IBAction)btn_showPass_Pressed:(id)sender;

@end
