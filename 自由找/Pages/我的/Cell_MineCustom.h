//
//  Cell_MineCustom.h
//  自由找
//
//  Created by guojie on 16/6/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseConstants.h"

typedef enum : NSUInteger {
    MinePublish,
    MineApply,
    MineCustomer,
} MineCustomType;

@protocol MineCustomClickDelegate <NSObject>

- (void)clickWithMineCustomType:(MineCustomType)type;

@end

@interface Cell_MineCustom : UITableViewCell

@property (strong, nonatomic) UserDomain *user;

@property (weak, nonatomic) id<MineCustomClickDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_publishCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_applyCount;
- (IBAction)btn_publish_pressed:(id)sender;
- (IBAction)btn_apply_pressed:(id)sender;
- (IBAction)btn_customer_pressed:(id)sender;
@end
