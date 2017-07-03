//
//  VC_ModifyPayPass.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_ModifyPayPass : VC_Base

@property (weak, nonatomic) IBOutlet UITextField *tf_oriPassword;
@property (weak, nonatomic) IBOutlet UITextField *tf_newPassword;
@property (weak, nonatomic) IBOutlet UITextField *tf_reNewPass;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
- (IBAction)btn_commit_pressed:(id)sender;
@end
