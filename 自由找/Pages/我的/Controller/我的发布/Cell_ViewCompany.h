//
//  Cell_ViewCompany.h
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionUserList.h"
#import "Masonry.h"
#import "BaseConstants.h"

typedef enum : NSUInteger {
    ViewCompanyCall,
    ViewCompanyAgree,
    ViewCompanyDisagree,
    ViewCompanyReturn,
    ViewCompanyAccess
} ViewCompanyType;

@protocol ViewCompanyClickDelegate <NSObject>

- (void)clickViewCompany:(AttentionUserDomain *)attentionUser type:(ViewCompanyType)type;

@end

@interface Cell_ViewCompany : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *v_top;

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_score;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UIButton *btn_call;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (weak, nonatomic) IBOutlet UIButton *btn_disagree;
@property (weak, nonatomic) IBOutlet UIButton *btn_return;
@property (weak, nonatomic) IBOutlet UIButton *btn_assess;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_disagree_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_return_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_access_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lb_name_right;
- (IBAction)btn_call_pressed:(id)sender;
- (IBAction)btn_agree_pressed:(id)sender;
- (IBAction)btn_disagree_pressed:(id)sender;
- (IBAction)btn_return_pressed:(id)sender;
- (IBAction)btn_assess_pressed:(id)sender;

@property (strong, nonatomic) AttentionUserDomain *attentionUser;

@property (weak, nonatomic) id<ViewCompanyClickDelegate> delegate;

@end
