//
//  VC_TextField.m
//  自由找
//
//  Created by guojie on 16/7/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_TextField.h"

@interface VC_TextField ()
{
    NSString *_odlText;
}
@end

@implementation VC_TextField

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    if (_maxCount == 0) {
        _maxCount = 50;
    }
    
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (_type == INPUT_TYPE_NORMAL) {
        _textField.keyboardType = UIKeyboardTypeDefault;
    } else if (_type == INPUT_TYPE_NUMBER) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (_type == INPUT_TYPE_PASSWORD) {
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.secureTextEntry = YES;
    } else if (_type == INPUT_TYPE_DECIMAL || _type == INPUT_TYPE_MONEY_WAN) {
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    } else {
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    
    [self layoutUI];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)layoutUI {
    [self layoutRightItem];
    
    if (_jTitle == nil || [_jTitle isEmptyString]) {
        _jTitle = @"请输入";
    }
    if (_placeholder == nil || [_placeholder isEmptyString]) {
        _placeholder = _jTitle;
    }
    _textField.placeholder = _placeholder;
    self.jx_title = _jTitle;
    
    if (_text != nil) {
        _textField.text = _text;
    }
    _odlText = _textField.text;
    if (_jUnit != nil && ![_jUnit isEmptyString]) {
        _lb_unit.hidden = NO;
        _lb_unit.text = _jUnit;
    } else {
        _lb_unit.hidden = YES;
    }
    
    NSString *text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)_textField.text.length, (long)_maxCount];
    _lb_count.text = text;
    
}

- (void)layoutRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commitPressed)];
    [self setNavigationBarRightItem:item];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.textField) {
        if (_maxCount > 0 ) {
            //            if ( textField.text.length > _maxCount) {
            //                textField.text = [textField.text substringToIndex:_maxCount];
            
            
            //            }
            NSString *toBeString = textField.text;
            NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; //[[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
            NSString *title = [NSString stringWithFormat:@"最大字数为%ld,您的输入超过字数限制!", (long)_maxCount];
            if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [textField markedTextRange];
                //获取高亮部分
                UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (!position) {
                    if (toBeString.length > _maxCount) {
                        textField.text = [toBeString substringToIndex:_maxCount];
                        [ProgressHUD showInfo:title withSucc:NO withDismissDelay:2];
                    }
                }
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
                else{
                    
                }
            }
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            else{
                if (toBeString.length > _maxCount) {
                    textField.text = [toBeString substringToIndex:_maxCount];
                    [ProgressHUD showInfo:title withSucc:NO withDismissDelay:2];
                }
            }
            [self setCountLabelText];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField && _type == INPUT_TYPE_MONEY_WAN) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        if (futureString.length > 0) {
            unichar single = [futureString characterAtIndex:0];
            if(single == '.') {
                [ProgressHUD showInfo:@"第一个不能输入小数点" withSucc:NO withDismissDelay:2];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        if (futureString.length == 2) {
            unichar single = [futureString characterAtIndex:0];
            unichar second = [futureString characterAtIndex:1];
            if(single == '0' && second == '0') {
                [textField.text stringByReplacingCharactersInRange:range withString:@"0"];
                return NO;
            }
            if (single == '0' && second != '0' && second != '.') {
                textField.text = [NSString stringWithFormat:@"%c", second];
                return NO;
            }
        }
        
        NSInteger flag=0;
        const NSInteger limited = 4;  //小数点  限制输入两位
        for (int i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    [ProgressHUD showInfo:@"只能输入4位小数" withSucc:NO withDismissDelay:2];
                    return NO;
                }
                break;
            }
            flag++;
        }
        
        return YES;
    }
    return YES;
}

- (void)setCountLabelText {
    NSString *text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)_textField.text.length, (long)_maxCount];
    _lb_count.text = text;
}

- (void)backPressed {
    [_textField resignFirstResponder];
    if ([_odlText isEqualToString:_textField.text.trimWhitesSpace]) {
        [self goBack];
    } else {
        [JAlertHelper jAlertWithTitle:@"你还未保存输入项" message:@"是否保存" cancleButtonTitle:@"否" OtherButtonsArray:@[@"保存"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self commit];
            } else {
                [self goBack];
            }
        }];
    }
}

- (void)commitPressed {
    [_textField resignFirstResponder];
    [self commit];
}

- (void)commit {
    NSString *strUrl = [_textField.text.trimWhitesSpace stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_minCount > 0 && strUrl.length < _minCount) {
        NSString *title = [NSString stringWithFormat:@"您必须输入最少%ld个有效字符", (long)_minCount];
        [ProgressHUD showInfo:title withSucc:NO withDismissDelay:2];
    } else {
        if (_type == INPUT_TYPE_DECIMAL) {
            if (_maxValue !=0 && _maxValue > _minValue) {
                if (![strUrl isEmptyString]) {
                    CGFloat floatValue = [strUrl floatValue];
                    if (floatValue < _minValue || floatValue > _maxValue) {
                        NSString *title = [NSString stringWithFormat:@"输入范围为%lf到%lf", _minValue, _maxValue];
                        [ProgressHUD showInfo:title withSucc:NO withDismissDelay:2];
                        return;
                    }
                }
            }
            self.inputBlock(strUrl);
            [self goBack];
        } else {
            self.inputBlock(strUrl);
            [self goBack];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
