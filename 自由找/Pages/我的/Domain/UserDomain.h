//
//  UserDomain.h
//  自由找
//
//  Created by guojie on 16/6/13.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
@class SiteDomain;
@class ContactDomain;
@class KeyValueDomain;
@class AptitudesDomain;
@class EnterpriseDomain;

@interface UserDomain : BaseDomain<NSCoding>

@property (strong, nonatomic) NSString *UserId;

@property (strong, nonatomic) NSString *UserName;

@property (strong, nonatomic) NSString *Account;

@property (strong, nonatomic) NSString *InviteCode;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *HeadImg;

@property (strong, nonatomic) NSString *Score;

/**
 *  评价星星
 */
@property (strong, nonatomic) NSString *Rank;

@property (strong, nonatomic) NSDictionary *TodoList;

@property (strong, nonatomic) NSArray<SiteDomain *> *Sites;

@end

@interface SiteDomain : BaseDomain<NSCoding>

@property (strong, nonatomic) NSString *CompanyId;

@property (strong, nonatomic) NSString *CompanyName;

@property (strong, nonatomic) NSString *CompanyType;

@property (strong, nonatomic) ContactDomain *Contact;

@property (strong, nonatomic) NSString *Status;

@property (strong, nonatomic) KeyValueDomain *Location;

@property (strong, nonatomic) EnterpriseDomain *Enterprise;

/**
 *   //用户ID 和Ownerid 相同，则可以编辑绑定企业
 */
@property (strong, nonatomic) NSString *OwnerId;

@property (strong, nonatomic) NSString *OwnDateTime;

/**
 *  诚信得分
 */
@property (strong, nonatomic) NSDictionary *Credits;

@property (strong, nonatomic) NSString *Url;

@end

@interface ContactDomain : BaseDomain<NSCoding>

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *Name;

@end

@interface EnterpriseDomain : BaseDomain<NSCoding>

@property (strong, nonatomic) NSString *Name;

@property (strong, nonatomic) NSString *Type;

@property (strong, nonatomic) NSArray<AptitudesDomain *> *CompanyAptitudes;

@end


/**
 *   资质
 */
@interface AptitudesDomain : BaseDomain<NSCoding>
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *AptitudeKey;
@property (strong, nonatomic) NSString *CreateTime;
@property (strong, nonatomic) NSString *CompanyId;
@property (strong, nonatomic) NSString *AptitudeName;
@property (strong, nonatomic) NSString *AptitudeGrade;
@end
@interface KeyValueDomain : BaseDomain<NSCoding>

@property (strong, nonatomic) NSString *Key;

@property (strong, nonatomic) NSString *Value;

@property (strong, nonatomic) NSString *Alias;

@property (strong, nonatomic) NSArray *SubCollection;

@end
