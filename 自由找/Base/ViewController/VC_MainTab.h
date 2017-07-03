//
//  VC_MainTab.h
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_MainTab : UITabBarController

@property (nonatomic, strong) UILabel *lb_msgCount;

@property (nonatomic, strong) UILabel *lb_mineCount;

@property (assign, nonatomic) NSInteger msgCount;

@property (assign, nonatomic) NSInteger mineCount;

@end
