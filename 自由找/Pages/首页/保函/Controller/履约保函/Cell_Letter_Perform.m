//
//  Cell_Letter_Perform.m
//  自由找
//
//  Created by 郭界 on 16/9/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Letter_Perform.h"
#import "CommonUtil.h"

@implementation Cell_Letter_Perform

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setLetterPerform:(LetterPerformDomain *)letterPerform {
    _letterPerform = letterPerform;
    _lb_name.text = letterPerform.ProjectName;
    _lb_createDate.text = [NSString stringWithFormat:@"发布日期：%@", letterPerform.CreateDt];
    CGFloat money = [letterPerform.Amount floatValue] / 10000;
    NSString *moneyString = [NSString stringWithFormat:@"%@万", [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%f", money]]];
    _lb_money.text = moneyString;
    _lb_expireDate.text = [NSString stringWithFormat:@"保函期限：%@天", letterPerform.Period];
    
    CGRect rect = [_lb_money.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 24) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
    _layout_money_width.constant = rect.size.width + 4;
}

@end
