//
//  Cell_MyWallet.m
//  自由找
//
//  Created by xiaoqi on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_MyWallet.h"

@implementation Cell_MyWallet

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithFreeze:(NSString *)freeze avaliable:(NSString *)avalable {
    _lb_freezeMoney.text = freeze;
    _lb_availableMoney.text = avalable;
}

@end
