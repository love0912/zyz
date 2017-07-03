//
//  Cell_RegisterJob.m
//  zyz
//
//  Created by 郭界 on 16/12/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_RegisterJob.h"
#import "BaseConstants.h"

@implementation Cell_RegisterJob

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDataDic:(NSMutableDictionary *)dataDic {
    [self resetData];
    _dataDic = dataDic;
    UIColor *inputColor = [UIColor colorWithHex:@"333333"];
    NSMutableDictionary *dic1 = dataDic[kTechCategory];
    if (dic1 != nil) {
        _lb_specialtyName.text = dic1[kCommonValue];
        _lb_specialtyName.textColor = inputColor;
    } else {
        [self setDefaultName];
    }
    NSMutableDictionary *dic2 = dataDic[kTechLevel];
    if (dic2 != nil) {
        _lb_specialtyLevel.text = dic2[kCommonValue];
        _lb_specialtyLevel.textColor = inputColor;
    } else {
        [self setDefaultLevel];
    }
    NSMutableDictionary *dic3 = dataDic[kMinQty];
    if (dic3 != nil) {
        _lb_specialtyCount.text = dic3[kCommonValue];
        _lb_specialtyCount.textColor = inputColor;
    } else {
        [self setDefaultCount];
    }
}

- (void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
    if (showDelete) {
        _btn_delete.hidden = NO;
//        _btn_clear.hidden = YES;
    } else {
        _btn_delete.hidden = YES;
//        _btn_clear.hidden = NO;
    }
}

- (void)setHideLevel:(BOOL)hideLevel {
    if (hideLevel) {
        _v_levelBack.hidden = YES;
        _layout_vLevelBack_top.constant = 0;
    }
}

- (IBAction)btn_specialtyName_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleDataDic:type:)]) {
        [_delegate handleDataDic:_dataDic type:RegisterJob_Name];
    }
}
- (IBAction)btn_specialtyLevel_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleDataDic:type:)]) {
        [_delegate handleDataDic:_dataDic type:RegisterJob_Level];
    }
}
- (IBAction)btn_specialtyCount_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleDataDic:type:)]) {
        [_delegate handleDataDic:_dataDic type:RegisterJob_Count];
    }
}
- (IBAction)btn_delete_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleDataDic:type:)]) {
        [_delegate handleDataDic:_dataDic type:RegisterJob_Delete];
    }
}
- (IBAction)btn_clear_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(handleDataDic:type:)]) {
        [self resetData];
        [_delegate handleDataDic:_dataDic type:RegisterJob_Clear];
    }
}

- (void)resetData {
    [self setDefaultName];
    [self setDefaultLevel];
    [self setDefaultCount];
}

- (void)setDefaultName {
    _lb_specialtyName.text = @"请选择专业名称";
    _lb_specialtyName.textColor = [UIColor colorWithHex:@"bbbbbb"];
}

- (void)setDefaultLevel {
    _lb_specialtyLevel.text = @"请选择专业等级";
    _lb_specialtyLevel.textColor = [UIColor colorWithHex:@"bbbbbb"];
}

- (void)setDefaultCount {
    _lb_specialtyCount.text = @"请选择数量";
    _lb_specialtyCount.textColor = [UIColor colorWithHex:@"bbbbbb"];
}
@end
