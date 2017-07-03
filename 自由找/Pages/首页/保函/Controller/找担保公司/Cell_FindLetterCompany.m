//
//  Cell_FindLetterCompany.m
//  zyz
//
//  Created by 郭界 on 17/1/9.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "Cell_FindLetterCompany.h"
#import "BaseConstants.h"

@implementation Cell_FindLetterCompany

- (void)awakeFromNib {
    [super awakeFromNib];
    self.v_back.layer.masksToBounds = YES;
    self.v_back.layer.cornerRadius = 5;
    
    if (IS_IPHONE_5_OR_LESS) {
        UIFont *font = [UIFont systemFontOfSize:11];
        _lb_region.font = font;
        _lb_type.font = font;
        _layout_region_width.constant = 100;
    }
}

- (void)setCompany:(LetterCompanyDomain *)company {
    _company = company;
    _lb_name.text = company.MainBiz;
    _lb_company.text = company.Name;
    _lb_type.text = [NSString stringWithFormat:@"经营类别：%@", company.BusinessCategory[kCommonValue]];
    _lb_region.text = [NSString stringWithFormat:@"经营区域：%@", company.RegionTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
