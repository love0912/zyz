//
//  CommonUtil.m
//  自由找
//
//  Created by guojie on 16/6/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "CommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "JXWebViewController.h"
#import "UIColorExt.h"
#import "KeyDefine.h"
#import "AppDelegate.h"

#define USER_DOMAIN_PATH @"user_domian.jx"

@implementation CommonUtil

+ (NSString *)getArchPath {
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:USER_DOMAIN_PATH];
    return docPath;
}

+ (UserDomain *)getUserDomain {
    NSString *path = [self getArchPath];
    NSData *readData = [NSData dataWithContentsOfFile:path];
    UserDomain *userDomain = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    return userDomain;
}

+ (void)saveUserDomian:(UserDomain *)userDomian {
    NSString *path = [self getArchPath];
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:userDomian];
    BOOL b =  [writeData writeToFile:path atomically:YES];
    if (b) {
        NSLog(@"save_success");
    }
}

+ (BOOL)isLogin {
    UserDomain *userDomain = [self getUserDomain];
    if (userDomain == nil) {
        return NO;
    }
    return YES;
}

+ (void)removeUserDomain {
    NSString *path = [self getArchPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
    }
}

+ (NSString *)getMd5_32Bit:(NSString *)password {
    const char *cStr = [password UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)password.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

+ (BOOL)isIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}
+ (void)setSelectIndex:(NSInteger)index {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectIndex = index;
}

+ (NSInteger)getSelectIndex {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.selectIndex;
}


+ (NSObject *)objectForUserDefaultsKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (key != nil) {
        return [userDefaults objectForKey:key];
    }
    return nil;
}

+ (void)saveObject:(NSObject *)obj forUserDefaultsKey:(NSString *)key {
    if (obj != nil && key != nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:obj forKey:key];
        [userDefaults synchronize];
    }
}

+ (void)removeObjectforUserDefaultsKey:(NSString *)key {
    if (key != nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
}

+ (void)jxWebViewShowInController:(UIViewController *)controller loadUrl:(NSString *)urlString backTips:(NSString *)tips {
    UINavigationController *navController = [JXWebViewController navigationControllerWithWebView];
    JXWebViewController *jx_webView = [navController rootWebViewController];
    //    [jx_webView setDelegate:self];
    jx_webView.showsURLInNavigationBar = YES;
    jx_webView.tintColor = [UIColor whiteColor];
    jx_webView.barTintColor = [UIColor orangeColor]; //[CommonUtil colorWithR:74 G:167 B:4];
    jx_webView.showsPageTitleInNavigationBar = NO;
    jx_webView.showsURLInNavigationBar = NO;
    jx_webView.backTipString = tips;
    [controller presentViewController:navController animated:YES completion:nil];
    [jx_webView loadURLString:urlString];
}

+ (void)jxPushWebViewShowInController:(UIViewController *)controller loadUrl:(NSString *)urlString backTips:(NSString *)tips {
    JXWebViewController *jx_webView = [JXWebViewController jx_webView];
    //    [jx_webView setDelegate:self];
    jx_webView.showsURLInNavigationBar = YES;
    jx_webView.title = @"企业详情";
    jx_webView.tintColor = [UIColor blackColor];
    jx_webView.barTintColor = [UIColor lightGrayColor]; // [CommonUtil colorWithR:74 G:167 B:4];
    jx_webView.showsPageTitleInNavigationBar = NO;
    jx_webView.showsURLInNavigationBar = NO;
    jx_webView.backTipString = tips;
    [jx_webView loadURLString:urlString];
    [controller.navigationController pushViewController:jx_webView animated:YES];
}

+ (void)showUserProtocalInController:(UIViewController *)controller {
    NSString *urlString = @"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statement.aspx?states=1";
    [CommonUtil jxWebViewShowInController:controller loadUrl:urlString backTips:nil];
}

/**
 *  自由找购买协议
 *
 *  @param controller <#controller description#>
 */
+ (void)showBuyProductProtocalInController:(UIViewController *)controller {
    NSString *urlString = @"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv3.html";
    [CommonUtil jxWebViewShowInController:controller loadUrl:urlString backTips:nil];
}

/**
 *  自由找接单协议
 *
 *  @param controller <#controller description#>
 */
+ (void)showReiciveOrderProtocalInController:(UIViewController *)controller {
    NSString *urlString = @"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv4.html";
    [CommonUtil jxWebViewShowInController:controller loadUrl:urlString backTips:nil];
}

/**
 *  自由找接单必读
 *
 *  @param controller <#controller description#>
 */
+ (void)showReiciveOrderReadmeProtocalInController:(UIViewController *)controller {
    NSString *urlString = @"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv5.html";
    [CommonUtil jxWebViewShowInController:controller loadUrl:urlString backTips:nil];
}


/**
 自由找积分规则

 @param controller <#controller description#>
 */
+ (void)showScoreRuleInController:(UIViewController *)controller {
    NSString *urlString = @"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv9.html";
    [CommonUtil jxWebViewShowInController:controller loadUrl:urlString backTips:nil];
}

+ (UIColor *) zyzOrangeColor {
    return [UIColor colorWithHex:@"FF7B23"];
}

+ (UIColor *)zyzBackgroundColor {
    return [UIColor colorWithHex:@"F4F4F4"];
}
//计算输入文字长度
+(NSUInteger) unicodeLengthOfString: (NSString *) text

{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
        
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        
        unicodeLength++;
        
    }
    
    return unicodeLength;
    
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:string];
}
+ (NSString *)stringFromDate1:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString1:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter dateFromString:string];
}


+ (void)callWithPhone:(NSString *)phone {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/**
 *  合作情况
 */
+ (NSArray *)getCooperationData {
    return @[
             [KeyValueDomain domainWithObject:@{kCommonKey: @"1",
                                                kCommonValue: @"优"
                                                }],
             [KeyValueDomain domainWithObject:@{kCommonKey: @"2",
               kCommonValue: @"良"
               }],
             [KeyValueDomain domainWithObject:@{kCommonKey: @"8",
               kCommonValue: @"差"
               }],
//             @{kCommonKey: @"",
//               kCommonValue: @"不限"
//               }
             ];
}

/**
 *  根据key返回合作情况value
 *
 *  @param key
 *
 *  @return
 */
+ (NSString *)cooperationValueForKey:(NSString *)key {
    if ([key isEqualToString:@"1"]) {
        return @"优";
    } else if ([key isEqualToString:@"2"]) {
        return @"良";
    } else if ([key isEqualToString:@"8"]) {
        return @"差";
    }
    return @"不限";
}


/**
 *  生成纯色图片
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGSize imageSize =CGSizeMake(1,1);
    UIGraphicsBeginImageContextWithOptions(imageSize,0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}


+ (NSString *)shortVersion {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSInteger)version {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return [version integerValue];
}


/**
 *  获取Tabbar
 *
 *  @return <#return value description#>
 */
+ (VC_MainTab *)getRootTabbar {
    return (VC_MainTab *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

/**
 *  设置tabbar的消息提示红圈
 *
 *  @param count <#count description#>
 */
+ (void)setMsgCount:(NSInteger)count {
    VC_MainTab *mainTab = [self getRootTabbar];
    if (count >= 0) {
        mainTab.msgCount = count;
    }
}

/**
 *  消息提示红圈减一
 */
+ (void)subMsgCount {
    VC_MainTab *mainTab = [self getRootTabbar];
    NSInteger count = [mainTab.lb_msgCount.text integerValue];
    if (count > 0) {
        count --;
    } else {
        count = 0;
    }
    [self setMsgCount:count];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

/**
 *  设置我的提示
 *
 *  @param count <#count description#>
 */
+ (void)setMineCount:(NSInteger)count {
    VC_MainTab *mainTab = [self getRootTabbar];
    if (count >= 0) {
        mainTab.mineCount = count;
        /**
         *  设置我的发布提示
         */
        [self setPublishCount:count];
    }
}

/**
 *  减少我的上面的数字提示
 *
 *  @param count 减少的数量
 */
+ (void)subMineCount:(NSInteger)count {
    VC_MainTab *mainTab = [self getRootTabbar];
    NSInteger resultCount = mainTab.lb_mineCount.text.integerValue - count;
    if (resultCount < 0) {
        resultCount = 0;
    }
    [self setMineCount:resultCount];
}

/**
 *  设置我的发布数量提示
 *
 *  @param count
 */
+ (void)setPublishCount:(NSInteger)count {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Set_Publish_Count object:@(count)];
}

/**
 *  设置我的发布数量和我的下标数量一致
 */
+ (void)setPublishCount {
    VC_MainTab *mainTab = [self getRootTabbar];
    NSInteger count = [mainTab.lb_mineCount.text integerValue];
    if (count > 0) {
        [self setPublishCount:count];
    }
}


/**
 *  减少我的发布提示数量
 *
 *  @param count 减少的数量
 */
+ (void)subPublishCount:(NSInteger)count {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Sub_Publish_Count object:@(count)];
}
//设置不同字体颜色
+(void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    label.attributedText = str;
}

/**
 去浮点数末尾的0
 
 @param string <#string description#>
 
 @return <#return value description#>
 */
+(NSString*)removeFloatAllZero:(NSString*)string {
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.doubleValue)];
    return outNumber;
}


/**
 触发通知

 @param name <#name description#>
 */
+ (void)notificationWithName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

/**
 截屏 -- 将view转化为image
 
 @param view <#view description#>
 @return <#return value description#>
 */
+ (UIImage *)captureImageFormView:(UIView *)view {
    CGRect screenRect = view.bounds;
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 计算文字的宽度
 
 @param label <#label description#>
 @param font <#font description#>
 @return <#return value description#>
 */
+ (CGFloat)widthWithText:(NSString *)text labelHeight:(CGFloat)labelHeight font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, labelHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}
@end
