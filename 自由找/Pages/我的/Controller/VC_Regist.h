//
//  VC_Regist.h
//  自由找
//
//  Created by guojie on 16/6/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Regist : VC_Base<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_inputView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_perInput_height;

@property (weak, nonatomic) IBOutlet UITextField *tf_userName;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UITextField *tf_identifyCode;
@property (weak, nonatomic) IBOutlet UITextField *tf_inviteCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_showPass;
@property (weak, nonatomic) IBOutlet UIButton *btn_getCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (weak, nonatomic) IBOutlet UIButton *btn_regist;

@property (assign, nonatomic) BOOL isPresentView;

- (IBAction)btn_showPass_Pressed:(id)sender;
- (IBAction)btn_getCode_pressed:(id)sender;
- (IBAction)btn_agree_pressed:(id)sender;
- (IBAction)btn_userProtocal_pressed:(id)sender;
- (IBAction)btn_regist_pressed:(id)sender;
- (IBAction)btn_backLogin_pressed:(id)sender;
@end
