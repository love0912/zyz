//
//  VC_Login.m
//  自由找
//
//  Created by guojie on 16/6/24.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Login.h"
#import "VC_ForgetPwd.h"
#import "MineService.h"
#import "JPUSHService.h"
#import "VC_Regist.h"

#define Constraint_Logo_Top_Scale 0.139f
#define Constraint_V_Phone_Top_Scale 0.378f

@interface VC_Login ()
{
    MineService *_mineService;
    
    /**
     *  从哪个页面弹出的登录页  0 -- 点击登录进入 
     *                      1 -- 点击资质需求报名按钮进入
     *                      2 -- 点击消息页面进入
     */
    NSInteger _type;
}
@end

@implementation VC_Login

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLoginView) name:Notification_User_Login_Success object:nil];
    
    [self initData];
    [self layoutUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    if (_isShowRegistVC) {
        VC_Regist *vc_regist = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_Regist"];
        vc_regist.isPresentView = YES;
        [self.navigationController pushViewController:vc_regist animated:NO];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
//    if (nil == self.tf_check) {
//        return;
//    }
    NSDictionary *userInfo = [notification userInfo];
//
//    // Get the origin of the keyboard when it's displayed.
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//
//    // Get the top of the keyboard as the y coordinate of its origin inself's view's coordinate system. The bottom of the text view's frame shouldalign with the top of the keyboard's final position.
//    CGRect keyboardRect = [aValue CGRectValue];
//    
//    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.2f;
    [animationDurationValue getValue:&animationDuration];
//
//    CGRect textFrame = [self.tf_check convertRect:self.tf_check.frame toView:self.view] ;//当前UITextField的位置
//    float textY = textFrame.origin.y + textFrame.size.height;//得到UITextField下边框距离顶部的高度
//    float bottomY = self.view.frame.size.height - textY;//得到下边框到底部的距离
//    if(bottomY >=keyboardRect.size.height ){//键盘默认高度,如果大于此高度，则直接返回
//        return;
//    }
//    float moveY = keyboardRect.size.height - bottomY;
    
    // Animate the resize of the text view's frame in sync with the keyboard'sappearance.
    if (IS_IPHONE_4_OR_LESS) {
        [self moveInputBarWithKeyboardHeight:80 withDuration:animationDuration];
    } else if (IS_IPHONE_5) {
        [self moveInputBarWithKeyboardHeight:50 withDuration:animationDuration];
    }
    
}

//键盘被隐藏的时候调用的方法
- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of thekeyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.2f;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

-(void)moveInputBarWithKeyboardHeight:(float)_CGRectHeight withDuration:(NSTimeInterval)_NSTimeInterval {
    
    CGRect rect = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:_NSTimeInterval];
    
    rect.origin.y = -_CGRectHeight;//view往上移动
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}

- (void)initData {
    _mineService = [MineService sharedService];
    
    if (self.parameters != nil) {
        _type = [[self.parameters objectForKey:kPageType] integerValue];
    }
}

-(void)initValue{
    
//    if (self.tf_phone.text.length!=0 ) {
//        if ([self.tf_phone.text isValidPhone]==YES ) {
//            [_parameterDic setObject:self.tf_phone.text forKey:@"Account"];
//        }else{
//            [ProgressHUD showInfo:@"手机号不符合" withSucc:NO withDismissDelay:1];
//        }
//        
//    }else{
//      [ProgressHUD showInfo:@"手机号不能为空" withSucc:NO withDismissDelay:1];
//    }
//    
//    if (self.tf_password.text.length!=0 ) {
//            [_parameterDic setObject:[CommonUtil getMd5_32Bit:self.tf_password.text] forKey:@"Password"];
//    }else{
//        [ProgressHUD showInfo:@"密码不能为空" withSucc:NO withDismissDelay:1];
//    }
//    [_parameterDic setObject:@"0" forKey:@"Device"];
//
//    [_parameterDic setObject:[self shortVersion] forKey:@"Version"];
}
- (void)viewWillAppear:(BOOL)animated {
    [self statusBarDefault];
}

- (void)dismissLoginView {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_ShowToDoList" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];

    }];
}

//- (void)initData {
////    __weak typeof(self) weakSelf = self;
////    [[MineService sharedService]loginWithParameters:_parameterDic result:^(UserDomain *user) {
////        if (user != nil) {
////            [CommonUtil saveUserDomian:user];
////        }
////        [weakSelf dismissViewControllerAnimated:YES completion:nil];
////    }];
//
//}

- (void)layoutUI {
    self.jx_navigationBar.hidden = YES;
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.lb_forgetPass.text attributes:attribtDic];
    
    self.lb_forgetPass.attributedText = attribtStr;
    UITapGestureRecognizer *tap_forget=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_forgetPass)];
    [self.lb_forgetPass addGestureRecognizer:tap_forget];
    
    self.constraint_logo_top.constant = ScreenSize.height * Constraint_Logo_Top_Scale;
    self.constraint_v_phone_top.constant = ScreenSize.height * Constraint_V_Phone_Top_Scale;
    
    NSString *phone = [[CommonUtil objectForUserDefaultsKey:kLastLoginPhone] toString];
    if (phone != nil) {
        _tf_phone.text = phone;
    }
}
-(void)tap_forgetPass{
    VC_ForgetPwd*forgetPwdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_ForgetPwd"];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_close_pressed:(id)sender {
    if (_type == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"USERNOTLOGINNOTIFICATION" object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btn_login_pressed:(id)sender {
    if ([self checkInput]) {
        //自由找登陆
        [self loginziyouzhao];
    }
}
-(void)loginziyouzhao{
    NSDictionary *paramDic = @{kLoginAccount: _tf_phone.text, kLoginPassword: [CommonUtil getMd5_32Bit:_tf_password.text], kLoginDevice: @0, kLoginVersion: [self shortVersion]};
    [_mineService loginWithParameters:paramDic result:^(UserDomain *user, NSInteger code) {
        if (code != 1) {
            return ;
        }
        [self bindAlias:user];
        //统计账号
        [MobClick profileSignInWithPUID:user.UserId];
        [self checkMsgAndPublishCount];
        [CommonUtil saveUserDomian:user];
        //保存登录手机号，下次进入默认显示
        [CommonUtil saveObject:_tf_phone.text forUserDefaultsKey:kLastLoginPhone];
//        [self loginWithUsername:_tf_phone.text password:_tf_password.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_LOGIN_NOTIFICATION" object:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];
        if (_type == 1) {
            //如果从资质需求页进入，从新查询是否可报名
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_BidListByID_Refresh object:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationChangeHomeAvater" object:nil];
        [self dismissLoginView];
    }];
}
//环信登陆
//- (void)loginWithUsername:(NSString *)username password:(NSString *)password
//{
//    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
//    //异步登陆账号
//    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself hideHud];
//            if (!error) {
//                //设置是否自动登录
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
//                
//                //获取数据库中数据
////                [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [[EMClient sharedClient] dataMigrationTo3];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                            EMError *error = nil;
//                            [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
//                        });
//                        
////                        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
//                        //发送自动登陆状态通知
//                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
//                        
//                        //保存最近一次登录用户名
//                        [weakself saveLastLoginUsername];
//                        
//                        
//                    });
//                });
//            } else {
//                switch (error.code)
//                {
//                    case EMErrorUserNotFound:{
//                        [self EMRegister];
//                    
//                       }
//                        break;
//                    case EMErrorNetworkUnavailable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
//                        break;
//                    case EMErrorServerNotReachable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
//                        break;
//                    case EMErrorUserAuthenticationFailed:
//                        TTAlertNoTitle(error.errorDescription);
//                        break;
//                    case EMErrorServerTimeout:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
//                        break;
//                    default:
//                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
//                        break;
//                }
//            }
//        });
//    });
//}
//-(void)EMRegister{
//    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] registerWithUsername:weakself.tf_phone.text password:weakself.tf_password.text];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself hideHud];
//            if (!error) {
//                
//            }else{
//                switch (error.code) {
//                    case EMErrorServerNotReachable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
//                        break;
//                    case EMErrorUserAlreadyExist:
//                        TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
//                        break;
//                    case EMErrorNetworkUnavailable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
//                        break;
//                    case EMErrorServerTimeout:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
//                        break;
//                    default:
//                        NSLog(@"%u",error.code);
//                        TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
//                        break;
//                }
//            }
//        });
//    });
//    
//}

#pragma  mark - private
//- (void)saveLastLoginUsername
//{
//    NSString *username = [[EMClient sharedClient] currentUsername];
//    if (username && username.length > 0) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
//        [ud synchronize];
//    }
//}
//
//- (NSString*)lastLoginUsername
//{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
//    if (username && username.length > 0) {
//        return username;
//    }
//    return nil;
//}

- (void)bindAlias:(UserDomain *)user {
    NSLog(@"%@", [user.UserId stringByReplacingOccurrencesOfString:@"-" withString:@""]);
    [JPUSHService setTags:nil alias:[user.UserId stringByReplacingOccurrencesOfString:@"-" withString:@""] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if (iResCode == 0) {
            NSLog(@"bind success");
        }
    }];
}

- (void)checkMsgAndPublishCount {
    [_mineService getMessageCountWithResult:^(NSInteger count, NSInteger code) {
        if (code == 1) {
            [CommonUtil setMsgCount:count];
        }
    }];
    
    [_mineService getMinePublishCountWithResult:^(NSInteger count, NSInteger code) {
        if (code == 1) {
            [CommonUtil setMineCount:count];
        }
    }];
}

- (BOOL)checkInput {
//    if (![self.tf_phone.text isValidPhone]) {
//        [ProgressHUD showInfo:@"手机号不合法" withSucc:NO withDismissDelay:2];
//        return NO;
//    }
    if (self.tf_password.text.trimWhitesSpace.length == 0) {
        [ProgressHUD showInfo:@"密码不能为空" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}
@end
