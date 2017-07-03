//
//  View_OrderTakeBounced.m
//  testtest
//
//  Created by xiaoqi on 16/8/11.
//  Copyright © 2016年 李娟. All rights reserved.
//

#import "View_OrderTakeBounced.h"
#import "CommonUtil.h"
#import "UIColorExt.h"
#import "BaseConstants.h"
#import "CommonUtil.h"
static NSString *cellID=@"Cell_ProjectType";
@implementation View_OrderTakeBounced{
    CGFloat screenWidth ;
    CGFloat screenHeight;
    UICollectionViewFlowLayout * _collectionViewFlowLayout;
    NSString *_serialNoString;
    NSString *_QuantityString;
    TakeOrderProductDomain *_takeOrderProductDomain;
    ProjectOrderTypeDomain * _orderDomain;
    CGFloat _contentLabelHeight;
    UIScrollView *dialogScrollView;


}
@synthesize parentView,dialogView,v_orderTake,lb_projectTitle,btn_Cancel,btn_Sure;
@synthesize lb_line1,lb_line2,lb_line3,lb_line4;
@synthesize lb_type,lb_unitPrice,lb_qualityRequire,lb_margin,lb_deliveryEmail,lb_deliveryTime;
@synthesize lb_projectType;
@synthesize lb_orderNum,bt_reduce,tf_count,bt_add;
@synthesize iv_notice,lb_notice,lb_detail,btn_agreement,lb_agreement;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        _indexPathRow=0;
//        _projectTypeNum=7;
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    }
   
    return self;
    
}
-(void)show{
    _projectTypeNum=(int)_orderTypeArray.count;
    dialogView = [self createContainerView];
    dialogView.backgroundColor=[UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:dialogView];
    if (parentView != NULL) {
        [parentView addSubview:self];
        
    } else {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            switch (interfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                    break;
                    
                default:
                    break;
            }
            
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        } else {
            dialogView.frame = CGRectMake(0,screenHeight-screenHeight/4*3, screenWidth, screenHeight/4*3);
        }
        
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
    
}

- (void)setOrderTypeArray:(NSMutableArray *)orderTypeArray {
    _orderTypeArray = [NSMutableArray arrayWithArray:orderTypeArray];
    _orderTypeDomain = _orderTypeArray.firstObject;
}

- (UIView *)createContainerView{
    if (v_orderTake == NULL) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width- 45) / 2;
        v_orderTake=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 150) collectionViewLayout:_collectionViewFlowLayout];
        if (IS_IPHONE_6P) {
            _collectionViewFlowLayout.itemSize = CGSizeMake(itemWidth, 40);

        }else{
            _collectionViewFlowLayout.itemSize = CGSizeMake(itemWidth, 30);
        }
        [v_orderTake selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    v_orderTake.dataSource=self;
    v_orderTake.delegate=self;
    v_orderTake.scrollEnabled=NO;
    [v_orderTake registerNib:[UINib nibWithNibName:@"Cell_ProjectType" bundle:nil] forCellWithReuseIdentifier:cellID];
    UIView *dialogContainer = [[UIView alloc] init];
    dialogContainer.frame = CGRectMake(0,screenHeight-screenHeight/4*3, screenWidth, screenHeight/4*3);
    dialogScrollView = [[UIScrollView alloc] init];
    dialogScrollView.frame = CGRectMake(0,47, screenWidth, dialogContainer.frame.size.height-100);
    //取消按钮
    btn_Cancel=[[UIButton alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
    [btn_Cancel setImage:[UIImage imageNamed:@"Login_close"] forState:UIControlStateNormal];
    [btn_Cancel addTarget:self action:@selector(CancelButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn_Cancel setTag:9999];
    [dialogContainer addSubview:btn_Cancel];
    //项目名称
    lb_projectTitle=[[UILabel alloc]initWithFrame:CGRectMake(60,15, [UIScreen mainScreen].bounds.size.width-75, 21)];
    lb_projectTitle.font=[UIFont systemFontOfSize:17.0];
    lb_projectTitle.textAlignment=NSTextAlignmentCenter;
    lb_projectTitle.textColor=[UIColor colorWithHex:@"333333"];
    lb_projectTitle.text=_projectTitle;
    [dialogContainer addSubview:lb_projectTitle];
    //线
    lb_line1=[[UILabel alloc]init];
    lb_line1.backgroundColor=[UIColor colorWithHex:@"F4F4F4"];
    [dialogContainer addSubview:lb_line1];
    [lb_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lb_projectTitle.mas_bottom).with.offset(10);
                make.width.mas_equalTo(screenWidth);
                make.height.mas_equalTo(1);
            }];
    /*
     *详情
     */
    lb_type=[[UILabel alloc]init];
    lb_type.font=[UIFont systemFontOfSize:13.0];
    lb_type.text=@"类型：专家型";
    lb_type.textColor=[UIColor colorWithHex:@"fd2523"];
    [dialogScrollView addSubview:lb_type];
    [lb_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dialogScrollView.mas_top).with.offset(10);
        make.width.mas_equalTo(screenWidth-30);
        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
        
    }];
    lb_unitPrice=[[UILabel alloc]init];
    lb_unitPrice.font=[UIFont systemFontOfSize:13.0];
    lb_unitPrice.text=@"价格：200/份";
    lb_unitPrice.textColor=[UIColor colorWithHex:@"333333"];
    [dialogScrollView addSubview:lb_unitPrice];
    [lb_unitPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_type.mas_bottom).with.offset(5);
        make.width.mas_equalTo(screenWidth-30);
        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);

    }];
    lb_qualityRequire=[[UILabel alloc]init];
    lb_qualityRequire.font=[UIFont systemFontOfSize:13.0];
    lb_qualityRequire.text=@"质量要求：优";
    lb_qualityRequire.numberOfLines=0;
    
    lb_qualityRequire.textColor=[UIColor colorWithHex:@"333333"];
    [dialogScrollView addSubview:lb_qualityRequire];
    [lb_qualityRequire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_unitPrice.mas_bottom).with.offset(5);
        make.width.mas_equalTo(screenWidth-30);
//        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    lb_margin=[[UILabel alloc]init];
    lb_margin.font=[UIFont systemFontOfSize:13.0];
    lb_margin.text=@"保证金：200/份";
    lb_margin.textColor=[UIColor colorWithHex:@"333333"];
    [dialogScrollView addSubview:lb_margin];
    [lb_margin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_qualityRequire.mas_bottom).with.offset(5);
        make.width.mas_equalTo(screenWidth-30);
        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    lb_deliveryEmail=[[UILabel alloc]init];
    lb_deliveryEmail.font=[UIFont systemFontOfSize:13.0];
    lb_deliveryEmail.text=@"交稿邮箱：www:baidunjvjfnv.com";
    lb_deliveryEmail.textColor=[UIColor colorWithHex:@"ffa273"];
    [dialogScrollView addSubview:lb_deliveryEmail];
    [lb_deliveryEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_margin.mas_bottom).with.offset(5);
        make.width.mas_equalTo(screenWidth-30);
        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    lb_deliveryTime=[[UILabel alloc]init];
    lb_deliveryTime.font=[UIFont systemFontOfSize:13.0];
    lb_deliveryTime.text=@"交稿时间：2016-06-07";
    lb_deliveryTime.textColor=[UIColor colorWithHex:@"ffa273"];
    [dialogScrollView addSubview:lb_deliveryTime];
    [lb_deliveryTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_deliveryEmail.mas_bottom).with.offset(5);
        make.width.mas_equalTo(screenWidth-30);
        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    //线
    lb_line2=[[UILabel alloc]init];
    lb_line2.backgroundColor=[UIColor colorWithHex:@"F4F4F4"];
    [dialogScrollView addSubview:lb_line2];
    [lb_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_deliveryTime.mas_bottom).with.offset(10);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(1);
    }];
    /*
     *项目类别
     */
    lb_projectType=[[UILabel alloc]init];
    if (IS_IPHONE_5_OR_LESS) {
        lb_projectType.font=[UIFont systemFontOfSize:13.0];
    }else{
        lb_projectType.font=[UIFont systemFontOfSize:15.0];
    }
    lb_projectType.text=@"请选择您要接单的类别";
    lb_projectType.textColor=[UIColor colorWithHex:@"333333"];

    [dialogScrollView addSubview:lb_projectType];
    [lb_projectType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_line2.mas_bottom).with.offset(5);
        make.width.mas_equalTo(screenWidth-30);
        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    //添加类别collectionview
    [dialogScrollView addSubview:v_orderTake];
    if (_projectTypeNum%2 == 0)
    {
        _collreportCnt = _projectTypeNum/2;
    }
    else
    {
        _collreportCnt = _projectTypeNum/2+1;
    }
    if(IS_IPHONE_6P){
        [v_orderTake mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lb_projectType.mas_bottom).with.offset(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(_collreportCnt*45);
            make.left.equalTo(dialogScrollView.mas_left).with.offset(0);
        }];
    
    }else{
        [v_orderTake mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lb_projectType.mas_bottom).with.offset(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(_collreportCnt*38);
            make.left.equalTo(dialogScrollView.mas_left).with.offset(0);
        }];
    }
    
    v_orderTake.backgroundColor=[UIColor whiteColor];
    
    //线
    lb_line3=[[UILabel alloc]init];
    lb_line3.backgroundColor=[UIColor colorWithHex:@"F4F4F4"];
    [dialogScrollView addSubview:lb_line3];
    [lb_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v_orderTake.mas_bottom).with.offset(5);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(1);
    }];
    /*
     *接单数量
     */
    lb_orderNum=[[UILabel alloc]init];
    if (IS_IPHONE_5_OR_LESS) {
        lb_orderNum.font=[UIFont systemFontOfSize:13.0];
    }else{
        lb_orderNum.font=[UIFont systemFontOfSize:15.0];
    }
    lb_orderNum.text=@"请选择接单数量";
    lb_orderNum.textColor=[UIColor colorWithHex:@"333333"];

    [dialogScrollView addSubview:lb_orderNum];
    [lb_orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_line3.mas_bottom).with.offset(15);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(15);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    
    bt_add= [UIButton buttonWithType:UIButtonTypeCustom];
    [bt_add setImage:[UIImage imageNamed:@"Count_right"] forState:UIControlStateNormal];
    [dialogScrollView addSubview:bt_add];
    [bt_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_line3.mas_top).with.offset(-3);
        make.height.mas_equalTo(50);
        make.right.equalTo(dialogScrollView.mas_left).with.offset(screenWidth-10);
    }];
    
    tf_count = [[UITextField alloc] init];
    tf_count.text = @"1";
    tf_count.textAlignment = NSTextAlignmentCenter;
    tf_count.font = [UIFont systemFontOfSize:15];
    tf_count.delegate=self;
    tf_count.textColor=[UIColor colorWithHex:@"333333"];
    tf_count.userInteractionEnabled=NO;
    tf_count.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Count_center"]];
    [dialogScrollView addSubview:tf_count];
    [tf_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_line3.mas_top).with.offset(8.5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(27);
        make.right.equalTo(bt_add.mas_left).with.offset(0);

    }];
    bt_reduce= [UIButton buttonWithType:UIButtonTypeCustom];
    [bt_reduce setImage:[UIImage imageNamed:@"Count_left"] forState:UIControlStateNormal];
    [dialogScrollView addSubview:bt_reduce];
    [bt_reduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_line3.mas_top).with.offset(-3);
        make.height.mas_equalTo(50);
        make.right.equalTo(tf_count.mas_left).with.offset(0);

    }];
    [bt_add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [bt_reduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    //线
    lb_line4=[[UILabel alloc]init];
    lb_line4.backgroundColor=[UIColor colorWithHex:@"F4F4F4"];
    [dialogScrollView addSubview:lb_line4];
    [lb_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_orderNum.mas_bottom).with.offset(10);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(1);
    }];
    /*
     *温馨提示
     */
    iv_notice=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tishiIncompany"]];
    [dialogScrollView addSubview:iv_notice];
    [iv_notice mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5_OR_LESS) {
            make.top.equalTo(lb_line4.mas_bottom).with.offset(7);
        }else{
            make.top.equalTo(lb_line4.mas_bottom).with.offset(12);
        }
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    lb_notice=[[UILabel alloc]init];
    if (IS_IPHONE_5_OR_LESS) {
        lb_notice.font=[UIFont systemFontOfSize:13.0];
    }else{
        lb_notice.font=[UIFont systemFontOfSize:15.0];
    }
    lb_notice.text=@"温馨提示";
    lb_notice.textColor=[UIColor colorWithHex:@"333333"];
    [dialogScrollView addSubview:lb_notice];
    [lb_notice mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5_OR_LESS) {
            make.top.equalTo(lb_line4.mas_bottom).with.offset(5);
        }else{
            make.top.equalTo(lb_line4.mas_bottom).with.offset(10);
        }
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(21);
        make.left.equalTo(iv_notice.mas_right).with.offset(12);
    }];
    
    lb_detail =[[UILabel alloc]init];
    lb_detail.font=[UIFont systemFontOfSize:13.0];
    lb_detail.textColor=[UIColor colorWithHex:@"333333"];
    lb_detail.text=@"项目执行期间,系统在您的余额中将冻结6000元作为保证金，项目完成后若无投诉，系统将自动解冻";
    lb_detail.numberOfLines=0;
    [dialogScrollView addSubview:lb_detail];
    [lb_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_notice.mas_bottom).with.offset(0);
        make.width.mas_equalTo(screenWidth-30);
        make.height.mas_equalTo(50);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    btn_agreement=[[UIButton alloc]init];
    [btn_agreement setImage:[UIImage imageNamed:@"Regist_se2"] forState:UIControlStateNormal];
    [dialogScrollView addSubview:btn_agreement];
    [btn_agreement addTarget:self action:@selector(btn_agreement_press:) forControlEvents:UIControlEventTouchUpInside];
    [btn_agreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_detail.mas_bottom).with.offset(0);
        make.left.equalTo(dialogScrollView.mas_left).with.offset(15);
    }];
    lb_agreement=[[UILabel alloc]init];
    lb_agreement.font=[UIFont systemFontOfSize:13.0];
    lb_agreement.text=@"同意《接单协议》";
    lb_agreement.textColor=[UIColor colorWithHex:@"333333"];
    [dialogScrollView addSubview:lb_agreement];
    [lb_agreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb_detail.mas_bottom).with.offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(21);
        make.left.equalTo(btn_agreement.mas_right).with.offset(12);
    }];
    NSRange rangeagreement = [lb_agreement.text rangeOfString:@"《接单协议》"];
    [CommonUtil setTextColor:lb_agreement FontNumber:[UIFont systemFontOfSize:13.0] AndRange:rangeagreement AndColor:[UIColor colorWithHex:@"379DF4"]];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapagreement)];
    lb_agreement.userInteractionEnabled=YES;
    [lb_agreement addGestureRecognizer:tap];
    //确定按钮
    btn_Sure=[[UIButton alloc]initWithFrame:CGRectMake(15, dialogContainer.frame.size.height-55, screenWidth-30, 45)];
    [btn_Sure setBackgroundImage:[UIImage imageNamed:@"Bid_btn1"] forState:UIControlStateNormal];
    btn_Sure.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [btn_Sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_Sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_Sure addTarget:self action:@selector(SureButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn_Sure setTag:9999];
    [dialogContainer addSubview:btn_Sure];
    [btn_Sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dialogContainer.mas_bottom).with.offset(-7);
        make.width.mas_equalTo(screenWidth-30);
        make.left.equalTo(dialogContainer.mas_left).with.offset(15);

    }];
    if (IS_IPHONE_5_OR_LESS) {
        dialogScrollView.contentSize = CGSizeMake(0, dialogScrollView.frame.size.height+(_collreportCnt*45));
    }else{
        dialogScrollView.contentSize = CGSizeMake(0, dialogScrollView.frame.size.height-80+(_collreportCnt*50));
    }
    [dialogContainer addSubview:dialogScrollView];
    return dialogContainer;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _projectTypeNum;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //重用cell
    Cell_ProjectType *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ProjectOrderTypeDomain *orderTypeDomain=[_orderTypeArray objectAtIndex:indexPath.row];
    [cell.btn_type setTitle:[NSString stringWithFormat:@"%@ | %@元/份",orderTypeDomain.DisplayName,orderTypeDomain.PricePer] forState:UIControlStateNormal];
    [cell.btn_type setTitle:[NSString stringWithFormat:@"%@ | %@元/份",orderTypeDomain.DisplayName,orderTypeDomain.PricePer] forState:UIControlStateSelected];
    if (_indexPathRow==indexPath.row) {
        cell.btn_type.selected=YES;
        tf_count.text = @"1";
         _orderDomain=[_orderTypeArray objectAtIndex:_indexPathRow];
        _takeOrderProductDomain=_orderDomain.Product;
        KeyValueDomain *keyValue=_takeOrderProductDomain.ProductLevel;
        lb_type.text=[NSString stringWithFormat:@"类型：%@(仅%@级及以上可接单)",_takeOrderProductDomain.Name,keyValue.Value];
//        if (self.producer.MaxQuantity !=nil) {
//            NSArray *maxQuantityArr=self.producer.MaxQuantity;
//            for(MaxQuantityDomain *maxQuantityDomain in maxQuantityArr) {
//                KeyValueDomain *keyValueUser=maxQuantityDomain.ProductLevel;
//                if ([keyValueUser.Key integerValue]==[keyValue.Key integerValue]) {
//                    if ([maxQuantityDomain.MaxQuantity intValue]>= [_orderDomain.AvaliableQuantity intValue]) {
                        self.maxNum=_orderDomain.receiveCount;
//                    }else{
//                        self.maxNum=[maxQuantityDomain.MaxQuantity intValue];
//                    }
//                     btn_Sure.enabled=YES;
//                    break;
//                }else{
//                    self.maxNum=0;
//                     btn_Sure.enabled=NO;
//                }
//            }
//        }else{
//         btn_Sure.enabled=YES;
//         self.maxNum=0;
//        }
        lb_unitPrice.text=[NSString stringWithFormat:@"价格：%@元/份",_orderDomain.PricePer];
        lb_qualityRequire.text=[NSString stringWithFormat:@"质量要求：%@",_orderDomain.QulifyType];
        lb_deliveryEmail.text=[NSString stringWithFormat:@"交稿邮箱：%@",_orderDomain.DeliveryEmail];
        lb_deliveryTime.text=[NSString stringWithFormat:@"交稿时间：%@",_orderDomain.DeliveryDt];
        _serialNoString=_orderDomain.SerialNo;
        _QuantityString=_orderDomain.QulifyType;
        NSRange rangeEmail = [lb_deliveryEmail.text rangeOfString:@"交稿邮箱："];
        [CommonUtil setTextColor:lb_deliveryEmail FontNumber:[UIFont systemFontOfSize:13.0] AndRange:rangeEmail AndColor:[UIColor colorWithHex:@"333333"]];
        NSRange range = [lb_deliveryTime.text rangeOfString:@"交稿时间："];
        [CommonUtil setTextColor:lb_deliveryTime FontNumber:[UIFont systemFontOfSize:13.0] AndRange:range AndColor:[UIColor colorWithHex:@"333333"]];
        lb_margin.text=[NSString stringWithFormat:@"保证金：%@元/份",_orderDomain.DepositValue];
        lb_detail.text=[NSString stringWithFormat:@"项目执行期间,系统在您的余额中将冻结%@元作为保证金，项目完成后若无投诉，系统将自动解冻",_orderDomain.DepositValue];
        NSRange range1 = [lb_detail.text rangeOfString:[NSString stringWithFormat:@"%@元",orderTypeDomain.DepositValue]];
        [CommonUtil setTextColor:lb_detail FontNumber:[UIFont systemFontOfSize:13.0] AndRange:range1 AndColor:[UIColor colorWithHex:@"ffa273"]];
        CGSize textSize = [lb_qualityRequire.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]} context:nil].size;
        _contentLabelHeight = textSize.height + 10>20?textSize.height + 10:20;
        if (IS_IPHONE_5_OR_LESS) {
            dialogScrollView.contentSize = CGSizeMake(0, dialogScrollView.frame.size.height+(_collreportCnt*45)+_contentLabelHeight);
        }else{
            dialogScrollView.contentSize = CGSizeMake(0, dialogScrollView.frame.size.height-80+(_collreportCnt*50)+_contentLabelHeight);
        }

    }else{
        cell.btn_type.selected=NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   _orderTypeDomain=[_orderTypeArray objectAtIndex:indexPath.row];
    if (_orderTypeDomain.receiveCount==0) {
//        [ProgressHUD showInfo:@"您的等级不符合该类别的要求！" withSucc:NO withDismissDelay:1];
        [JAlertHelper jAlertWithTitle:@"您的技术等级不满足要求，请联系客服！" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"联系客服"] showInController:nil clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [CommonUtil callWithPhone:@"4000213618"];
            }
        }];
    }else{
         _indexPathRow=indexPath.row;
    }
    [v_orderTake reloadData];
}
// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
        return UIEdgeInsetsMake(3, 15, 0, 12);
}
-(void)btn_agreement_press:(UIButton *)btn{
    if (btn.selected == YES){
        [btn setImage:[UIImage  imageNamed:@"Regist_se2"] forState:UIControlStateNormal];
        btn.selected= NO;
    }else{
        [btn setImage:[UIImage  imageNamed:@"Regist_se1"] forState:UIControlStateNormal];
        btn.selected= YES;
        
    }
}
- (void)SureButtonTouchUpInside:(id)button{
    if ([_delegate respondsToSelector:@selector(SureButtonTouchUp:)]) {
        if([self checkMustInput]){
            if (_pushType==2) {//预算
                if ([_orderDomain.Region.Key isEqualToString:self.producer.Region.Key]) {
                NSDictionary*dic=@{@"SerialNo":_serialNoString,@"Quantity":tf_count.text,@"totalPrice":[NSString stringWithFormat:@"%.2f",[_orderTypeDomain.DepositValue doubleValue] *[tf_count.text intValue]]};
                    [_delegate SureButtonTouchUp:dic];
                }else{
                    [ProgressHUD showInfo:@"您接单区域不满足条件！" withSucc:NO withDismissDelay:1];
                }
            }else{
               NSDictionary*dic=@{@"SerialNo":_serialNoString,@"Quantity":tf_count.text,@"totalPrice":[NSString stringWithFormat:@"%.2f",[_orderTypeDomain.DepositValue doubleValue] *[tf_count.text intValue]]};
                [_delegate SureButtonTouchUp:dic];
            }

        }
    }
}
- (BOOL)checkMustInput {
    if (btn_agreement.selected !=NO) {
        [ProgressHUD showInfo:@"请同意接单协议" withSucc:NO withDismissDelay:2];
        return NO;
    }
    KeyValueDomain *keyValue=_takeOrderProductDomain.ProductLevel;
    if ([self.producer.ProductLevel.Key integerValue]> [keyValue.Key integerValue]) {
        [JAlertHelper jAlertWithTitle:@"您的技术等级不满足要求，请联系客服！" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"联系客服"] showInController:nil clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [CommonUtil callWithPhone:@"4000213618"];
            }
        }];
//      [ProgressHUD showInfo:@"您当前还不能接此等级单！" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}

- (void)CancelButtonTouchUpInside:(id)button{
    [self close];
}
- (void)close
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}
#pragma mark-数量加减
-(void)add
{
    int count =[tf_count.text intValue];
    if (count < self.maxNum) {
        tf_count.text = [NSString stringWithFormat:@"%d",count+1];
        _orderTypeDomain=[_orderTypeArray objectAtIndex:_indexPathRow];
        lb_detail.text=[NSString stringWithFormat:@"项目执行期间,系统在您的余额中将冻结%.f元作为保证金，项目完成后若无投诉，系统将自动解冻",[_orderTypeDomain.DepositValue doubleValue] *[tf_count.text intValue]];
        NSRange range = [lb_detail.text rangeOfString:[NSString stringWithFormat:@"%.f元",[_orderTypeDomain.DepositValue doubleValue] *[tf_count.text intValue]]];
        [CommonUtil setTextColor:lb_detail FontNumber:[UIFont systemFontOfSize:13.0] AndRange:range AndColor:[UIColor colorWithHex:@"ffa273"]];
    }else
    {//数量超出范围
        if (self.maxNum < [_orderTypeDomain.AvaliableQuantity integerValue]) {
            [ProgressHUD showInfo:[NSString stringWithFormat:@"最多能接%lu份",self.maxNum] withSucc:NO withDismissDelay:2];
        } else {
            [ProgressHUD showInfo:[NSString stringWithFormat:@"订单只剩%lu份",self.maxNum] withSucc:NO withDismissDelay:2];
        }
    }
}
-(void)reduce
{
    int count =[tf_count.text intValue];
    if (count > 1) {
        tf_count.text = [NSString stringWithFormat:@"%d",count-1];
        lb_detail.text=[NSString stringWithFormat:@"项目执行期间,系统在您的余额中将冻结%.f元作为保证金，项目完成后若无投诉，系统将自动解冻",[_orderTypeDomain.DepositValue doubleValue] *[tf_count.text intValue]];
        NSRange range = [lb_detail.text rangeOfString:[NSString stringWithFormat:@"%.f元",[_orderTypeDomain.DepositValue doubleValue] *[tf_count.text intValue]]];
        [CommonUtil setTextColor:lb_detail FontNumber:[UIFont systemFontOfSize:13.0] AndRange:range AndColor:[UIColor colorWithHex:@"ffa273"]];
    }else
    {
    }
}
-(void)tapagreement{
    if ([_delegate respondsToSelector:@selector(agreementTouchUp)]) {
//        [self close];
        [_delegate agreementTouchUp];

    }
}
@end
