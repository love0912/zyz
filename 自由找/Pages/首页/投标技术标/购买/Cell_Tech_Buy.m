//
//  Cell_Tech_Buy.m
//  自由找
//
//  Created by xiaoqi on 16/7/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Tech_Buy.h"
#import "BaseConstants.h"

@implementation Cell_Tech_Buy
-(void)initView{
//    NSString *oldStr = [NSString stringWithFormat:@"原价:¥9000元/份"];
//    //中划线
//    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
//    _lb_originalPrice.attributedText = attribtStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _v_back.layer.shadowColor = [UIColor blackColor].CGColor;
    _v_back.layer.shadowOffset = CGSizeMake(-1,1);//shadowOffset阴影偏移,x向左偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _v_back.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    _v_back.layer.shadowRadius = 1;//阴影半径，默认3
    
    _lb_bizDesc.layer.cornerRadius = 2;
    _lb_bizDesc.layer.masksToBounds = YES;
    
    if (IS_IPHONE_5_OR_LESS) {
        UIFont *textFont = [UIFont systemFontOfSize:9];
        _lb_monthSales.font = textFont;
//        _lb_originalPrice.font = textFont;
//        _btn_knock.titleLabel.font = textFont;
//        _layout_knock_width.constant = 55;
        _lb_discountPrice.font = [UIFont boldSystemFontOfSize:12];
        
    }
    
}

- (void)setProduct:(ProductDomain *)product {
    _product = product;
//    NSString *oldStr = [NSString stringWithFormat:@"原价:%@元/份", product.StandardPrice];
    //中划线
//    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
////    _lb_originalPrice.attributedText = attribtStr;
    
    _lb_discountPrice.text = [NSString stringWithFormat:@"￥%@元/份", product.DiscountPrice];
    _lb_monthSales.text = [NSString stringWithFormat:@"月售%@笔", product.SalesCount];
//    NSInteger price = [product.StandardPrice integerValue] - [product.DiscountPrice integerValue];
//    NSString *title = [NSString stringWithFormat:@"立减%d元", price];
//    [_btn_knock setTitle:product.BizDescription forState:UIControlStateNormal];
    
    [_iv_bg sd_setImageWithURL:[NSURL URLWithString:[product.LogoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"jishu_Buy_1"]];
    
    _lb_name.text = product.Name;
    _lb_bizDesc.text = product.Description;
    CGRect rect = [_lb_bizDesc.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil];
    _layout_bizDesc_width.constant = rect.size.width + 8;
    
}

@end
