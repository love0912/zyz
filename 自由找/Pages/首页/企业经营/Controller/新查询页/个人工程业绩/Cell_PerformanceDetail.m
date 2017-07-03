//
//  Cell_PerformanceDetail.m
//  zyz
//
//  Created by 郭界 on 17/1/19.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "Cell_PerformanceDetail.h"
#import "BaseConstants.h"


@implementation Cell_PerformanceDetail

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _lb_title.text = dataDic[kCellName];
    _lb_detail.text = dataDic[kCellDefaultText];
}

@end
