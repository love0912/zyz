//
//  AuthenLetterService.m
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "AuthenLetterService.h"

@implementation AuthenLetterService

/**
 申请保函认证
 
 @param authenLetter <#authenLetter description#>
 @param result       <#result description#>
 */
- (void)authenLetterWithDomain:(AuthenLetterDomain *)authenLetter result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = [authenLetter toDictionary];
    [self http3RequestWithUrl:ACTION_AUTHERLETTER_AUTHEN parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 查询保函认证信息
 
 @param result <#result description#>
 */
- (void)getAuthenInfoResult:(void(^)(AuthenLetterDomain *authenLetter, NSInteger code))result{
    [self http3RequestWithUrl:ACTION_VIEW_AUTHENLETTER parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            AuthenLetterDomain *authDomain = [AuthenLetterDomain domainWithObject:responseObject[kResponseDatas]];
            result(authDomain, code);
        } else {
            result(nil, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];
}

@end
