//
//  Cell_CertificationOverview.m
//  自由找
//
//  Created by xiaoqi on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_CertificationOverview.h"
#import "CommonUtil.h"
#import "BaseConstants.h"

@interface Cell_CertificationOverview ()
{
    UINavigationBar *_keyboardNavigationbar;
}
@end

@implementation Cell_CertificationOverview

- (void)awakeFromNib {
    [super awakeFromNib];
    _tv_content.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _lb_tips.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_tv_content.text.length == 0) {
        _lb_tips.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"endrefreshPersonView" object:nil];

    if ([_delegate respondsToSelector:@selector(contentResult:)]) {
        [_delegate contentResult:_tv_content.text];
    }
    
}

#pragma mark - keyboard toolbar
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

#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self layoutKeyboardToolbar];
    self.tv_content.inputAccessoryView = _keyboardNavigationbar;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPersonView" object:nil];
    return YES;
}

- (void)finishEditing {
    [self endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self endEditing:YES];
    [_tv_content resignFirstResponder];

}
@end
