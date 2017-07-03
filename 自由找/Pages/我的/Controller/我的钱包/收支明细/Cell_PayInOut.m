//
//  Cell_PayInOut.m
//  自由找
//
//  Created by guojie on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_PayInOut.h"

@implementation Cell_PayInOut

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExpand:(ExpendDomain *)expand {
    _lb_name.text = expand.Summary;
    _lb_money.text = expand.Value;
    _lb_date.text = expand.CreateDt;
}

@end
