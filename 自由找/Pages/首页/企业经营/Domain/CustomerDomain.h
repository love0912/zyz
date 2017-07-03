//
//  CustomerDomain.h
//  自由找
//
//  Created by guojie on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"

@interface CustomerDomain : BaseDomain

@property (strong, nonatomic) NSString *CustomerId;

@property (strong, nonatomic) NSString *CustomerName;

@property (strong, nonatomic) NSArray<KeyValueDomain *> *CustomerAptitudes;

@property (strong, nonatomic) NSString *Contact;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *Remark;

@property (strong, nonatomic) NSString *Cooperation;

@property (strong, nonatomic) NSString *ProfessionalDesc;

@end
