//
//  AppDelegate.h
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base/Resource/BaseConstants.h"
#import "VC_MainTab.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) VC_MainTab *mainTab;
/**
 *  上一个选中的tab.
 */
@property (assign, nonatomic) NSInteger selectIndex;
@end

