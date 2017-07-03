//
//  Cell_MineOrders.m
//  自由找
//
//  Created by xiaoqi on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_MineOrders.h"
#import "UIImageView+WebCache.h"
#import "UIColorExt.h"

@implementation Cell_MineOrders

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrder:(OrderInfoDomain *)order {
    _order = order;
    _lb_projectName.text = order.ProjectName;
    [_iv_projectType sd_setImageWithURL:[NSURL URLWithString:order.LogoUrl] placeholderImage:[UIImage imageNamed:@"ordertake_1"]];
    _lb_projectType.text = order.ProductName;
    _lb_buyNumbers.text = [NSString stringWithFormat:@"x%@", order.Quantity];
    _lb_time.text = order.CreateDt;
    if ([order.ProductType isEqualToString:@"1"]) {
        _lb_productType.text = @"技术标";
    } else if ([order.ProductType isEqualToString:@"2"]) {
        _lb_productType.text = @"预算";
    } else {
        _lb_productType.text = @"投标保函";
        [_iv_projectType setImage:[UIImage imageNamed:@"bh_my_order"]];
    }
    _lb_productType.textColor = [UIColor colorWithHex:@"ff1f1f"];
    if ([order.Status isEqualToString:@"3"]) {
        _lb_productType.textColor = [UIColor colorWithHex:@"999999"];
    }
    
    
    [self layoutStatus];
}

- (void)layoutStatus {
    //待付款
    NSString *status = _order.Status;
    NSString *imageName = [NSString stringWithFormat:@"ordertake_bq%@", status];
    if ([_order.ProductType isEqualToString:@"3"] && [status isEqualToString:@"3"]) {
        imageName = [NSString stringWithFormat:@"%@_3", imageName];
    }
    _iv_orderStautes.image = [UIImage imageNamed:imageName];
}

@end
