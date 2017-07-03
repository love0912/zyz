//
//  BidLetterHeaderView.m
//  zyz
//
//  Created by 郭界 on 16/11/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BidLetterHeaderView.h"
#import "BaseConstants.h"

@implementation BidLetterHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _lb_city.layer.masksToBounds = YES;
    _lb_city.layer.cornerRadius = 5;
}

- (IBAction)btn_city_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(cityChoice)]) {
        [_delegate cityChoice];
    }
}

- (void)setCity:(NSString *)city {
    _city = city;
//    [_btn_city setTitle:city forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:city];
    
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,
                                   [UIColor colorWithHex:@"E12320"],NSForegroundColorAttributeName,nil];
    
    [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"bidLetter_jiantou"];
    NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeStr1 appendAttributedString:attributeStr2];
    [attributeStr1 insertAttributedString:[[NSAttributedString alloc] initWithString:@"  "] atIndex:0];
    [attributeStr1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    
    _lb_city.attributedText = attributeStr1;
}
@end
