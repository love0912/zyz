//
//  Cell_NewRadio.m
//  zyz
//
//  Created by 郭界 on 16/12/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_NewRadio.h"
#import "BaseConstants.h"

@implementation Cell_NewRadio

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_5_OR_LESS) {
        _layout_radio1_left.constant = 2;
        _layout_radio2_left.constant = 2;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btn_radio1_pressed:(id)sender {
    _btn_radio1.selected = YES;
    _btn_radio2.selected = NO;
    if ([_delegate respondsToSelector:@selector(choiceRadioResult:)]) {
        [_delegate choiceRadioResult:0];
    }
}

- (IBAction)btn_radio2_pressed:(id)sender {
    _btn_radio1.selected = NO;
    _btn_radio2.selected = YES;
    if ([_delegate respondsToSelector:@selector(choiceRadioResult:)]) {
        [_delegate choiceRadioResult:1];
    }
}

- (void)setType:(NSInteger)type {
    if (type == 0) {
        _btn_radio1.selected = YES;
        _btn_radio2.selected = NO;
    } else {
        _btn_radio1.selected = NO;
        _btn_radio2.selected = YES;
    }
}

@end
