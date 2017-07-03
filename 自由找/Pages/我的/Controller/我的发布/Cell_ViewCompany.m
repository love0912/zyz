//
//  Cell_ViewCompany.m
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_ViewCompany.h"
//最右边按钮的位置
#define FirstRightButtonConstant 15
//右边第二个按钮位置
#define SecondRightButtonConstant 83
#define ThirdRightButtonConstant 151
#define FourthRightButtonConstant 219

#define NameLabelMinRight 50

#define AgreeLabelTag 1000
#define DisagreeLabelTag 1001
#define ReturnLabelTag 1002

@implementation Cell_ViewCompany

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAttentionUser:(AttentionUserDomain *)attentionUser {
    _attentionUser = attentionUser;
    _lb_name.text = attentionUser.CompanyName;
    _lb_score.text = [NSString stringWithFormat:@"诚信得分：%@", attentionUser.Credit];
    _lb_contact.text = [NSString stringWithFormat:@"联系人：%@", attentionUser
                        .Contact];
    
    if (attentionUser.Phone == nil || [attentionUser.Phone isEmptyString]) {
        _btn_call.hidden = YES;
    }

    [self layoutCellSubViews];
    
}

/**
 *  根据状态调整布局
 */
- (void)layoutCellSubViews {
    switch (_attentionUser.Marker) {
        case 0:
        {
            //不同意
            [self showDisagreeCell];
        }
            break;
        case 1:
        {
            //同意
            [self showAgreeCell];
        }
            break;
        case 2:
        {
            //最新
            [self showLatestCell];
        }
            break;
        case 4:
        {
            //撤回
            [self showReturnCell];
        }
            break;
        case 8:
        {
            //退回
            [self showReturnCell];
        }
            break;
            
        default:
            break;
    }
}

//最新
- (void)showLatestCell {
    _btn_disagree.hidden = NO;
    _btn_assess.hidden = NO;
    _btn_assess.enabled = YES;
    if (![_attentionUser.PublishRank isEmptyString]) {
//        _btn_assess.hidden = YES;
        _btn_assess.enabled = NO;
    }
    _btn_agree.hidden = NO;
    _btn_return.hidden = NO;
    
    _btn_disagree.selected = NO;
    _btn_agree.selected = NO;
    
    _layout_disagree_right.constant = SecondRightButtonConstant;
    _layout_return_right.constant = ThirdRightButtonConstant;
    _layout_access_right.constant = FourthRightButtonConstant;
    _layout_lb_name_right.constant = 2;
    
    [self removeAgreeTag];
    [self removeLabelWithTag:DisagreeLabelTag];
    [self removeLabelWithTag:ReturnLabelTag];
}

//不同意
- (void)showDisagreeCell {
    _btn_disagree.hidden = YES;
    _btn_assess.hidden = YES;
    _btn_agree.hidden = NO;
    _btn_agree.selected = YES;
    _btn_return.hidden = NO;
    _layout_return_right.constant = SecondRightButtonConstant;
    _layout_lb_name_right.constant = NameLabelMinRight;
    
    UILabel *lb_disagree = [self.contentView viewWithTag:DisagreeLabelTag];
    if (lb_disagree == nil) {
        lb_disagree = [[UILabel alloc] init];
        lb_disagree.tag = DisagreeLabelTag;
        lb_disagree.backgroundColor = [UIColor colorWithHex:@"fa3f31"];
        lb_disagree.textColor = [UIColor whiteColor];
        lb_disagree.textAlignment = NSTextAlignmentCenter;
        lb_disagree.font = [UIFont systemFontOfSize:10];
        lb_disagree.text = @"不同意";
        lb_disagree.layer.masksToBounds = YES;
        lb_disagree.layer.cornerRadius = 2;
        [self.contentView addSubview:lb_disagree];
        
        [lb_disagree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_v_top.mas_bottom).with.offset(15);
            make.left.equalTo(_lb_name.mas_right).with.offset(6);
            make.height.equalTo(_lb_name.mas_height);
            make.width.mas_equalTo(40);
        }];
    }
    
    [self removeAgreeTag];
    [self removeLabelWithTag:ReturnLabelTag];
}

//同意
- (void)showAgreeCell {
    _btn_disagree.hidden = NO;
    _btn_disagree.selected = YES;
    _btn_assess.hidden = YES;
    _btn_agree.hidden = YES;
    _btn_return.hidden = NO;
    
    _layout_disagree_right.constant = FirstRightButtonConstant;
    _layout_return_right.constant = SecondRightButtonConstant;
    _layout_lb_name_right.constant = NameLabelMinRight;
    
    UIButton *btn_agree = [self.contentView viewWithTag:AgreeLabelTag];
    if (btn_agree == nil) {
        btn_agree = [UIButton buttonWithType:UIButtonTypeSystem];
        btn_agree.tag = AgreeLabelTag;
        [btn_agree.titleLabel setFont:[UIFont systemFontOfSize:10]];
        btn_agree.enabled = NO;
        btn_agree.translatesAutoresizingMaskIntoConstraints = NO;
        [btn_agree setBackgroundImage:[UIImage imageNamed:@"ApplyCompany_agree"] forState:UIControlStateDisabled];
        [btn_agree setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [btn_agree setTitle:@"已同意" forState:UIControlStateDisabled];
        [btn_agree setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.contentView addSubview:btn_agree];
        [btn_agree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_v_top.mas_bottom).with.offset(15);
            make.left.equalTo(_lb_name.mas_right).with.offset(6);
            make.width.mas_equalTo(50);
        }];
    }
    
    [self removeLabelWithTag:DisagreeLabelTag];
    [self removeLabelWithTag:ReturnLabelTag];
}

- (void)showReturnCell {
    _btn_disagree.hidden = YES;
    _btn_assess.hidden = YES;
    _btn_agree.hidden = YES;
    _btn_return.hidden = YES;
    _layout_lb_name_right.constant = NameLabelMinRight;
    
    UILabel *lb_return = [self.contentView viewWithTag:ReturnLabelTag];
    if (lb_return == nil) {
        lb_return = [[UILabel alloc] init];
        lb_return.tag = ReturnLabelTag;
        lb_return.backgroundColor = [UIColor colorWithHex:@"cccccc"];
        lb_return.textColor = [UIColor whiteColor];
        lb_return.textAlignment = NSTextAlignmentCenter;
        lb_return.font = [UIFont systemFontOfSize:10];
        lb_return.layer.masksToBounds = YES;
        lb_return.layer.cornerRadius = 2;
        NSString *text = @"已退回";
        if (_attentionUser.Marker == 4) {
            text = @"已撤回";
        }
        lb_return.text = text;
        [self.contentView addSubview:lb_return];
        
        [lb_return mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_v_top.mas_bottom).with.offset(15);
            make.left.equalTo(_lb_name.mas_right).with.offset(6);
            make.height.equalTo(_lb_name.mas_height);
            make.width.mas_equalTo(40);
        }];
    }
    
    [self removeAgreeTag];
    [self removeLabelWithTag:DisagreeLabelTag];
}

- (void)removeAgreeTag {
    UIButton *btn_agree = [self.contentView viewWithTag:AgreeLabelTag];
    if (btn_agree != nil) {
        [btn_agree removeFromSuperview];
    }
}

- (void)removeLabelWithTag:(NSInteger)tag {
    UILabel *label = [self.contentView viewWithTag:tag];
    if (label != nil) {
        [label removeFromSuperview];
    }
}

- (IBAction)btn_call_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickViewCompany:type:)]) {
        [_delegate clickViewCompany:_attentionUser type:ViewCompanyCall];
    }
}

- (IBAction)btn_agree_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickViewCompany:type:)]) {
        [_delegate clickViewCompany:_attentionUser type:ViewCompanyAgree];
    }
}

- (IBAction)btn_disagree_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickViewCompany:type:)]) {
        [_delegate clickViewCompany:_attentionUser type:ViewCompanyDisagree];
    }
}

- (IBAction)btn_return_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickViewCompany:type:)]) {
        [_delegate clickViewCompany:_attentionUser type:ViewCompanyReturn];
    }
}

- (IBAction)btn_assess_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickViewCompany:type:)]) {
        [_delegate clickViewCompany:_attentionUser type:ViewCompanyAccess];
    }
}
@end
