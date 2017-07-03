//
//  Cell_OurPublish.h
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseBid.h"

typedef enum : NSUInteger {
    OurPublishDelete,
    OurPublishEdit,
    OurPublishExportCompany,
    OurPublishViewCompany
} OurPublishType;

@protocol OurPublishClickDelegate <NSObject>

- (void)clickWithBidList:(BidListDomain *)bidList type:(OurPublishType)type;

@end

@interface Cell_OurPublish : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewCompany_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_exportCompany_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_edit_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_del_right;


@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_region;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;

- (IBAction)btn_delete_pressed:(id)sender;
- (IBAction)btn_edit_pressed:(id)sender;
- (IBAction)btn_exportCompany_pressed:(id)sender;
- (IBAction)btn_viewCompany_pressed:(id)sender;


@property (strong, nonatomic) BidListDomain *bidList;

@property (weak, nonatomic) id<OurPublishClickDelegate> delegate;


@end
