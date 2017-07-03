//
//  Cell_Producer.m
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Producer.h"
#import "UIImageView+WebCache.h"
#import "BaseConstants.h"

@implementation Cell_Producer

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgv_avater.layer.cornerRadius = 22.5f;
    _imgv_avater.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setProducer:(ProducerDomain *)producer {
    _producer = producer;
    [_imgv_avater sd_setImageWithURL:[NSURL URLWithString:producer.HeadImgUrl] placeholderImage:DEFAULTAVATER];
//    _lb_name.text = producer.Name;
    _lb_name.text= producer.NickName;
    _lb_description.text = producer.Description;
    
}

@end
