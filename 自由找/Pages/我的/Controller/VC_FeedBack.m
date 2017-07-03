//
//  VC_FeedBack.m
//  自由找
//
//  Created by xiaoqi on 16/7/1.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_FeedBack.h"

@interface VC_FeedBack (){
    CGFloat _tvHeight;
    UINavigationBar *_keyboardNavigationbar;
}

@end

@implementation VC_FeedBack

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"意见反馈";
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self layoutUI];
}
-(void)initData{
    if (IS_IPHONE_6P) {
        _tvHeight=230;
    }else if (IS_IPHONE_4_OR_LESS) {
        _tvHeight=180;
    }else{
        _tvHeight=215;
    }
}
-(void) layoutUI{
    self.layout_tv_height.constant=_tvHeight;
    self.tf_email.layer.masksToBounds=YES;
    self.tf_email.layer.cornerRadius=5;
    self.tv_content.layer.masksToBounds=YES;
    self.tv_content.layer.cornerRadius=5;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self layoutKeyboardToolbar];
    self.tv_content.inputAccessoryView = _keyboardNavigationbar;
    return YES;
}

- (void)layoutKeyboardToolbar {
    if (_keyboardNavigationbar == nil) {
        _keyboardNavigationbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
        _keyboardNavigationbar.barStyle = UIBarStyleBlack;
        UINavigationItem *item = [[UINavigationItem alloc] init];
        _keyboardNavigationbar.items = @[item];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishEditing)];
        _keyboardNavigationbar.items.firstObject.rightBarButtonItem = finish;
        //        [_keyboardNavigationbar jj_setBackgroundColor:[UIColor whiteColor]];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.tv_content.inputAccessoryView = nil;
    if (_tv_content.text.length == 0) {
        _lb_tips.hidden = NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)textViewDidChange:(UITextView *)textView{
    
    if(![textView hasText]) {
         _lb_tips.hidden = NO;
    }
    else{
         _lb_tips.hidden = YES;
    }
    
    if ([CommonUtil unicodeLengthOfString:textView.text] <= 500) {
        _lb_tvLength.text = [NSString stringWithFormat:@"%lu/500",(unsigned long)[CommonUtil unicodeLengthOfString:textView.text]];
        
    }else{
        
        _lb_tvLength.textColor = [UIColor redColor];
        NSString *contentStr = [NSString stringWithFormat:@"-%lu/500",([CommonUtil unicodeLengthOfString:textView.text] - 10)];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#999999"] range:NSMakeRange(contentStr.length - 3, 3)];
        _lb_tvLength.attributedText = str ;
        
    }
}
- (IBAction)btn_commit_pressed:(id)sender {
    UserDomain *_userdomain=[CommonUtil getUserDomain];
     NSString *strUrl = [_tv_content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *paramDic = @{kCustomerPhone:_userdomain.Phone, kContent:strUrl};
    if([self checkInput]){
    [[BaseService sharedService]feedBackWithParameters:paramDic result:^(NSInteger code) {
        if(code == 1){
             _tv_content.text=@"";
             _lb_tips.hidden = NO;
            
            [ProgressHUD showInfo:@"提交成功" withSucc:NO withDismissDelay:2];
        }else{
         [ProgressHUD showInfo:@"提交失败" withSucc:NO withDismissDelay:2];
        }
    }];
    }
}
- (BOOL)checkInput {
    if (![self.tf_email.text isValidEmail]) {
        [ProgressHUD showInfo:@"邮箱不合法" withSucc:NO withDismissDelay:2];
        return NO;
    }
     if ([CommonUtil unicodeLengthOfString:_tv_content.text] > 500) {
         [ProgressHUD showInfo:@"输入内容不能超过500字" withSucc:NO withDismissDelay:2];
         return NO;
     }
     NSString *strUrl = [_tv_content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strUrl.length==0) {
        [ProgressHUD showInfo:@"请输入内容" withSucc:NO withDismissDelay:2];
        return NO;

    }
    return YES;
}
+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
@end
