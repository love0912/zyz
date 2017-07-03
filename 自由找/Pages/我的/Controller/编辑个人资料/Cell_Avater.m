//
//  Cell_Avater.m
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Avater.h"

@implementation Cell_Avater

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgv_avater.layer.cornerRadius = _layout_avater_height.constant / 2;
    _imgv_avater.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
