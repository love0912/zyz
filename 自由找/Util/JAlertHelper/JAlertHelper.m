//
//  JAlertHelper.m
//  自由找
//
//  Created by guojie on 16/6/16.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "JAlertHelper.h"
#import <objc/runtime.h>
#define JIOS8Later [[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0

const char *JAlertSheet_Block = "JAlertSheet_Block";

@interface UIAlertView (JAlertView)
-(void)setClickBlock:(ClickAtIndexBlock)block;
-(ClickAtIndexBlock)clickBlock;
@end

@implementation UIAlertView (JAlertView)
-(void)setClickBlock:(ClickAtIndexBlock)block {
    objc_setAssociatedObject(self, JAlertSheet_Block, block, OBJC_ASSOCIATION_COPY);
}
-(ClickAtIndexBlock)clickBlock {
    return objc_getAssociatedObject(self, JAlertSheet_Block);
}
@end

@interface UIActionSheet (JActionSheet)
-(void)setClickBlock:(ClickAtIndexBlock)block;
-(ClickAtIndexBlock)clickBlock;
@end

@implementation UIActionSheet (JActionSheet)
-(void)setClickBlock:(ClickAtIndexBlock)block {
    objc_setAssociatedObject(self, JAlertSheet_Block, block, OBJC_ASSOCIATION_COPY);
}
-(ClickAtIndexBlock)clickBlock {
    return objc_getAssociatedObject(self, JAlertSheet_Block);
}
@end

@implementation JAlertHelper

#pragma mark - alert
+ (void)jAlertWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons showInController:(UIViewController *)controller clickAtIndex:(ClickAtIndexBlock) clickAtIndex {
    if (JIOS8Later && controller != nil) {
        int index = 0;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messge preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancleButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            clickAtIndex(index);
        }];
        [alert addAction:cancel];
        for (NSString *otherTitle in otherButtons) {
            index ++;
            UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                clickAtIndex(index);
            }];
            [alert addAction:action];
        }
        [controller presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:messge delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles: nil];
        alert.clickBlock = clickAtIndex;
        for (NSString *otherTitle in otherButtons) {
            [alert addButtonWithTitle:otherTitle];
        }
        [alert show];
    }
}

#pragma mark UIAlertViewDelegate
+(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.clickBlock) {
        alertView.clickBlock(buttonIndex);
    }
}

#pragma mark - actionSheet
+ (void)jSheetWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle OtherButtonsArray:(NSArray*)otherButtons showInController:(UIViewController *)controller clickAtIndex:(ClickAtIndexBlock) clickAtIndex {
    
    if (JIOS8Later && controller != nil) {
        int index = 0;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messge preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *destructive = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            clickAtIndex(index);
        }];
        [alert addAction:destructive];
        index++;
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancleButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            clickAtIndex(index);
        }];
        [alert addAction:cancel];
        for (NSString *otherTitle in otherButtons) {
            index ++;
            UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                clickAtIndex(index);
            }];
            [alert addAction:action];
        }
        [controller presentViewController:alert animated:YES completion:nil];
    } else {
        UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:title delegate:[self self] cancelButtonTitle:cancleButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
        alert.clickBlock = clickAtIndex;
        for (NSString *otherTitle in otherButtons) {
            [alert addButtonWithTitle:otherTitle];
        }
        if (controller != nil) {
            [alert showInView:controller.view];
        } else {
            [alert showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    actionSheet.clickBlock(buttonIndex);
}

@end
