//
//  InCompanyDomain.h
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
@class CompanyAptitudesDomain;
@interface InCompanyDomain : BaseDomain<NSCoding>
@property (strong, nonatomic) NSString *CompanyId;
@property (strong, nonatomic) NSString *CompanyName;
@property (strong, nonatomic) NSString *CreditDeliver;
@property (strong, nonatomic) NSString *CreditWater;
@property (strong, nonatomic) NSString *CreditBuild;
@property (strong, nonatomic) NSString *CreditPark;
@property (strong, nonatomic) NSString *CreditLevel;
@property (strong, nonatomic) NSArray<CompanyAptitudesDomain *> *CompanyAptitudes;
@end
@interface CompanyAptitudesDomain : BaseDomain<NSCoding>
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *AptitudeKey;
@property (strong, nonatomic) NSString *CreateTime;
@property (strong, nonatomic) NSString *CompanyId;
@property (strong, nonatomic) NSString *AptitudeName;
@property (strong, nonatomic) NSString *AptitudeGrade;
@end
