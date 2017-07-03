//
//  Cell_Evaluate.m
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Evaluate.h"
#import "JRateView.h"
#import "BaseConstants.h"

@implementation Cell_Evaluate

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    _imgv_avater.layer.masksToBounds = YES;
    _imgv_avater.layer.cornerRadius = 20;
    
    if (IS_IPHONE_5_OR_LESS) {
        UIFont *font = [UIFont systemFontOfSize:11];
        _lb_name.font = font;
        _lb_money.font = font;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btn_viewAll_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(viewAllEvaluate)]) {
        [_delegate viewAllEvaluate];
    }
}

- (void)configWithEvaluateDomain:(NSObject *)evaluate {
    JRateView *rateView = [_v_star viewWithTag:10001];
    if (rateView != nil) {
        [rateView removeFromSuperview];
        rateView = nil;
    }
    rateView = [JRateView rateScoreWithFrame:_v_star.bounds paddingX:2 Score:3.4 isAnimation:YES allowIncompleteStar:YES rateScore:^(CGFloat score) {
        
    }];
    rateView.tag = 10001;
    [_v_star addSubview:rateView];
}

- (void)setEvaluate:(EvaluateDomain *)evaluate {
    _evaluate = evaluate;
    JRateView *rateView = [_v_star viewWithTag:10001];
    if (rateView != nil) {
        [rateView removeFromSuperview];
        rateView = nil;
    }
    
    rateView = [JRateView rateScoreWithFrame:_v_star.bounds paddingX:2 Score:[evaluate.Score floatValue] isAnimation:YES allowIncompleteStar:YES rateScore:^(CGFloat score) {
    }];
//    rateView = [JRateView rateScoreWithFrame:CGRectMake(0, 0, 120, 20) paddingX:2 Score:[evaluate.Score floatValue] isAnimation:YES allowIncompleteStar:YES rateScore:^(CGFloat score) {
//    }];
    rateView.tag = 10001;
    [_v_star addSubview:rateView];
    
    [_imgv_avater sd_setImageWithURL:[NSURL URLWithString:evaluate.UserHeadImgUrl] placeholderImage:[UIImage imageNamed:@"default_avater"]];
    
    
    if ([evaluate.IsAnonymous isEqualToString:@"1"]) {
        NSString *name = [NSString stringWithFormat:@"%@**", [evaluate.UserName substringToIndex:1]];
        _lb_name.text = name;
    } else {
        _lb_name.text = evaluate.UserName;
    }
    
    NSString *dateMoney = [NSString stringWithFormat:@"%@ 交易金额%@元", evaluate.PODt, evaluate.POAmount];
    _lb_money.text = dateMoney;
    
    _lb_content.text = evaluate.Content;
}

@end
