//
//  NinaPagerView.h
//  NinaPagerView
//
//  Created by RamWire on 16/3/23.
//  Copyright © 2016年 赵富阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NinaPagerView : UIView

- (instancetype)initWithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColorArrays:(NSArray *)colors controllers:(UIViewController *)controllers;
@property (strong, nonatomic) UIColor *selectColor; /**<  选中时的颜色   **/
@property (strong, nonatomic) UIColor *unselectColor; /**<  未选中时的颜色   **/
@property (strong, nonatomic) UIColor *underlineColor; /**<  下划线的颜色   **/

@property (strong, nonatomic) UIViewController *parentViewController;


//用于投标技术标，和编制投标预算的处理
// 1 -- 投标技术标, 2 -- 投标预算
@property (nonatomic, assign) NSInteger type;

- (instancetype)initWithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColorArrays:(NSArray *)colors controllers:(UIViewController *)controllers isType:(NSInteger)type;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com