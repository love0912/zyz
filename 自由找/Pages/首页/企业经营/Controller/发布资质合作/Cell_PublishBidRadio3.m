//
//  Cell_PublishBidRadio3.m
//  自由找
//
//  Created by guojie on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_PublishBidRadio3.h"
#import "BaseConstants.h"

@implementation Cell_PublishBidRadio3

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_5_OR_LESS) {
        _layout_btn1_left.constant = 2;
        _layout_btn2_left.constant = 2;
        _layout_btn3_left.constant = 2;
    }
    if (IS_IPHONE_6P) {
        _constraint_leading.constant = 20;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btn1_pressed:(id)sender {
    _btn1.selected = YES;
    _btn2.selected = NO;
    _btn3.selected = NO;
    if ([_delegate respondsToSelector:@selector(choiceRadio3Result:)]) {
        [_delegate choiceRadio3Result:0];
    }
}

- (IBAction)btn2_pressed:(id)sender {
    if (_pushType==1) {
        if (_dic==nil) {
            [ProgressHUD showInfo:@"请先选择区域" withSucc:NO withDismissDelay:2];
            return;
            
        }else{
            _btn1.selected = NO;
            _btn2.selected = YES;
            _btn3.selected = NO;
            if ([_delegate respondsToSelector:@selector(choiceRadio3Result:)]) {
                [_delegate choiceRadio3Result:1];
            }
        }
        
    }else{
        _btn1.selected = NO;
        _btn2.selected = YES;
        _btn3.selected = NO;
    if ([_delegate respondsToSelector:@selector(choiceRadio3Result:)]) {
        [_delegate choiceRadio3Result:1];
    }
}
}

- (IBAction)btn3_pressed:(id)sender {
    if (_pushType==1) {
        if (_dic==nil) {
            [ProgressHUD showInfo:@"请先选择区域" withSucc:NO withDismissDelay:2];
            return;
            
        }else{
            _btn1.selected = NO;
            _btn2.selected = NO;
            _btn3.selected = YES;
            if ([_delegate respondsToSelector:@selector(choiceRadio3Result:)]) {
                [_delegate choiceRadio3Result:2];
            }
        }
        
    }else{

    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = YES;
    if ([_delegate respondsToSelector:@selector(choiceRadio3Result:)]) {
        [_delegate choiceRadio3Result:2];
    }
    }
}

- (void)setType:(NSInteger)type {
    if (type == 0) {
        _btn1.selected = YES;
        _btn2.selected = NO;
        _btn3.selected = NO;
    } else if(type == 1) {
        _btn1.selected = NO;
        _btn2.selected = YES;
        _btn3.selected = NO;
    } else {
        _btn1.selected = NO;
        _btn2.selected = NO;
        _btn3.selected = YES;
    }
}

- (void)setOtherCompanyName:(NSString *)otherCompanyName {
    if (otherCompanyName == nil || otherCompanyName.isEmptyString) {
        _lb_otherCompany.text = @"外地企业";
    } else {
        _lb_otherCompany.text = [NSString stringWithFormat:@"入%@企业", otherCompanyName];
    }
}
@end
