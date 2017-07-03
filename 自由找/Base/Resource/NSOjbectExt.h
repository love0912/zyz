//
//  NSString+NSStringExt.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/25.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObjectExt)

- (BOOL)equals:(id)object;

- (NSString *)toString;

/**
 *  是否是合法的手机号
 *  NSString
 *  @return
 */
- (BOOL)isValidPhone;

//验证邮箱
- (BOOL)isValidEmail;

/**
 *  是否是空串@""
 *
 *  @return <#return value description#>
 */
- (BOOL)isEmptyString;


/**
 不是空串和nil

 @return <#return value description#>
 */
- (BOOL)isNotEmptyString;

/**
 *  去掉两端的空格
 * NSString
 *  @return
 */
- (NSString *)trimWhitesSpace;

/**
 *  密码的合法性
 *
 *  @return
 */
- (BOOL)isValidPassword;

/**
 *  支付密码的合法性
 *
 *  @return <#return value description#>
 */
- (BOOL)isValidPayPassword;

@end
