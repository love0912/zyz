//
//  VC_ModifyPayPass.m
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ModifyPayPass.h"
#import "PayService.h"

@interface VC_ModifyPayPass ()
{
    PayService *_payService;
}
@end

@implementation VC_ModifyPayPass

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"修改钱包密码";
    [self zyzOringeNavigationBar];
    
    _btn_commit.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRegistButton:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _payService = [PayService sharedService];
    
}

#pragma mark - 验证必输项是否输入
- (void)enableRegistButton:(NSNotification *)notification {
    if (![self isNull:_tf_oriPassword] &&
        ![self isNull:_tf_newPassword] &&
        ![self isNull:_tf_reNewPass]) {
        _btn_commit.enabled = YES;
    } else {
        _btn_commit.enabled = NO;
    }
    UITextField *textField = notification.object;
    if (_tf_newPassword == textField || _tf_reNewPass == textField) {
        NSString *text = textField.text;
        if (text.trimWhitesSpace.length > 6) {
            textField.text = [text substringWithRange:NSMakeRange(0, 6)];
        }
    }

//    UITextField *textField = notification.object;
//    NSString *text = textField.text;
//    if (text.trimWhitesSpace.length > 6) {
//        textField.text = [text substringWithRange:NSMakeRange(0, 6)];
//    }
}

- (BOOL)isNull:(UITextField *)textfield {
    if (textfield.text.trimWhitesSpace.length == 0) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_commit_pressed:(id)sender {
    if ([self checkInput]) {
        //TODO:
        [_payService modifyPayPasswordWithOriPass:_tf_oriPassword.text newPass:_tf_newPassword.text result:^(NSInteger code) {
            if (code == 1) {
                [ProgressHUD showInfo:@"修改密码成功" withSucc:YES withDismissDelay:2];
                [self goBack];
            }
        }];
    }
}

- (BOOL)checkInput {
    if ([_tf_newPassword.text.trimWhitesSpace isEqualToString:_tf_reNewPass.text.trimWhitesSpace]) {
        return YES;
    }
    [ProgressHUD showInfo:@"两次输入的密码不一致" withSucc:NO withDismissDelay:2];
    return NO;
}
@end
