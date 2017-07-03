//
//  Cell_CustomerDetail.m
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_CustomerDetail.h"
#import "KeyDefine.h"
#import "CommonUtil.h"

@implementation Cell_CustomerDetail

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
        _btn_call.hidden = NO;
        _layout_value_right.constant = 15 + 10 + 30;
    } else {
        _btn_call.hidden = YES;
        _layout_value_right.constant = 15;
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

- (IBAction)btn_call_pressed:(id)sender {
    if (![_lb_value.text isEqualToString:NoneText]) {
        [CommonUtil callWithPhone:_lb_value.text];
    }
}
@end
