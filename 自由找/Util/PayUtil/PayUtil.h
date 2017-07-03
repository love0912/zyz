//
//  PayUtil.h
//  自由找
//
//  Created by guojie on 16/8/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface PayUtil : NSObject

+ (void)alipayWithOrder:(NSString *)orderString fromScheme:(NSString *)appScheme callback:(void(^)(NSDictionary *resultDic))completionBlock;

@end
