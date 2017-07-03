//
//  Cell_BuyQuery.m
//  zyz
//
//  Created by 郭界 on 17/1/11.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "Cell_BuyQuery.h"
#import "BaseConstants.h"

@implementation Cell_BuyQuery

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        self.contentView.backgroundColor = self.backgroundColor = [UIColor colorWithHex:@"ffeee1"];
    } else {
        self.contentView.backgroundColor = self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setBuyQueryDomain:(BuyQueryDomain *)buyQueryDomain {
    _lb_serviceName.text = buyQueryDomain.ServiceName;
    _lb_serviceDesc.text = [NSString stringWithFormat:@"服务时长：%@个月", buyQueryDomain.ValidPeriod];
    _lb_money.text = [NSString stringWithFormat:@"%@元",buyQueryDomain.Price];
}

@end
