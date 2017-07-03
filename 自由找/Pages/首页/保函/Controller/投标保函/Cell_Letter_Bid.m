//
//  Cell_Letter_Bid.m
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Letter_Bid.h"
#import "BaseConstants.h"
#import "UIImageView+WebCache.h"

@implementation Cell_Letter_Bid

- (void)awakeFromNib {
    [super awakeFromNib];
    _v_back.layer.shadowColor = [UIColor blackColor].CGColor;
    _v_back.layer.shadowOffset = CGSizeMake(-1,1);//shadowOffset阴影偏移,x向左偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _v_back.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    _v_back.layer.shadowRadius = 1;//阴影半径，默认3
    
    _lb_cansale.layer.cornerRadius = 2;
    _lb_cansale.layer.masksToBounds = YES;
    
    _lb_city.layer.cornerRadius = 5;
    _lb_city.layer.masksToBounds = YES;
    
    if (IS_IPHONE_5_OR_LESS) {
        UIFont *textFont = [UIFont systemFontOfSize:8];
        _lb_real_price.font = textFont;
        _lb_cansale.font = textFont;
        _lb_ori_price.font = textFont;
        _lb_count.font = textFont;
        
        
        _layout_lbDesc1_top.constant =
        _layout_lbDesc2_top.constant = _layout_lbDesc3_top.constant = 6;
    }
    
}

- (void)setBidLetter:(BidLetterDomain *)bidLetter {
    _bidLetter = bidLetter;
    NSString *realPrice;
    NSString *oldPrice;
    //立减好多
//    NSString *subString;
    
    if ([_bidLetter.PayMode isEqualToString:@"1"]) {
        //费率
        //放到设值里面
        CGFloat f = [bidLetter.PayParameter floatValue] * 100;
        NSString *fString = [NSString stringWithFormat:@"%f", f];
        realPrice = [NSString stringWithFormat:@"费率：%@%%", [CommonUtil removeFloatAllZero:fString]];
        CGFloat f1 = bidLetter.PayParameterOrginal.floatValue * 100;
//        CGFloat sub = f1 - f;
        NSString *f1String = [NSString stringWithFormat:@"%f", f1];
//        NSString *subS = [NSString stringWithFormat:@"%f", sub];
        
        oldPrice = [NSString stringWithFormat:@"原费率：%@%%", [CommonUtil removeFloatAllZero:f1String]];
//        subString = [NSString stringWithFormat:@"立减%@%%", [CommonUtil removeFloatAllZero:subS]];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:realPrice];
        CGFloat realFontSize = 15;
//        if (IS_IPHONE_5_OR_LESS) {
//            realFontSize = 11;
//        }
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:realFontSize] range:NSMakeRange(3, realPrice.length - 3)];
        _lb_real_price.attributedText = str;
    } else {
        //阶梯价
        realPrice = [NSString stringWithFormat:@"价格：￥%@起", [CommonUtil removeFloatAllZero:bidLetter.PayParameter]];
        oldPrice = [NSString stringWithFormat:@"原价：￥%@起", [CommonUtil removeFloatAllZero:bidLetter.PayParameterOrginal]];
        
//        NSInteger tmpSubCount = [bidLetter.PayParameterOrginal integerValue] - [bidLetter.PayParameter integerValue];
//        subString = [NSString stringWithFormat:@"立减%ld元", tmpSubCount];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:realPrice];
        CGFloat realFontSize = 15;
//        if (IS_IPHONE_5_OR_LESS) {
//            realFontSize = 11;
//        }
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:realFontSize] range:NSMakeRange(4, realPrice.length - 4)];
        _lb_real_price.attributedText = str;
    }
    //中划线
    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPrice attributes:attribtDic];
    _lb_ori_price.attributedText = attribtStr;
    
    
    if (bidLetter.BizDescription == nil || [bidLetter.BizDescription isEmptyString]) {
        _lb_cansale.hidden = YES;
    } else {
        _lb_cansale.hidden = NO;
    }
    _lb_cansale.text = bidLetter.BizDescription;
//    _lb_cansale.text = @"今日特价10份";
    CGRect rect = [_lb_cansale.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8]} context:nil];
    _layout_cansale_width.constant = rect.size.width + 8;
    
    _lb_count.text = [NSString stringWithFormat:@"月售%@笔", bidLetter.PerSalesCount];
    
//    [_iv_logo sd_setImageWithURL:[NSURL URLWithString:bidLetter.LogoUrl] placeholderImage:[UIImage imageNamed:@"jishu_Buy_1"]];
    
    [_iv_bankLogo sd_setImageWithURL:[NSURL URLWithString:[bidLetter.LogoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_iv_background sd_setImageWithURL:[NSURL URLWithString:[bidLetter.LogoBackgroundUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"bidLetterBackground"]];
    
    
    _lb_city.text = [NSString stringWithFormat:@"%@分行", bidLetter.Region.Value];
    CGRect rect1 = [_lb_city.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    _layout_lbCity_width.constant = rect1.size.width + 10;
//    [self layoutDescLabelDefault];
//    if (bidLetter.SummaryLines_1.count > 0) {
//        NSDictionary *tmpDic = bidLetter.SummaryLines_1.firstObject;
//        [self layoutLabel:_lb_desc_1 fontInfoDic:tmpDic[@"Style"]];
//        _lb_desc_1.text = tmpDic[@"Value"];
//    }
//    if (bidLetter.SummaryLines_1.count > 1) {
//        NSDictionary *tmpDic = [bidLetter.SummaryLines_1 objectAtIndex:1];
//        [self layoutLabel:_lb_desc_2 fontInfoDic:tmpDic[@"Style"]];
//        _lb_desc_2.text = tmpDic[@"Value"];
//    }
//    if (bidLetter.SummaryLines_1.count > 2) {
//        NSDictionary *tmpDic = bidLetter.SummaryLines_1.lastObject;
//        [self layoutLabel:_lb_desc_3 fontInfoDic:tmpDic[@"Style"]];
//        _lb_desc_3.text = tmpDic[@"Value"];
//    }
}

- (void)layoutDescLabelDefault {
    _lb_desc_1.textColor = [UIColor whiteColor];
    _lb_desc_1.font = [UIFont systemFontOfSize:15];
    _lb_desc_2.textColor = [UIColor whiteColor];
    _lb_desc_2.font = [UIFont systemFontOfSize:15];
    _lb_desc_3.textColor = [UIColor whiteColor];
    _lb_desc_3.font = [UIFont systemFontOfSize:15];
}

- (void)layoutLabel:(UILabel *)label fontInfoDic:(NSDictionary *)fontInfo {
    NSString *fontColor = fontInfo[@"FontColor"];
    if (fontColor != nil && [fontColor hasPrefix:@"#"]) {
        fontColor = [fontColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        label.textColor = [UIColor colorWithHex:fontColor];
    }
    NSString *bold = fontInfo[@"FontBody"];
    if (bold != nil && [bold isEqualToString:@"1"]) {
        label.font = [UIFont boldSystemFontOfSize:15];
    }
}

@end
