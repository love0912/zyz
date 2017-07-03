//
//  ProducerDomain.h
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
// 制作人员Domain

#import "BaseDomain.h"
#import "UserDomain.h"
@class WorkExperienceDomain, ProjectExperienceDomain, MaxQuantityDomain;

@interface ProducerDomain : BaseDomain

@property (strong, nonatomic) NSString *HeadImgUrl;

@property (strong, nonatomic) NSString *Name;

@property (strong, nonatomic) NSString *NickName;

@property (strong, nonatomic) NSString *Sex;

@property (strong, nonatomic) NSString *Birthday;

@property (strong, nonatomic) KeyValueDomain *Region;

/**
 *  USED” /“REVIEWING”/”REJECT”/”NOREVIEW
 */
@property (strong, nonatomic) NSNumber *AuthStatus;

/**
 *   1 技术 2预算
 */
@property (strong, nonatomic) NSString *ProductType;

/**
 *  （学校）
 */
@property (strong, nonatomic) NSString *Education;

@property (strong, nonatomic) NSString *Description;

@property (strong, nonatomic) NSArray<WorkExperienceDomain *> *WorkExperiences;

@property (strong, nonatomic) NSArray<ProjectExperienceDomain *> *ProjectExperiences;
@property (strong, nonatomic) NSString *ExpertCategory;
@property (strong, nonatomic) KeyValueDomain *ProductLevel;
@property (strong, nonatomic) NSArray<MaxQuantityDomain *> *MaxQuantity;
@property (strong, nonatomic) NSString *IdentityFrontSideUrl;
@property (strong, nonatomic) NSString *IdentityBackSideUrl;
@property (strong, nonatomic) NSString *CertificateUrl;
@end


@interface WorkExperienceDomain : BaseDomain<NSCoding>

/**
 *  (公司或者组织)
 */
@property (strong, nonatomic) NSString *Organization;

/**
 *  （部门）
 */
@property (strong, nonatomic) NSString *Department;

/**
 *  （职位）
 */
@property (strong, nonatomic) NSString *Job;

@property (strong, nonatomic) NSString *JobDescription;

@property (strong, nonatomic) NSString *StartDt;

@property (strong, nonatomic) NSString *EndDt;

/**
 *  (证明人)
 */
@property (strong, nonatomic) NSString *Workmate;

@end



@interface ProjectExperienceDomain : BaseDomain<NSCoding>

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *StartDt;

@property (strong, nonatomic) NSString *EndDt;
@property (strong, nonatomic) NSString *Job;
/**
 *  (证明人)
 */
@property (strong, nonatomic) NSString *Workmate;

@end
@interface MaxQuantityDomain : BaseDomain
@property (strong, nonatomic) KeyValueDomain *ProductLevel;
@property (strong, nonatomic)NSString *MaxQuantity;
@end
