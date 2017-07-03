//
//  VC_TextField.h
//  自由找
//
//  Created by guojie on 16/7/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef enum : NSUInteger {
    INPUT_TYPE_NUMBER,
    INPUT_TYPE_NORMAL,
    INPUT_TYPE_ENGLISH,
    INPUT_TYPE_PASSWORD,
    INPUT_TYPE_DECIMAL,
    INPUT_TYPE_MONEY_WAN //以万元为单位的
} TextField_Type;


@interface VC_TextField : VC_Base

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *lb_unit;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;

/**
 *  文本字数
 */
@property (nonatomic, assign) NSInteger maxCount;

/**
 *  最少需要输入的个数
 */
@property (nonatomic, assign) NSInteger minCount;

typedef void(^ITextFieldBlock)(NSString *text);


/**
 *  内容
 */
@property (nonatomic, strong) NSString *text;

/**
 *  标题
 */
@property (nonatomic, strong) NSString *jTitle;

/**
 *  输入提示
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  单位
 */
@property (nonatomic, strong) NSString *jUnit;

@property (assign, nonatomic) TextField_Type type;

@property (nonatomic, strong) ITextFieldBlock inputBlock;


#pragma mark - 当为浮点数是，允许输入值的范围
@property (assign, nonatomic) CGFloat minValue;

@property (assign, nonatomic) CGFloat maxValue;

@end
