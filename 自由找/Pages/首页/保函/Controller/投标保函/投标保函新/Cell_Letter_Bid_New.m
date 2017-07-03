//
//  Cell_Letter_Bid_New.m
//  zyz
//
//  Created by 郭界 on 16/11/25.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Letter_Bid_New.h"

@implementation Cell_Letter_Bid_New

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBidLetter:(BidLetterDomain *)bidLetter {
    _bidLetter = bidLetter;
    _lb_letterName.text = bidLetter.CategoryName;
    _lb_letterBank.text = [NSString stringWithFormat:@"%@%@", bidLetter.Bank, bidLetter.SubBank];
    NSString *realPrice;
    if ([bidLetter.PayMode isEqualToString:@"1"]) {
        //费率
        CGFloat f = [bidLetter.PayParameter floatValue] * 100;
        NSString *fString = [NSString stringWithFormat:@"%f", f];
        realPrice = [NSString stringWithFormat:@"费率：%@%%起", [CommonUtil removeFloatAllZero:fString]];
    } else {
        //阶梯价
        realPrice = [NSString stringWithFormat:@"费用：￥%@起", [CommonUtil removeFloatAllZero:bidLetter.PayParameter]];
    }
    _lb_price.text = realPrice;
    
    if (bidLetter.SummaryLines_2.count > 0) {
        NSDictionary *tmpDic = bidLetter.SummaryLines_2.firstObject;
        [self layoutLabel:_lb_minPrice fontInfoDic:tmpDic[@"Style"]];
        _lb_minPrice.text = tmpDic[@"Value"];
    }
    if (bidLetter.SummaryLines_2.count > 1) {
        NSDictionary *tmpDic = [bidLetter.SummaryLines_2 objectAtIndex:1];
        [self layoutLabel:_lb_priceWay fontInfoDic:tmpDic[@"Style"]];
        _lb_priceWay.text = tmpDic[@"Value"];
    }
    if (bidLetter.SummaryLines_2.count > 2) {
        NSDictionary *tmpDic = bidLetter.SummaryLines_2.lastObject;
        [self layoutLabel:_lb_active fontInfoDic:tmpDic[@"Style"]];
        _lb_active.text = tmpDic[@"Value"];
    }
    if (bidLetter.BizDescription != nil && ![bidLetter.BizDescription isEqualToString:@""]) {
        _lb_active.text = bidLetter.BizDescription;
        [self layoutActiveLabelColorByType:2];
    } else {
        [self layoutActiveLabelColorByType:1];
    }
    
    if ([bidLetter.IsRecommented isEqualToString:@"1"]) {
        _imgv_recommend.hidden = NO;
    } else {
        _imgv_recommend.hidden = YES;
    }
//    NSInteger test = 1;
//    if (test == 1) {
//        _imgv_recommend.hidden = NO;
//    }
    
    [self layoutUI];
}

- (void)layoutLabel:(UILabel *)label fontInfoDic:(NSDictionary *)fontInfo {
//    NSString *fontColor = fontInfo[@"FontColor"];
//    if (fontColor != nil && [fontColor hasPrefix:@"#"]) {
//        fontColor = [fontColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
//        label.textColor = [UIColor colorWithHex:fontColor];
//    }
//    NSString *bold = fontInfo[@"FontBody"];
//    if (bold != nil && [bold isEqualToString:@"1"]) {
//        label.font = [UIFont boldSystemFontOfSize:12];
//    }
}

- (void)layoutUI {
    UIFont *letterNameFont = [UIFont boldSystemFontOfSize:16];
    CGFloat letterNameWidth = [CommonUtil widthWithText:_lb_letterName.text labelHeight:20 font:letterNameFont];
    _layout_letterName_width.constant = letterNameWidth + 4;
    
    UIFont *letterBankFont = [UIFont systemFontOfSize:14];
    CGFloat letterBankWidth = [CommonUtil widthWithText:_lb_letterBank.text labelHeight:17 font:letterBankFont];
    _layout_letterBank_width.constant = letterBankWidth + 4;
    
    UIFont *priceWayFont = [UIFont systemFontOfSize:12];
    CGFloat priceWayWidth = [CommonUtil widthWithText:_lb_priceWay.text labelHeight:15 font:priceWayFont];
    _layout_priceWay_width.constant = priceWayWidth + 4;
    
    NSMutableAttributedString *priceAttri = [[NSMutableAttributedString alloc] initWithString:_lb_price.text];
    [priceAttri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(3, priceAttri.length - 3)];
    _lb_price.attributedText = priceAttri;
}

- (void)layoutActiveLabelColorByType:(NSInteger)type {
    if (type == 1) {
        _lb_active.textColor = [UIColor colorWithHex:Color_Exprie];
    } else {
        _lb_active.textColor = [UIColor colorWithHex:Color_Active];
    }
}

@end
