//
//  Cell_RegisterJob.h
//  zyz
//
//  Created by 郭界 on 16/12/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTechCategory @"TechCategory"
#define kTechLevel @"TechLevel"
#define kMinQty @"MinQty"

typedef enum : NSUInteger {
    RegisterJob_Name,
    RegisterJob_Level,
    RegisterJob_Count,
    RegisterJob_Delete,
    RegisterJob_Clear
} RegisterJobType;

@protocol CellRegisterJobDelegate <NSObject>

- (void)handleDataDic:(NSMutableDictionary *)dataDic type:(RegisterJobType)type;

@end

@interface Cell_RegisterJob : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *v_levelBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_vLevelBack_top;

@property (weak, nonatomic) IBOutlet UILabel *lb_specialtyName;
- (IBAction)btn_specialtyName_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_specialtyLevel;
- (IBAction)btn_specialtyLevel_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_specialtyCount;
- (IBAction)btn_specialtyCount_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;
- (IBAction)btn_delete_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_clear;
- (IBAction)btn_clear_pressed:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dataDic;

@property (assign, nonatomic) BOOL showDelete;

@property (assign, nonatomic) id<CellRegisterJobDelegate> delegate;

@property (assign, nonatomic) BOOL hideLevel;

@end
