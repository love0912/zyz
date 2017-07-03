//
//  UIView+UIViewExt.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/22.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseConstants.h"

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (JX)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;
@property (readonly) CGPoint topLeft;


@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

-(void)removeAllSubViewsWithOutViewsWithTags:(NSIndexSet *)tags;

-(void)textBeginInput:(CGRect)rect inView:(UIView *)inView offSetView:(UIView *)offSetView;

-(void)textEndInputInOffSetView:(UIView *)offSetView rect:(CGRect)frame;

@end
