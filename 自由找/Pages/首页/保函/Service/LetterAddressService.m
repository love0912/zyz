//
//  LetterAddressService.m
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "LetterAddressService.h"

@implementation LetterAddressService

/**
 获取我的默认地址
 
 @param result
 */
- (void)getOurDefaultAddressToResult:(void(^)(NSInteger code, LetterAddressDomain *letterAddress))result {
    NSDictionary *paramDic = @{@"GetDefault": @"1"};
    [self http3RequestWithUrl:ACTION_LETTERADDRESS_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            if (tmpArray != nil && tmpArray.count > 0) {
                NSDictionary *tmpDic = tmpArray.firstObject;
                LetterAddressDomain *letterAddr = [LetterAddressDomain domainWithObject:tmpDic];
                result(code, letterAddr);
            } else {
                result(code, nil);
            }
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 获取我的地址列表
 
 @param result
 */
- (void)getOurAddressListToResult:(void(^)(NSInteger code, NSArray<LetterAddressDomain*> *list))result{
    [self http3RequestWithUrl:ACTION_LETTERADDRESS_GETLIST parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            if (tmpArray != nil && tmpArray.count > 0) {
                NSMutableArray *addressList = [NSMutableArray arrayWithCapacity:tmpArray.count];
                for (NSDictionary *tmpDic in tmpArray) {
                    LetterAddressDomain *letterAddr = [LetterAddressDomain domainWithObject:tmpDic];
                    [addressList addObject:letterAddr];
                }
                result(code, addressList);
            } else {
                result(code, nil);
            }
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 添加地址
 
 @param address 地址domain
 @param result  <#result description#>
 */
- (void)addAddressByAddressDomain:(LetterAddressDomain *)address result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = [address toDictionary];
    [self http3RequestWithUrl:ACTION_LETTERADDRESS_ADD parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 编辑地址
 
 @param address <#address description#>
 @param result  <#result description#>
 */
- (void)editAddressByAddressDomain:(LetterAddressDomain *)address result:(void(^)(NSInteger code))result{
    NSDictionary *paramDic = [address toDictionary];
    [self http3RequestWithUrl:ACTION_LETTERADDRESS_EDIT parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 删除地址
 
 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)deleteAddressByID:(NSString *)ID result:(void(^)(NSInteger code))result{
    NSDictionary *paramDic = @{@"OId": ID};
    [self http3RequestWithUrl:ACTION_LETTERADDRESS_DELETE parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 设置默认地址
 
 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)setDefaultAddressByID:(NSString *)ID result:(void(^)(NSInteger code))result{
    NSDictionary *paramDic = @{@"OId": ID};
    [self http3RequestWithUrl:ACTION_LETTERADDRESS_SETDEFAULT parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}
@end
