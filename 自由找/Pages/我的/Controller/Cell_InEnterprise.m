//
//  Cell_InEnterprise.m
//  自由找
//
//  Created by xiaoqi on 16/6/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_InEnterprise.h"

@implementation Cell_InEnterprise

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSits:(SiteDomain *)sits{
    _lb_CompanyName.text=sits.CompanyName;
}
-(void)setIncompany:(InCompanyDomain *)incompany{
    _lb_CompanyName.text=incompany.CompanyName;
}
@end
