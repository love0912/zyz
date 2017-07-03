//
//  Cell_Message.m
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Message.h"
#import <UIImageView+WebCache.h>
@implementation Cell_Message

- (void)awakeFromNib {
    [super awakeFromNib];
    _IV_messageHead.layer.masksToBounds = YES;
    _IV_messageHead.layer.cornerRadius = _IV_messageHead.bounds.size.width / 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMessagedomain:(MessageDomain *)messagedomain{
    _messagedomain = messagedomain;
    if ([messagedomain.RelevancyType isEqualToString:@"14"] || [messagedomain.RelevancyType isEqualToString:@"17"]  || [messagedomain.RelevancyType isEqualToString:@"100"]) {
        [_IV_messageHead setImage:[UIImage imageNamed:@"default_avater"]];
        _lb_messageName.text = @"系统消息";
    } else {
        [_IV_messageHead sd_setImageWithURL:[NSURL URLWithString:messagedomain.HeadImg] placeholderImage:[UIImage imageNamed:@"default_avater"]];
        _lb_messageName.text = messagedomain.SenderName;
    }
    _lb_messageDetail.text = messagedomain.Content;
    if (messagedomain.InsertTime.length > 10) {
        _lb_messageDate.text = [messagedomain.InsertTime substringToIndex:10];
    } else {
        _lb_messageDate.text = messagedomain.InsertTime;
    }
    [self changeStatus];
}
- (void)changeStatus {
    if ([_messagedomain.State isEqualToString:@"USED"]) {
        //未读
        _iv_red.hidden=NO;
    } else {
        _iv_red.hidden=YES;
    }
}
- (void)setReadedStatus {
    _iv_red.hidden=YES;
}
@end
