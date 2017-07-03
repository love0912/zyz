//
//  JRateView.h
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JRateScore)(CGFloat score);

@interface JRateView : UIView

@property (strong, nonatomic) JRateScore rateScore;

/**
 *  是否可点击，如果为NO。则只显示
 */
@property (assign, nonatomic) BOOL isTap;

+ (JRateView *)rateScoreWithFrame:(CGRect)frame paddingX:(CGFloat)paddingX Score:(CGFloat)score isAnimation:(BOOL)animate allowIncompleteStar:(BOOL)allow rateScore:(void (^)(CGFloat score))rateScore;

@end
