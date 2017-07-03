//
//  LetterAddressService.h
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "LetterAddressDomain.h"

@interface LetterAddressService : BaseService

/**
 获取我的默认地址

 @param result
 */
- (void)getOurDefaultAddressToResult:(void(^)(NSInteger code, LetterAddressDomain *letterAddress))result;

/**
 获取我的地址列表
 
 @param result
 */
- (void)getOurAddressListToResult:(void(^)(NSInteger code, NSArray<LetterAddressDomain*> *list))result;


/**
 添加地址

 @param address 地址domain
 @param result  <#result description#>
 */
- (void)addAddressByAddressDomain:(LetterAddressDomain *)address result:(void(^)(NSInteger code))result;


/**
 编辑地址

 @param address <#address description#>
 @param result  <#result description#>
 */
- (void)editAddressByAddressDomain:(LetterAddressDomain *)address result:(void(^)(NSInteger code))result;


/**
 删除地址

 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)deleteAddressByID:(NSString *)ID result:(void(^)(NSInteger code))result;


/**
 设置默认地址

 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)setDefaultAddressByID:(NSString *)ID result:(void(^)(NSInteger code))result;
@end
