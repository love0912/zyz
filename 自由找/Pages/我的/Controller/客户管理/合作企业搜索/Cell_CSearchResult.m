//
//  Cell_CSearchResult.m
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_CSearchResult.h"
#import "NSOjbectExt.h"
#import "CommonUtil.h"


@implementation Cell_CSearchResult

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomer:(CustomerDomain *)customer {
    _customer = customer;
    _lb_name.text = customer.CustomerName;
    if (customer.Phone == nil || [customer.Phone isEmptyString]) {
        _btn_call.hidden = YES;
    } else {
        _btn_call.hidden = NO;
    }
}

- (IBAction)btn_call_pressed:(id)sender {
    [CommonUtil callWithPhone:_customer.Phone];
}
@end
