//
//  JAddressManager.h
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JxJSON.h"

@interface JAddressManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,strong) NSArray *provinceDicAry;//省字典数组

#define kJAddressManager [JAddressManager shareInstance]

@end
