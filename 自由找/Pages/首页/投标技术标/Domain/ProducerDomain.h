//
//  ProducerDomain.h
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
// 制作人员Domain

#import "BaseDomain.h"
@class WorkExperienceDomain, ProjectExperienceDomain;

@interface ProducerDomain : BaseDomain

@property (strong, nonatomic) NSString *HeadImgUrl;

@property (strong, nonatomic) NSString *Name;

@property (strong, nonatomic) NSString *NickName;

@property (strong, nonatomic) NSString *Sex;

@property (strong, nonatomic) NSString *Birthday;

/**
 *  （学校）
 */
@property (strong, nonatomic) NSString *Education;

@property (strong, nonatomic) NSString *Description;

@property (strong, nonatomic) NSArray<WorkExperienceDomain *> *WorkExperience;

@property (strong, nonatomic) NSArray<ProjectExperienceDomain *> *ProjectExperience;

@end


@interface WorkExperienceDomain : BaseDomain

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

@interface ProjectExperienceDomain : BaseDomain

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *StartDt;

@property (strong, nonatomic) NSString *EndDt;

/**
 *  (证明人)
 */
@property (strong, nonatomic) NSString *Workmate;

@end