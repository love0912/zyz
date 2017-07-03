//
//  HelpService.m
//  自由找
//
//  Created by guojie on 16/7/15.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "HelpService.h"

@implementation HelpService


/**
 *  获取帮助列表及跳转url
 *
 *  @param result <#result description#>
 */
- (void)getHelpPageToResult:(void (^)(NSArray *arr_help, NSInteger code))result {
    [self httpRequestWithUrl:API_GET_HELP_LIST parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            result(responseObject[kResponseDatas], 1);
        } else {
            result(nil, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];
}

@end
