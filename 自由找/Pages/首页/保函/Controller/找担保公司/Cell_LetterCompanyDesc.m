//
//  Cell_LetterCompanyDesc.m
//  zyz
//
//  Created by 郭界 on 17/1/19.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "Cell_LetterCompanyDesc.h"
#import "BaseConstants.h"
#import <UIImageView+WebCache.h>

@implementation Cell_LetterCompanyDesc
{
    CGFloat _imgWidth;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    _imgWidth = (SCREEN_WIDTH - 106) / 3;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage3:)];
    [_imgv_1 addGestureRecognizer:tap1];
    [_imgv_2 addGestureRecognizer:tap2];
    [_imgv_3 addGestureRecognizer:tap3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    _lb_title.text = dataDic[kCellName];
    _lb_detail.text = dataDic[kCellDefaultText];
    NSArray *tmpArray = dataDic[@"ImgUrl"];
    _imgv_1.hidden = _imgv_2.hidden = _imgv_3.hidden = NO;
    if (tmpArray == nil || tmpArray.count == 0) {
        _imgv_1.hidden = _imgv_2.hidden = _imgv_3.hidden = YES;
        _layout_lbDetail_top.constant = -_imgWidth + 8;
    } else {
        _layout_lbDetail_top.constant = 8;
        if (tmpArray.count == 1) {
            [_imgv_1 sd_setImageWithURL:[NSURL URLWithString:tmpArray.firstObject]];
            _imgv_2.hidden = _imgv_3.hidden = YES;
        } else if (tmpArray.count == 2) {
            [_imgv_1 sd_setImageWithURL:[NSURL URLWithString:tmpArray.firstObject]];
            [_imgv_2 sd_setImageWithURL:[NSURL URLWithString:tmpArray.lastObject]];
            _imgv_3.hidden = YES;
        } else {
            [_imgv_1 sd_setImageWithURL:[NSURL URLWithString:tmpArray.firstObject]];
            [_imgv_2 sd_setImageWithURL:[NSURL URLWithString:tmpArray[1]]];
            [_imgv_3 sd_setImageWithURL:[NSURL URLWithString:tmpArray.lastObject]];
        }
    }
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGFloat totalHeight = [self.lb_detail sizeThatFits:size].height;
    totalHeight += 1;
    if (totalHeight < 48) {
        totalHeight = 48;
    }
    NSArray *tmpArray = _dataDic[@"ImgUrl"];
    if (tmpArray!= nil && tmpArray.count > 0) {
        totalHeight += _imgWidth;
    }
    return CGSizeMake(size.width, totalHeight);
}

- (void)showBigImage1:(UIGestureRecognizer *)recognizer {
    NSString *urlString = [[_dataDic[@"ImgUrl"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"_240_240" withString:@""];
    if ([_delegate respondsToSelector:@selector(showBigImageByImageUrlString:)]) {
        [_delegate showBigImageByImageUrlString:urlString];
    }
}

- (void)showBigImage2:(UIGestureRecognizer *)recognizer {
    NSString *urlString = [[_dataDic[@"ImgUrl"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_240_240" withString:@""];
    if ([_delegate respondsToSelector:@selector(showBigImageByImageUrlString:)]) {
        [_delegate showBigImageByImageUrlString:urlString];
    }
}

- (void)showBigImage3:(UIGestureRecognizer *)recognizer {
    NSString *urlString = [[_dataDic[@"ImgUrl"] objectAtIndex:2] stringByReplacingOccurrencesOfString:@"_240_240" withString:@""];
    if ([_delegate respondsToSelector:@selector(showBigImageByImageUrlString:)]) {
        [_delegate showBigImageByImageUrlString:urlString];
    }
}

@end
