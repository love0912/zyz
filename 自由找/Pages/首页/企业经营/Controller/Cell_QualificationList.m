//
//  Cell_QualificationList.m
//  自由找
//
//  Created by xiaoqi on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_QualificationList.h"
#import "BaseConstants.h"

@implementation Cell_QualificationList

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setBidList:(QualificaListDomian *)bidList{
    _bidList = bidList;
    NSMutableArray *creditstrArray=[[NSMutableArray alloc]init];
    self.lb_companyName.text=bidList.CompanyName;

    if (bidList.Status != nil && [bidList.Status isEqualToString:@"USED"]) {
        [self.btn_certification setTitle:bidList.RegionName forState:UIControlStateNormal];
        [self.btn_certification setImage:[UIImage imageNamed:@"renzheng"] forState:UIControlStateNormal];
    }else{
        [self.btn_certification setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btn_certification setTitle:bidList.RegionName forState:UIControlStateNormal];
    }
    if (![bidList.CreditRoad isEmptyString]) {
        NSString *creditsting=[NSString stringWithFormat:@"公路:%@",bidList.CreditRoad];
        [creditstrArray addObject:creditsting];

    }
    if (![bidList.CreditShip isEmptyString]) {
        NSString *creditsting=[NSString stringWithFormat:@"水运:%@",bidList.CreditShip];
        [creditstrArray addObject:creditsting];
        
    }
    if (![bidList.CreditWater isEmptyString]) {
        NSString *creditsting=[NSString stringWithFormat:@"水利:%@",bidList.CreditWater];
        [creditstrArray addObject:creditsting];

    }
    if (![bidList.CreditBuild isEmptyString]) {
         NSString *creditsting=[NSString stringWithFormat:@"建筑市政:%@",bidList.CreditBuild];
         [creditstrArray addObject:creditsting];
     }
    if (![bidList.CreditPark isEmptyString]) {
        NSString *creditsting=[NSString stringWithFormat:@"园林:%@",bidList.CreditPark];
        [creditstrArray addObject:creditsting];

    }
    _lb_credit1.hidden=NO;
    _lb_credit2.hidden=NO;
    _lb_credit3.hidden=NO;
    _lb_credit4.hidden=NO;
    _lb_credit5.hidden=NO;
    _layout_companytoTop.constant=15;

    if (creditstrArray.count==1) {
        _lb_credit1.text=creditstrArray[0];
        _lb_credit2.hidden=YES;
        _lb_credit3.hidden=YES;
        _lb_credit4.hidden=YES;
        _lb_credit5.hidden=YES;

    }else if (creditstrArray.count==2){
        _lb_credit1.text=creditstrArray[0];
        _lb_credit2.text=creditstrArray[1];
        _lb_credit3.hidden=YES;
        _lb_credit4.hidden=YES;
        _lb_credit5.hidden=YES;

    }else if (creditstrArray.count==3){
        _lb_credit1.text=creditstrArray[0];
        _lb_credit2.text=creditstrArray[1];
        _lb_credit3.text=creditstrArray[2];
        _lb_credit4.hidden=YES;
        _lb_credit5.hidden=YES;

    }else if (creditstrArray.count==4){
        _lb_credit1.text=creditstrArray[0];
        _lb_credit2.text=creditstrArray[1];
        _lb_credit3.text=creditstrArray[2];
        _lb_credit4.text=creditstrArray[3];
        _lb_credit5.hidden=YES;

    }else if (creditstrArray.count==5){
        _lb_credit1.text=creditstrArray[0];
        _lb_credit2.text=creditstrArray[1];
        _lb_credit3.text=creditstrArray[2];
        _lb_credit4.text=creditstrArray[3];
        _lb_credit5.text=creditstrArray[4];

        
    }else{
        _lb_credit1.hidden=YES;
        _lb_credit2.hidden=YES;
        _lb_credit3.hidden=YES;
        _lb_credit4.hidden=YES;
        _lb_credit5.hidden=YES;
        _layout_companytoTop.constant=25;
    }
    
}
@end
