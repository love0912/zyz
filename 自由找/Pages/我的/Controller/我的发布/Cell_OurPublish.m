//
//  Cell_OurPublish.m
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_OurPublish.h"
#import "BaseConstants.h"

@implementation Cell_OurPublish

- (void)awakeFromNib {
    [super awakeFromNib];
    _lb_count.layer.masksToBounds = YES;
    _lb_count.layer.cornerRadius = 8;
    
    if (IS_IPHONE_5_OR_LESS) {
        _layout_exportCompany_right.constant = _layout_viewCompany_right.constant = _layout_edit_right.constant = _layout_del_right.constant = 2.5;
    }
    _lb_type.hidden = YES;
}

- (void)setBidList:(BidListDomain *)bidList {
    _bidList = bidList;
    NSString *name = [NSString stringWithFormat:@"%@ %@", bidList.ProjectNo, bidList.ProjectName];
    _lb_name.text = name;
    _lb_date.text = bidList.CreateDate;
    _lb_region.text = bidList.RegionValue;
    _lb_count.text = [NSString stringWithFormat:@"%ld", bidList.SignUpUnread];
    if (bidList.SignUpUnread == 0) {
        _lb_count.hidden = YES;
    } else {
        _lb_count.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btn_delete_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWithBidList:type:)]) {
        [_delegate clickWithBidList:_bidList type:OurPublishDelete];
    }
}

- (IBAction)btn_edit_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWithBidList:type:)]) {
        [_delegate clickWithBidList:_bidList type:OurPublishEdit];
    }
}

- (IBAction)btn_exportCompany_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWithBidList:type:)]) {
        [_delegate clickWithBidList:_bidList type:OurPublishExportCompany];
    }
}

- (IBAction)btn_viewCompany_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWithBidList:type:)]) {
        [_delegate clickWithBidList:_bidList type:OurPublishViewCompany];
    }
}
@end
