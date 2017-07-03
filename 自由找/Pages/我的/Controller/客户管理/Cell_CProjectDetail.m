//
//  Cell_CProjectDetail.m
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_CProjectDetail.h"

@implementation Cell_CProjectDetail

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithDic:(NSDictionary *)dic {
    _lb_name.text = dic[kCellName];
    _lb_value.text = dic[kCellDefaultText];
    
    if ([dic[kCellName] isEqualToString:@"联系电话"] && ![dic[kCellDefaultText] isEqualToString:NoneText]) {
        _btn_phone.hidden = NO;
        _btn_message.hidden = NO;
        _layout_value_right.constant = 15 + 10 + 30 + 8 + 30;
    } else {
        _btn_phone.hidden = YES;
        _btn_message.hidden = YES;
        _layout_value_right.constant = 15;
    }
    if (dic[kCellDefaultText]==nil || [dic[kCellDefaultText] isEqualToString:@""]) {
        _btn_phone.hidden = YES;
        _btn_message.hidden = YES;
    }
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGFloat totalHeight = [self.lb_value sizeThatFits:size].height;;
    totalHeight += 1;
    if (totalHeight < 48) {
        totalHeight = 48;
    }
    return CGSizeMake(size.width, totalHeight);
}

- (IBAction)btn_phone_pressed:(id)sender {
    [_delegate phone];
}

- (IBAction)btn_message_pressed:(id)sender {
    [_delegate message];
}
@end
