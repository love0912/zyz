//
//  Cell_ProjectResume.m
//  自由找
//
//  Created by xiaoqi on 16/8/16.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_ProjectResume.h"

@implementation Cell_ProjectResume

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setProject:(ProjectExperienceDomain *)project {
    _lb_time.text=[NSString stringWithFormat:@"%@ 至 %@",project.StartDt,project.EndDt];
    _lb_jobTitleOrBidName.text = project.ProjectName;
    _lb_references.text = [NSString stringWithFormat:@"证明人:%@", project.Workmate];
}

@end
