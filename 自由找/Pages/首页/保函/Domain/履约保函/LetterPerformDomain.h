//
//  LetterPerformDomain.h
//  自由找
//
//  Created by 郭界 on 16/10/19.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"

@interface LetterPerformDomain : BaseDomain


/**
 保函唯一编号”
 */
@property (strong, nonatomic) NSString *SerialNo;


/**
 保函创建人唯一编号
 */
@property (strong, nonatomic) NSString *CreatorOId;

/**
 项目名称
 */
@property (strong, nonatomic) NSString *ProjectName;

/**
 “项目所在区域” {Key/Value}   50000/重庆
 */
@property (strong, nonatomic) KeyValueDomain *ProjectArea;

/**
 项目类别” {Key/Value}    111/市政
 */
@property (strong, nonatomic) KeyValueDomain *ProjectCategory;

/**
 “中标企业”
 */
@property (strong, nonatomic) NSString *Company;

/**
 “业主名称
 */
@property (strong, nonatomic) NSString *OwnerName;

/**
 保函金额”
 */
@property (strong, nonatomic) NSString *Amount;

/**
 “保函期限”
 */
@property (strong, nonatomic) NSString *Period;

/**
 “2016-11-9”
 */
@property (strong, nonatomic) NSString *CreateDt;

/**
 <#Description#>
 */
@property (strong, nonatomic) NSString *UpdateDt;

/**
 “联系电话
 */
@property (strong, nonatomic) NSString *Phone;

/**
 “1” –完成  0—未完成
 */
@property (strong, nonatomic) NSString *Status;


@property (strong, nonatomic) NSString *Url;


/**
 备注
 */
@property (strong, nonatomic) NSString *Remark;


/**
 “1” –已经收藏 “0”
 */
@property (strong, nonatomic) NSString *IsFavorited;
@end
