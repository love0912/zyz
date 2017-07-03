//
//  Cell_EvaluateList.m
//  自由找
//
//  Created by guojie on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_EvaluateList.h"
#import "JRateView.h"

@implementation Cell_EvaluateList

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    _imgv_avater.layer.masksToBounds = YES;
    _imgv_avater.layer.cornerRadius = 22.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithEvaluate:(NSObject *)obj {
    JRateView *rateView = [_iv_star viewWithTag:10001];
    if (rateView != nil) {
        [rateView removeFromSuperview];
        rateView = nil;
    }
    rateView = [JRateView rateScoreWithFrame:_iv_star.bounds paddingX:2 Score:3.4 isAnimation:YES allowIncompleteStar:YES rateScore:^(CGFloat score) {
        NSLog(@"%lf", score);
    }];
    rateView.tag = 10001;
    [_iv_star addSubview:rateView];
}

- (void)setEvaluate:(EvaluateDomain *)evaluate {
    _evaluate = evaluate;
    
    JRateView *rateView = [_iv_star viewWithTag:10001];
    if (rateView != nil) {
        [rateView removeFromSuperview];
        rateView = nil;
    }
    rateView = [JRateView rateScoreWithFrame:_iv_star.bounds paddingX:2 Score:[evaluate.Score floatValue] isAnimation:YES allowIncompleteStar:YES rateScore:^(CGFloat score) {
        NSLog(@"%lf", score);
    }];
    rateView.tag = 10001;
    [_iv_star addSubview:rateView];
    
    [_imgv_avater sd_setImageWithURL:[NSURL URLWithString:evaluate.UserHeadImgUrl] placeholderImage:[UIImage imageNamed:@"default_avater"]];
    
    if ([evaluate.IsAnonymous isEqualToString:@"1"]) {
        NSString *name = [NSString stringWithFormat:@"%@**", [evaluate.UserName substringToIndex:1]];
        _lb_name.text = name;
    } else {
        _lb_name.text = evaluate.UserName;
    }
    _lb_date.text = evaluate.PODt;
    _lb_content.text = evaluate.Content;
    _lb_money.text = [NSString stringWithFormat:@"交易金额%@元", evaluate.POAmount];
    
    NSArray *scoreArray = [evaluate.Score componentsSeparatedByString:@"."];
    _lb_scoreInt.text = scoreArray.firstObject;
    _lb_scoreFloat.text = [NSString stringWithFormat:@".%@", scoreArray.lastObject];
    
}

@end
