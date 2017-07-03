//
//  Cell_JobTime.m
//  自由找
//
//  Created by xiaoqi on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_JobTime.h"

@implementation Cell_JobTime

- (void)awakeFromNib {
    [super awakeFromNib];
    _lb_startTime.userInteractionEnabled=YES;
    _lb_endTime.userInteractionEnabled=YES;
    UITapGestureRecognizer *startTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTap)];
    UITapGestureRecognizer *endTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTap)];
    [_lb_startTime addGestureRecognizer:startTap];
    [_lb_endTime addGestureRecognizer:endTap];
}
-(void)startTap{
    if ([_delegate respondsToSelector:@selector(tapResult:indexPath:)]) {
        [_delegate tapResult:0 indexPath:_indexPath];
    }
}
-(void)endTap{
    if ([_delegate respondsToSelector:@selector(tapResult:indexPath:)]) {
        [_delegate tapResult:1 indexPath:_indexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
