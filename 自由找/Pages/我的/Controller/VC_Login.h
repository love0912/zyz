//
//  VC_Login.h
//  自由找
//
//  Created by guojie on 16/6/24.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Login : VC_Base<UITextFieldDelegate>

#pragma mark - 处理iphone4s设备显示不完全的情况
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_v_phone_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_logo_top;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;

@property (weak, nonatomic) IBOutlet UILabel *lb_forgetPass;
- (IBAction)btn_close_pressed:(id)sender;
- (IBAction)btn_login_pressed:(id)sender;

@property (assign, nonatomic) BOOL isShowRegistVC;

@end
