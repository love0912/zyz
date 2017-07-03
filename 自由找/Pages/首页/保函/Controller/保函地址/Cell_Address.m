//
//  Cell_Address.m
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Address.h"

@implementation Cell_Address

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAddress:(LetterAddressDomain *)address {
    _address = address;
    _lb_name.text = address.Recipient;
    _lb_phone.text = address.Phone;
    _lb_address.text = address.Street;
    if ([address.IsDefault isEqualToString:@"1"]) {
        _btn_select.selected = YES;
    } else {
        _btn_select.selected = NO;
    }
    
}

- (IBAction)btn_edit_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleWithAddress:type:)]) {
        [_delegate handleWithAddress:_address type:1];
    }
}

- (IBAction)btn_delete_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleWithAddress:type:)]) {
        [_delegate handleWithAddress:_address type:2];
    }
}

- (IBAction)btn_select_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleWithAddress:type:)]) {
        [_delegate handleWithAddress:_address type:3];
    }
}
@end
