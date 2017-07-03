//
//  HelpService.h
//  自由找
//
//  Created by guojie on 16/7/15.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"

@interface HelpService : BaseService

/**
 *  获取帮助列表及跳转url
 *
 *  @param result <#result description#>
 */
- (void)getHelpPageToResult:(void (^)(NSArray *arr_help, NSInteger code))result;

@end
