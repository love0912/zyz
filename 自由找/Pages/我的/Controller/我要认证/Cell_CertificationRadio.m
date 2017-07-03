//
//  Cell_CertificationRadio.m
//  自由找
//
//  Created by xiaoqi on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_CertificationRadio.h"
#import "BaseConstants.h"
@implementation Cell_CertificationRadio

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_5_OR_LESS) {
        _layout_radio1_left.constant = 2;
        _layout_radio2_left.constant = 2;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)btn_radio1_pressed:(id)sender {
    _btn_radio1.selected = YES;
    _btn_radio2.selected = NO;
    if (_cellType==0) {
        if ([_delegate respondsToSelector:@selector(choiceSexRadioResult:)]) {
            [_delegate choiceSexRadioResult:0];
        }

    }else{
        if ([_delegate respondsToSelector:@selector(choiceOrderRadioResult:)]) {
            [_delegate choiceOrderRadioResult:0];
        }
    }
}

- (IBAction)btn_radio2_pressed:(id)sender {
    _btn_radio1.selected = NO;
    _btn_radio2.selected = YES;
    if (_cellType==0) {
        if ([_delegate respondsToSelector:@selector(choiceSexRadioResult:)]) {
            [_delegate choiceSexRadioResult:1];
        }
        
    }else{
        if ([_delegate respondsToSelector:@selector(choiceOrderRadioResult:)]) {
            [_delegate choiceOrderRadioResult:1];
        }
    }
}
- (void)setType:(NSInteger)type {

    if (type == 0) {
        _btn_radio1.selected = YES;
        _btn_radio2.selected = NO;
    }else if (type==-1){
        _btn_radio1.selected = YES;
        _btn_radio2.selected = YES;
    } else {
        _btn_radio1.selected = NO;
        _btn_radio2.selected = YES;
    }
    
}
-(void)setCellType:(NSInteger)cellType{
    _cellType=cellType;
    if (cellType==0) {
        _lb_title.text=@"性别";
        _lb_radio2.text=@"男";
        _lb_radio1.text=@"女";

    }else{
        _lb_title.text=@"接单类型";
        _lb_radio1.text=@"技术标方案";
        _lb_radio2.text=@"投标预算";

    }
}
@end
