//
//  Cell_MyCollection.m
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_MyCollection.h"

@implementation Cell_MyCollection

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMycollection:(ProjectOrderDomain *)mycollection{
    _mycollection=mycollection;
    _lb_projectname.text=mycollection.ProjectTitle;
    [_btn_projectType setTitle:mycollection.ProjectType.Value forState:UIControlStateNormal];
    if (mycollection.StartDeliveryDt !=nil && mycollection.EndDeliveryDt !=nil) {
        _lb_time.text=[NSString stringWithFormat:@"%@~%@",mycollection.StartDeliveryDt,mycollection.EndDeliveryDt];
    }else{
        _lb_time.text=[NSString stringWithFormat:@"%@",mycollection.EndDeliveryDt];
    }
    if (mycollection.MinSalesPrice !=nil && mycollection.MaxSalesPrice !=nil&& ![mycollection.MaxSalesPrice isEqualToString:mycollection.MinSalesPrice]) {
        _lb_price.text=[NSString stringWithFormat:@"%@~%@元",mycollection.MinSalesPrice,mycollection.MaxSalesPrice];
    }else{
        _lb_price.text=[NSString stringWithFormat:@"%@元",mycollection.MaxSalesPrice];
    }
}
@end
