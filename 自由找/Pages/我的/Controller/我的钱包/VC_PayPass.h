//
//  VC_PayPass.h
//  自由找
//
//  Created by guojie on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_PayPass : VC_Base

@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_pass;
@property (weak, nonatomic) IBOutlet UITextField *tf_rePass;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet UIButton *btn_getCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

- (IBAction)btn_code_pressed:(id)sender;
- (IBAction)btn_agree_pressed:(id)sender;
- (IBAction)btn_payProtocol_pressed:(id)sender;
- (IBAction)btn_commit_pressed:(id)sender;


@end
