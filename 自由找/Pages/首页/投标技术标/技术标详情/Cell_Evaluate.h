//
//  Cell_Evaluate.h
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateDomain.h"
#import "UIImageView+WebCache.h"

@protocol EvaluateDelegate <NSObject>

- (void)viewAllEvaluate;

@end

@interface Cell_Evaluate : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_avater;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UIView *v_star;
- (IBAction)btn_viewAll_pressed:(id)sender;

@property (weak, nonatomic) id<EvaluateDelegate> delegate;

@property (strong, nonatomic) EvaluateDomain *evaluate;

- (void)configWithEvaluateDomain:(NSObject *)evaluate;

@end
