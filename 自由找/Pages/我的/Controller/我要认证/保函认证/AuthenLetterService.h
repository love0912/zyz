//
//  AuthenLetterService.h
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "AuthenLetterDomain.h"

@interface AuthenLetterService : BaseService


/**
 申请保函认证

 @param authenLetter <#authenLetter description#>
 @param result       <#result description#>
 */
- (void)authenLetterWithDomain:(AuthenLetterDomain *)authenLetter result:(void(^)(NSInteger code))result;


/**
 查询保函认证信息

 @param result <#result description#>
 */
- (void)getAuthenInfoResult:(void(^)(AuthenLetterDomain *authenLetter, NSInteger code))result;

@end
