//
//  Cell_MineCustom.m
//  自由找
//
//  Created by guojie on 16/6/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_MineCustom.h"

@implementation Cell_MineCustom

- (void)awakeFromNib {
    [super awakeFromNib];
    _lb_applyCount.layer.masksToBounds = YES;
    _lb_applyCount.layer.cornerRadius = _lb_applyCount.size.width / 2;
    
    _lb_publishCount.layer.masksToBounds = YES;
    _lb_publishCount.layer.cornerRadius = _lb_publishCount.size.width / 2;
    
    _lb_publishCount.hidden = YES;
    _lb_applyCount.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPublishCountNotification:) name:Notification_Set_Publish_Count object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subPublishCount:) name:Notification_Sub_Publish_Count object:nil];
    
}

- (void)setPublishCountNotification:(NSNotification *)notification {
    NSInteger count = [notification.object integerValue];
    [self setPublishCount:count];
}

- (void)subPublishCount:(NSNotification *)notification {
    NSInteger count = [notification.object integerValue];
    NSInteger oriCount = [_lb_publishCount.text integerValue];
    if (oriCount >= count) {
        [self setPublishCount:(oriCount - count)];
    }
}

- (void)setPublishCount:(NSInteger)count {
    if (count <= 0) {
        _lb_publishCount.hidden = YES;
    } else {
        _lb_publishCount.hidden = NO;
    }
    _lb_publishCount.text = [NSString stringWithFormat:@"%ld", count];
}

- (void)setDelegate:(id<MineCustomClickDelegate>)delegate {
    _delegate = delegate;
}

- (void)showCounts {
    
}

- (void)hideCounts {
    
}

- (void)setUser:(UserDomain *)user {
    if (user != nil) {
        [self showCounts];
    } else {
        [self hideCounts];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btn_publish_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWithMineCustomType:)]) {
        [_delegate clickWithMineCustomType:MinePublish];
    }
}

- (IBAction)btn_apply_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWithMineCustomType:)]) {
        [_delegate clickWithMineCustomType:MineApply];
    }
}

- (IBAction)btn_customer_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWithMineCustomType:)]) {
        [_delegate clickWithMineCustomType:MineCustomer];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
