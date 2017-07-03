//
//  NSString+NSStringExt.m
//  奔跑兄弟
//
//  Created by guojie on 16/4/25.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import "NSOjbectExt.h"

@implementation  NSObject (NSObjectExt)

- (BOOL)equals:(id)object {
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self isEqualToString:object];
    }
    return [self isEqual:object];
}

- (NSString *)toString {
    if (![self isKindOfClass:[NSNull class]]) {
        return [NSString stringWithFormat:@"%@", self];
    }
    return @"";
}

- (BOOL)isValidPhone {
    if ([self isKindOfClass:[NSString class]]) {
        NSString * MOBILE = @"^1([3-9][0-9])\\d{8}$";        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        if (([regextestmobile evaluateWithObject:self] == YES))
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isValidEmail {
    if ([self isKindOfClass:[NSString class]]) {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailPredicate evaluateWithObject:self];
    }
    return NO;
}

- (BOOL)isEmptyString {
    if (self == nil) {
        return YES;
    }
    if ([self isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)self;
        return [str.trimWhitesSpace isEqualToString:@""];
    }
    return NO;
}

- (BOOL)isNotEmptyString {
    if (self == nil) {
        return NO;
    }
    if ([self isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)self;
        return ![str.trimWhitesSpace isEqualToString:@""];
    }
    return NO;
}

- (NSString *)trimWhitesSpace {
    if ([self isKindOfClass:[NSString class]]) {
        NSString *srcStr = (NSString *)self;
        return [srcStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return [NSString stringWithFormat:@""];
}

- (BOOL)isValidPassword {
    if ([self isKindOfClass:[NSString class]]) {
//        NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
        NSString *pattern = @"[0-9a-zA-Z~!@#$^&_+]{6,12}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:self];
        return isMatch;
    }
    return NO;
}

- (BOOL)isValidPayPassword {
    if ([self isKindOfClass:[NSString class]]) {
        //        NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
        NSString *pattern = @"[0-9]{6,6}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:self];
        return isMatch;
    }
    return NO;
}

@end
