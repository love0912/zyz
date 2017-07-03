//
//  ShareHelper.h
//  自由找
//
//  Created by xiaoqi on 16/7/1.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShareHelperDelegate

- (void)ShareHelperButtonTouchUpInside:(id)shareHelper clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface ShareHelper : UIView<ShareHelperDelegate>
@property (nonatomic, retain)UIView *parentView;
@property (nonatomic, retain) UIView *dialogView;
@property (nonatomic, retain)UILabel *lb_shareTitle;
@property (nonatomic, retain)UIView *v_share;
@property(nonatomic,retain)UIButton *btn_shareCancel;
@property (nonatomic, assign) id<ShareHelperDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, retain) NSArray *buttonImages;
@property (nonatomic, retain) NSString *shareTitle;

@property (copy) void (^onButtonTouchUpInside)(ShareHelper *sharehelper, int buttonIndex) ;
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));
- (id)init;
- (void)show;
- (void)close;

@end
