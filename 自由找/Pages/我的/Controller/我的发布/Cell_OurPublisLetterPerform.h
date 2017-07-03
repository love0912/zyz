//
//  Cell_OurPublisLetterPerform.h
//  自由找
//
//  Created by 郭界 on 16/10/19.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterPerformDomain.h"

typedef enum : NSUInteger {
    OurPublisLetterPerform_Delete,
    OurPublisLetterPerform_Edit,
    OurPublisLetterPerform_Finish
} OurPublisLetterPerformType;

@protocol OurPublisLetterPerformClickDelegate <NSObject>

- (void)clickWithLetterPerform:(LetterPerformDomain *)letterPerform type:(OurPublisLetterPerformType)type;

@end


@interface Cell_OurPublisLetterPerform : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_expireDate;
@property (weak, nonatomic) IBOutlet UILabel *lb_createDate;
@property (weak, nonatomic) IBOutlet UIButton *btn_finish;
@property (weak, nonatomic) IBOutlet UIButton *btn_edit;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;
- (IBAction)btn_finish_pressed:(id)sender;
- (IBAction)btn_edit_pressed:(id)sender;
- (IBAction)btn_delete_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_delete_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_money_width;

@property (strong, nonatomic) LetterPerformDomain *letterPerform;

@property (weak, nonatomic) id<OurPublisLetterPerformClickDelegate> delegate;

@end
