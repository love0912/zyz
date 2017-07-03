//
//  AuthenLetterDomain.h
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface AuthenLetterDomain : BaseDomain

@property (strong, nonatomic) NSString *Name;

@property (strong, nonatomic) NSString *Job;

@property (strong, nonatomic) NSString *Company;

@property (strong, nonatomic) NSString *ImgUrl;


/**
 “0/1/2/4”   NOREVIEW =0/ REVIEWING=1/ USED=2/REJECT=4
 */
@property (strong, nonatomic) NSString *AuthStatus;

@end
