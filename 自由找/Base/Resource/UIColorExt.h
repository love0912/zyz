//
//  UIColor+UIColorExt.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/25.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorExt)

+ (UIColor*) colorWithHex:(NSString *)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSString *)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

@end
