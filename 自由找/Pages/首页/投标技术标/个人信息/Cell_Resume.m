//
//  Cell_Resume.m
//  自由找
//
//  Created by xiaoqi on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Resume.h"

@implementation Cell_Resume

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWork:(WorkExperienceDomain *)work {
    _lb_startTime.text = work.StartDt;
    _lb_endTime.text = work.EndDt;
    _lb_companyName.text = work.Organization;
    _lb_jobTitleOrBidName.text = work.Job;
    _lb_references.text = [NSString stringWithFormat:@"证明人:%@", work.Workmate];
}


@end
