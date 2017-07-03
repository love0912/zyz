//
//  Cell_Tech_SearchOrder.m
//  自由找
//
//  Created by xiaoqi on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Tech_SearchOrder.h"
#import "ProgressHUD.h"
#import "BaseConstants.h"

@implementation Cell_Tech_SearchOrder

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)btn_collection_press:(id)sender {
    UIButton *btn=(UIButton *)sender;
    if ([_projectOrder.IsFavorited isEqualToString:@"1"]) {
        [ProgressHUD showInfo:@"您已收藏" withSucc:YES withDismissDelay:2];
    }else{
        if (btn.selected == YES){
            if ([_delegate respondsToSelector:@selector(collectionResult:projectID:)]) {
                [_delegate collectionResult:0 projectID:_projectOrder.SummaryId];
            }
//            btn.selected= NO;
        }else{
            if ([_delegate respondsToSelector:@selector(collectionResult:projectID:)]) {
                [_delegate collectionResult:1 projectID:_projectOrder.SummaryId];
            }
//            btn.selected= YES;
        
        }
    }
}

- (void)setProjectOrder:(ProjectOrderDomain *)projectOrder {
    _projectOrder = projectOrder;
    _lb_projectName.text = projectOrder.ProjectTitle;
    [_btn_projectType setTitle:projectOrder.ProjectType.Value forState:UIControlStateNormal];
    NSString *orderString = @"可接单";
    if ([projectOrder.IsLimited isEqualToString:@"1"]) {
        orderString = @"接单已满";
        [_btn_order setImage:nil forState:UIControlStateNormal];
        [_btn_order setBackgroundImage:[UIImage imageNamed:@"tech_order_btn"] forState:UIControlStateNormal];
        [_btn_order setTitleColor:[UIColor colorWithHex:@"666666"] forState:UIControlStateNormal];
    } else {
        [_btn_order setImage:[UIImage imageNamed:@"unable_order"]forState:UIControlStateNormal];
        [_btn_order setBackgroundImage:[UIImage imageNamed:@"tech_order_btn_can_recieve"] forState:UIControlStateNormal];
        [_btn_order setTitleColor:[UIColor colorWithHex:@"ff7c24"] forState:UIControlStateNormal];
    }
    [_btn_order setTitle:orderString forState:UIControlStateNormal];
    if ([projectOrder.IsFavorited isEqualToString:@"1"]) {
        _btn_collection.selected=YES;
    }else{
        _btn_collection.selected=NO;
    }
    NSString *dateString = [NSString stringWithFormat:@"交稿时间段:%@~%@", projectOrder.StartDeliveryDt, projectOrder.EndDeliveryDt];
    if ([projectOrder.StartDeliveryDt isEqualToString:projectOrder.EndDeliveryDt]) {
        dateString = [NSString stringWithFormat:@"交稿时间%@", projectOrder.StartDeliveryDt];
    }
    _lb_time.text = dateString;
    if (projectOrder.MinSalesPrice !=nil && projectOrder.MaxSalesPrice !=nil && ![projectOrder.MaxSalesPrice isEqualToString:projectOrder.MinSalesPrice]) {
        _lb_price.text=[NSString stringWithFormat:@"%@~%@元",projectOrder.MinSalesPrice,projectOrder.MaxSalesPrice];
    }else{
        _lb_price.text=[NSString stringWithFormat:@"%@元",projectOrder.MaxSalesPrice];
    }
//    NSString *priceString = [NSString stringWithFormat:@"%@~%@元", projectOrder.MinSalesPrice, projectOrder.MaxSalesPrice];
//    _lb_price.text = priceString;
}

@end
