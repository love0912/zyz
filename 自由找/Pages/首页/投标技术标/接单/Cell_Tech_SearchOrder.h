//
//  Cell_Tech_SearchOrder.h
//  自由找
//
//  Created by xiaoqi on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectOrderDomain.h"

@protocol SearchOrderDelegate <NSObject>
- (void)collectionResult:(NSInteger )result projectID:(NSString *)projectID;
@end

@interface Cell_Tech_SearchOrder : UITableViewCell
- (IBAction)btn_collection_press:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_collection;
@property (weak, nonatomic) IBOutlet UIButton *btn_order;
@property (weak, nonatomic) IBOutlet UILabel *lb_projectName;
@property (weak, nonatomic) IBOutlet UIButton *btn_projectType;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) id<SearchOrderDelegate> delegate;

@property (strong, nonatomic) ProjectOrderDomain *projectOrder;

@end
