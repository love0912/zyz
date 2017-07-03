//
//  QualificaDomian.h
//  自由找
//
//  Created by xiaoqi on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
@class  QualificaListDomian;

@interface QualificaDomian : BaseDomain
@property (strong, nonatomic) NSString *Count;
@property (strong, nonatomic) NSArray<QualificaListDomian *> *Items;
@end
@interface QualificaListDomian : BaseDomain
@property (strong, nonatomic) NSString *CompanyId;
@property (strong, nonatomic) NSString *CompanyOId;
@property (strong, nonatomic) NSString *CompanyName;
@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *RegionName;
@property (strong, nonatomic) NSString *CreditRoad;
//@property (strong, nonatomic) NSString *CreditDeliver;
@property (strong, nonatomic) NSString *CreditWater;
@property (strong, nonatomic) NSString *CreditBuild;
@property (strong, nonatomic) NSString *CreditPark;
@property (strong, nonatomic) NSString *CreditShip;
@property (strong, nonatomic) NSString *CreditLevel;
@property (strong, nonatomic) NSString *Url;

@end

@interface CompanyListDomian : BaseDomain
@property (strong, nonatomic) NSString *CompanyName;
@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *Url;
@end


