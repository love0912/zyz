//
//  View_OrderTakeBounced.h
//  testtest
//
//  Created by xiaoqi on 16/8/11.
//  Copyright © 2016年 李娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Cell_ProjectType.h"
#import "ProjectOrderTypeDomain.h"
#import "ProducerDomain.h"
@protocol OrderTakeBouncedDelegate<NSObject>
- (void)SureButtonTouchUp:(NSDictionary *)dic;
- (void)agreementTouchUp;
@end
@interface View_OrderTakeBounced : UIView<UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, retain)UIView *parentView;
@property (nonatomic, retain) UIView *dialogView;

@property (nonatomic, retain) UICollectionView *v_orderTake;
@property(nonatomic,retain)UIButton *btn_Cancel;//取消按钮
@property(nonatomic,retain)UIButton *btn_Sure;//确定按钮
@property(nonatomic,retain)UILabel *lb_projectTitle;//项目名称
/*
 *详情
 */
@property(nonatomic,retain)UILabel *lb_type;//类型
@property(nonatomic,retain)UILabel *lb_unitPrice;//单价
@property(nonatomic,retain)UILabel *lb_qualityRequire;//质量要求
@property(nonatomic,retain)UILabel *lb_margin;//保证金
@property(nonatomic,retain)UILabel *lb_deliveryEmail;//交稿邮箱
@property(nonatomic,retain)UILabel *lb_deliveryTime;//交稿时间
/*
 *项目类别
 */
@property(nonatomic,retain)UILabel *lb_projectType;//项目类别
/*
 *接单数量
 */
@property(nonatomic,retain)UILabel *lb_orderNum;
@property(nonatomic, retain)UIButton *bt_reduce;
@property(nonatomic, retain)UITextField *tf_count;
@property(nonatomic, retain)UIButton *bt_add;
/*
 *温馨提示
 */
@property(nonatomic,retain)UIImageView *iv_notice;
@property(nonatomic,retain)UILabel *lb_notice;
@property(nonatomic,retain)UILabel *lb_detail;
@property(nonatomic,retain)UIImageView *iv_agreement;
@property(nonatomic,retain)UIButton *btn_agreement;
@property(nonatomic,retain)UILabel *lb_agreement;
/*
 *线
 */
@property(nonatomic,retain)UILabel *lb_line1;
@property(nonatomic,retain)UILabel *lb_line2;
@property(nonatomic,retain)UILabel *lb_line3;
@property(nonatomic,retain)UILabel *lb_line4;

@property(nonatomic,assign)NSInteger indexPathRow;
@property (nonatomic, assign) id<OrderTakeBouncedDelegate> delegate;
@property (nonatomic, retain) NSString *projectTitle;
@property (nonatomic, assign) NSUInteger maxNum;
@property (nonatomic, assign) int projectTypeNum;//类别数
@property (nonatomic, assign) int collreportCnt;//collection行数
- (id)initWithParentView: (UIView *)_parentView;
- (id)init;
-(void)show;
-(void)close;
@property (strong, nonatomic) NSMutableArray *orderTypeArray;
@property (strong, nonatomic) ProjectOrderTypeDomain *orderTypeDomain;
@property (strong, nonatomic)ProducerDomain *producer;
@property (assign, nonatomic)NSInteger pushType;
@end
