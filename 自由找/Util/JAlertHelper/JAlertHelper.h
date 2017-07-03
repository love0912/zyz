//
//  JAlertHelper.h
//  自由找
//
//  Created by guojie on 16/6/16.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JAlertHelper : NSObject<UIAlertViewDelegate, UIActionSheetDelegate>

typedef void (^ClickAtIndexBlock)(NSInteger buttonIndex);

+ (void)jAlertWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons showInController:(UIViewController *)controller clickAtIndex:(ClickAtIndexBlock) clickAtIndex;

+ (void)jSheetWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle OtherButtonsArray:(NSArray*)otherButtons showInController:(UIViewController *)controller clickAtIndex:(ClickAtIndexBlock) clickAtIndex;

@end
