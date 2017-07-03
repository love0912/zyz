//
//  JXRatingView.h
//  自由找
//
//  Created by guojie on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"

typedef void(^RattingScore)(CGFloat score, NSString *reason);

@interface JXRatingView : UIView<RatingBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _score;
    NSArray *_arr_menu;
    NSMutableArray *_arr_reason;
}

@property (strong, nonatomic) RattingScore rattingScore;

@property (strong, nonatomic) UITableView *tableView;

+ (void)showInView:(UIView *)parent reasons:(NSArray *)reasons titleText:(NSString *)titleText rattingScore:(void (^)(CGFloat score, NSString *reason))result;

- (void)refreshUI;

@property (strong, nonatomic) NSString *titleText;

@end
