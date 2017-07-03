//
//  Cell_ScoreDetail.m
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_ScoreDetail.h"

@implementation Cell_ScoreDetail

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setScore:(ScoreDomain *)score {
    _lb_name.text = score.ScoreName;
    _lb_date.text = score.CreateTime;
    NSString *scoreStr = @"+";
    if (_type == 2) {
        scoreStr = @"";
    }
    _lb_score.text = [NSString stringWithFormat:@"%@%@", scoreStr, score.ScoreValue];
}

@end
