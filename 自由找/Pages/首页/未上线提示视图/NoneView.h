//
//  NoneView.h
//  自由找
//
//  Created by guojie on 16/7/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoneView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UIView *v_content;
@property (weak, nonatomic) IBOutlet UIImageView *iv_background;

- (IBAction)btn_konw_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_know;
@property (weak, nonatomic) IBOutlet UIButton *btn_disagree;
- (IBAction)btn_disagree_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
- (IBAction)btn_agree_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_phone;
- (IBAction)btn_phone_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnknowToBottom;

/**
 *   @param type 0 -- 编制技术标  1 -- 编制投标预算
 */
@property (assign, nonatomic) NSInteger type;

/**
 *  显示
 *
 *  @param type 0 -- 编制技术标  1 -- 编制投标预算
 */
+ (void)showWithType:(NSInteger)type;
@end
