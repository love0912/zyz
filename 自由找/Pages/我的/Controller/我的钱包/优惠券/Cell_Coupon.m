//
//  Cell_Coupon.m
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Coupon.h"
#import "BaseConstants.h"

@implementation Cell_Coupon

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_5_OR_LESS) {
        _lb_money.font = [UIFont systemFontOfSize:30];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCoupon:(CouponDomain *)coupon {
    if ([coupon.IsFrozen isEqualToString:@"1"]) {
        _imgv_left.image = [UIImage imageNamed:@"coupon_cellBack_disable"];
        _imgv_tag_disable.hidden = NO;
    } else {
        _imgv_left.image = [UIImage imageNamed:@"coupon_cellBack_normal"];
        _imgv_tag_disable.hidden = YES;
    }
    _lb_money.text = coupon.Value;
    _lb_name.text = coupon.Title;
    NSArray *descArray = [coupon.Description componentsSeparatedByString:@"|"];
    _lb_desc1.text = descArray.firstObject;
    _lb_desc2.text = descArray.lastObject;
    _lb_desc3.text = [NSString stringWithFormat:@"有效期至%@", coupon.ExpireTime];
    
}

@end
