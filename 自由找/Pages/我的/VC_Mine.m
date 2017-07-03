//
//  VC_Mine.m
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Mine.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "VC_Login.h"
#import "ProducerService.h"
#import "PayService.h"


#define kHederDefaultHeight 178
//我的钱包
#define CellWallet @"Wallet"
//我的接单
#define CellOrderTaking @"OrderTaking"
//我要认证
#define CellCertification @"Certification"
//我的收藏
#define CellCollection @"Collection"

//我的订单
#define CellOrder @"Order"
//所在企业
#define CellCompany @"Company"
//合作企业
#define CellCompanyHelp @"CompanyHelp"
//我的积分
#define CellScore @"Score"
//邀请朋友
#define CellInvite @"Invite"
//系统设置
#define CellSetting @"Setting"

#define RatingBarBeginTag 100

@interface VC_Mine ()
{
    CGFloat _headerHeight;
    CGFloat _headerCellHeight;
    CGFloat _avaterTop;
    CGFloat _avaterWidth;
    
    //header 使用到的view--已登录
    UIImageView *_iv_avater;
    UILabel *_lb_name;
    UIImageView *_iv_phone;
    UILabel *_lb_phone;
    UIView *_v_name_star;
    UILabel *_lb_int;
    UILabel *_lb_decimal;
    
    //header 使用到的view--未登录
    UILabel *_lb_welcome;
    UIImageView*_iv_btn_back;
    UIView *_v_seperate;
    UIButton *_btn_login;
    UIButton *_btn_regist;
//    UILabel *_lb_he;
    NSArray *arr_menu;
    NSMutableArray *_arr_menu;
    UserDomain *_user;
    
    //分享
    NSArray *_sharePlatformSubType;
    
    BOOL firstEnter;
    ProducerService *_producerService;
    ProducerDomain *_producer;
    
    PayService *_payService;
}

@end

@implementation VC_Mine

- (void)initData {
    firstEnter = YES;
    _payService = [PayService sharedService];
    _producerService=[ProducerService sharedService];
    
    if (IS_IPHONE_4_OR_LESS) {
        _headerHeight = 140;
        _avaterTop = 14;
        _avaterWidth = 50;
    } else if (IS_IPHONE_5) {
        _avaterTop = 20;
        _avaterWidth = 58;
        _headerHeight = 150;
    } else {
        _avaterTop = 24;
        _avaterWidth = 68;
        _headerHeight = kHederDefaultHeight;
    }
    arr_menu = @[
                  @[@{}],
                  @[@{kCellImage: @"newmine_qyzs", kCellName: @"企业展示", kCellKey: CellCompany, kCellDefaultText: @"管理您所在企业的信息和电话"},
                    @{kCellImage: @"newmine_hzqy", kCellName: @"合作企业", kCellKey: CellCompanyHelp, kCellDefaultText: @"添加管理您熟悉的企业"},
                    @{kCellImage: @"newmine_wyrz", kCellName: @"我要认证", kCellKey: CellCertification, kCellDefaultText:@"接单用户请在此认证"},
                    @{kCellImage: @"newmine_wdsc", kCellName: @"我的收藏", kCellKey: CellCollection, kCellDefaultText:@""},
                    ],
                  
                    @[
                      @{kCellImage: @"newmine_yqpy", kCellName: @"邀请朋友", kCellKey: CellInvite, kCellDefaultText: @"可获得积分"},
                      @{kCellImage: @"newmine_wdjf", kCellName: @"我的积分", kCellKey: CellScore, kCellDefaultText: @"可用于资质查询"},
                      @{kCellImage: @"newmine_xtsz", kCellName: @"系统设置", kCellKey: CellSetting, kCellDefaultText: @" "}
                      ]
                  
//                  @[
//                      @{kCellImage: @"cell_mywallet", kCellName: @"我的钱包", kCellKey: CellWallet, kCellDefaultText: @" "},
//                      @{kCellImage: @"mine_cell_0", kCellName: @"我的订单", kCellKey: CellOrder, kCellDefaultText: @" "},
//                      @{kCellImage: @"cell_ordertaking", kCellName: @"我的接单", kCellKey: CellOrderTaking, kCellDefaultText: @""}
//                      ],
//                  @[
//                      @{kCellImage: @"cell_cerfication", kCellName: @"我要认证", kCellKey: CellCertification, kCellDefaultText:@"接单用户请在此认证"},
//                      @{kCellImage: @"mine_cell_1", kCellName: @"企业展示", kCellKey: CellCompany, kCellDefaultText: @"管理您所在企业的信息和电话"},
//                      @{kCellImage: @"mine_cell_2", kCellName: @"我的积分", kCellKey: CellScore, kCellDefaultText: @"可用于资质查询"}
////                      @{kCellImage: @"mine_collection", kCellName: @"我的收藏", kCellKey:CellCollection, kCellDefaultText: @" "}
//                      ],
//                  @[
//                      @{kCellImage: @"mine_cell_3", kCellName: @"邀请朋友", kCellKey: CellInvite, kCellDefaultText: @"可获得积分"},
//                      @{kCellImage: @"mine_cell_4", kCellName: @"系统设置", kCellKey: CellSetting, kCellDefaultText: @" "}
//                      ]
                  ];
    _arr_menu=[NSMutableArray arrayWithArray:arr_menu];
    _sharePlatformSubType=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeQQFriend],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatSession],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatTimeline],[NSString stringWithFormat:@"%lu",SSDKPlatformTypeSMS], nil];
}

- (void)layoutUI {
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];
    //去除navigabar底部的横线
    NSArray *list=self.jx_navigationBar.subviews;
    for (id obj in list) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)obj;
            imageView.hidden=YES;
        }
    }
    [self layoutHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTodoList) name:@"Notification_ShowToDoList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toWalletVC) name:Notification_Wallet_ToWalletMain object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshloadCer) name:@"RE_Certification_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSection2) name:@"RELOAD_SECTION2_NOTIFICATION" object:nil];
}

- (void)reloadSection2 {
    [self.tableView reloadData];
}

-(void)refreshloadCer{
    [self loadCer:0];
}
- (void)showTodoList {
    UserDomain *user = [CommonUtil getUserDomain];
    NSDictionary *todoList = user.TodoList;
    NSString *newProject = [todoList objectForKey:@"NewProject"];
    NSString *newSignUp = [todoList objectForKey:@"NewSignUp"];
    NSMutableArray *btns = [NSMutableArray array];
    NSString *title = @"";
    BOOL showSignUp = NO;
    if ([newSignUp isEqualToString:@"1"]) {
        showSignUp = YES;
        title = @"有新的企业给您的资质需求报名";
        [btns addObject:@"去看看"];
    }
    BOOL showProject = NO;
    if (!showSignUp && [newProject isEqualToString:@"1"]) {
        showProject = YES;
        title = @"您有可报名的项目";
        [btns addObject:@"去报名"];
    }
    
    if (!showSignUp && !showProject) {
        return;
    }
    if (showSignUp) {
        showProject = NO;
    }
    
    todoList = @{@"NewProject":@"0", @"NewSignUp":@"0"};
    user.TodoList = todoList;
    [CommonUtil saveUserDomian:user];
    
    [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"取消" OtherButtonsArray:btns showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString *vcID = @"";
            if (showSignUp) {
                vcID = @"VC_OurPublish";
                [PageJumpHelper pushToVCID:vcID storyboard:Storyboard_Mine parameters:@{kPageType: @1} parent:self];
            } else {
                vcID = @"VC_QRequire";
                [PageJumpHelper pushToVCID:vcID storyboard:Storyboard_Main parameters:@{kPageType: @1} parent:self];
            }
        }
    }];
}

- (void)layoutHeaderView {
    self.mineHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, _headerHeight)];
    self.mineHeaderView.userInteractionEnabled = YES;
    self.mineHeaderView.backgroundColor = [CommonUtil zyzOrangeColor];
    [self.tableView addSubview:self.mineHeaderView];
    [self layoutLogoutHeaderView];
    [self layoutLoginHeaderView];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.mineHeaderView.bounds];
    self.tableView.tableHeaderView = backView;
    backView.hidden = YES;
}
- (void)layoutLogoutHeaderView {
    _lb_welcome = [[UILabel alloc] init];
    _lb_welcome.textColor = [UIColor whiteColor];
    _lb_welcome.font = [UIFont systemFontOfSize:16];
    _lb_welcome.text = @"欢迎来到自由找!";
    _lb_welcome.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mineHeaderView addSubview:_lb_welcome];
    NSLayoutConstraint *layout_lb_welcome_top = [NSLayoutConstraint constraintWithItem:_lb_welcome attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mineHeaderView attribute:NSLayoutAttributeTop multiplier:1.0 constant:28];
    NSLayoutConstraint *layout_lb_welcome_centerX = [NSLayoutConstraint constraintWithItem:_lb_welcome attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_mineHeaderView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.mineHeaderView addConstraint:layout_lb_welcome_top];
    [self.mineHeaderView addConstraint:layout_lb_welcome_centerX];
    
    _iv_btn_back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_head_btn_back"]];
    _iv_btn_back.translatesAutoresizingMaskIntoConstraints = NO;
    _iv_btn_back.userInteractionEnabled = YES;
    [self.mineHeaderView addSubview:_iv_btn_back];
    NSLayoutConstraint *layout_btn_back_top = [NSLayoutConstraint constraintWithItem:_iv_btn_back attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lb_welcome attribute:NSLayoutAttributeBottom multiplier:1.0 constant:27];
    NSLayoutConstraint *layout_btn_back_centerX = [NSLayoutConstraint constraintWithItem:_iv_btn_back attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_mineHeaderView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.mineHeaderView addConstraint:layout_btn_back_top];
    [self.mineHeaderView addConstraint:layout_btn_back_centerX];
    
    _v_seperate = [[UIView alloc] init];
    _v_seperate.hidden = NO;
    _v_seperate.backgroundColor = [CommonUtil zyzOrangeColor];
    _v_seperate.translatesAutoresizingMaskIntoConstraints = NO;
    [_iv_btn_back addSubview:_v_seperate];
    NSLayoutConstraint *layout_lb_seperate_centerX = [NSLayoutConstraint constraintWithItem:_v_seperate attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_iv_btn_back attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *layout_lb_seperate_centerY = [NSLayoutConstraint constraintWithItem:_v_seperate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_iv_btn_back attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *layout_lb_seperate_width = [NSLayoutConstraint constraintWithItem:_v_seperate attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1];
    NSLayoutConstraint *layout_lb_seperate_height = [NSLayoutConstraint constraintWithItem:_v_seperate attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_iv_btn_back attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-20];
    [_iv_btn_back addConstraint:layout_lb_seperate_centerX];
    [_iv_btn_back addConstraint:layout_lb_seperate_centerY];
    [_v_seperate addConstraint:layout_lb_seperate_width];
    [_iv_btn_back addConstraint:layout_lb_seperate_height];
    
    _btn_login = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [_btn_login setTintColor:[CommonUtil zyzOrangeColor]];
    _btn_login.translatesAutoresizingMaskIntoConstraints = NO;
    [_iv_btn_back addSubview:_btn_login];
    
//    _lb_he = [[UILabel alloc] init];
//    _lb_he.text = @"或";
//    _lb_he.font = [UIFont systemFontOfSize:12];
//    _lb_he.textColor = [CommonUtil zyzOrangeColor];
//    [_iv_btn_back addSubview:_lb_he];
//    [_lb_he mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_v_seperate.mas_centerX);
//        make.centerY.equalTo(_v_seperate.mas_centerY);
//    }];
    
    NSLayoutConstraint *layout_login_top = [NSLayoutConstraint constraintWithItem:_btn_login attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_iv_btn_back attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *layout_login_bottom = [NSLayoutConstraint constraintWithItem:_btn_login attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_iv_btn_back attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *layout_login_left = [NSLayoutConstraint constraintWithItem:_btn_login attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_iv_btn_back attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10];
    NSLayoutConstraint *layout_login_right = [NSLayoutConstraint constraintWithItem:_btn_login attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_v_seperate attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [_iv_btn_back addConstraint:layout_login_top];
    [_iv_btn_back addConstraint:layout_login_bottom];
    [_iv_btn_back addConstraint:layout_login_left];
    [_iv_btn_back addConstraint:layout_login_right];
    
    _btn_regist = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn_regist setTitle:@"注册" forState:UIControlStateNormal];
    [_btn_regist setTintColor:[CommonUtil zyzOrangeColor]];
    _btn_regist.translatesAutoresizingMaskIntoConstraints = NO;
    [_iv_btn_back addSubview:_btn_regist];
    [_btn_regist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iv_btn_back.mas_top).with.offset(0);
        make.bottom.equalTo(_iv_btn_back.mas_bottom).with.offset(0);
        make.left.equalTo(_v_seperate.mas_right).with.offset(0);
        make.right.equalTo(_iv_btn_back.mas_right).with.offset(-10);
    }];
    
    [_btn_login addTarget:self action:@selector(toLoginView:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_regist addTarget:self action:@selector(toRegistView:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)toLoginView:(id)sender {
    [self presentLoginViewController];
}
- (void)toRegistView:(id)sender {
    [self presentRegistViewController];
}

- (void)presentLoginViewController {
    UINavigationController *loginNav = [[self storyboard] instantiateViewControllerWithIdentifier:@"NVC_Login"];
    [self presentViewController:loginNav animated:YES completion:nil];
}

- (void)presentRegistViewController {
    UINavigationController *loginNav = [[self storyboard] instantiateViewControllerWithIdentifier:@"NVC_Login"];
    VC_Login *vc_login = [loginNav viewControllers].firstObject;
    vc_login.isShowRegistVC = YES;
    [self presentViewController:loginNav animated:YES completion:nil];
}

- (void)layoutLoginHeaderView {
    _iv_avater = [[UIImageView alloc] init];
    _iv_avater.translatesAutoresizingMaskIntoConstraints = NO;
    _iv_avater.userInteractionEnabled = YES;
    _iv_avater.layer.masksToBounds = YES;
    _iv_avater.layer.cornerRadius = _avaterWidth / 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toEditMine:)];
    [_iv_avater addGestureRecognizer:tap];
    [_mineHeaderView addSubview:_iv_avater];
    [_iv_avater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_avaterWidth);
        make.height.mas_equalTo(_avaterWidth);
        make.centerX.equalTo(_mineHeaderView.mas_centerX);
        make.top.equalTo(_mineHeaderView.mas_top).with.offset(_avaterTop);
    }];
    
    _lb_name = [[UILabel alloc] init];
    _lb_name.font = [UIFont systemFontOfSize:16];
    _lb_name.textColor = [UIColor whiteColor];
    _lb_name.translatesAutoresizingMaskIntoConstraints = NO;
    [_mineHeaderView addSubview:_lb_name];
    [_lb_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iv_avater.mas_bottom).with.offset(15);
        make.centerX.equalTo(_mineHeaderView.mas_centerX).with.offset(-60);
    }];
    
    _v_name_star = [[UIView alloc] init];
//    _v_name_star.backgroundColor = [UIColor whiteColor];
    [_mineHeaderView addSubview:_v_name_star];
    [_v_name_star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lb_name.mas_right).with.offset(10);
        make.centerY.equalTo(_lb_name.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(15);
    }];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *tmpIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mine_Star_None"]];
        tmpIV.tag = RatingBarBeginTag + i;
        [_v_name_star addSubview:tmpIV];
        
        [tmpIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_v_name_star.mas_left).with.offset(i * 17);
            make.centerY.equalTo(_v_name_star.mas_centerY);
        }];

        _lb_int = [[UILabel alloc] init];
        _lb_int.textColor = [UIColor whiteColor];
        _lb_int.font = [UIFont systemFontOfSize:16];
        [_v_name_star addSubview:_lb_int];
        [_lb_int mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_v_name_star.mas_left).with.offset(90);
            make.centerY.equalTo(_v_name_star.mas_centerY);
        }];
        
        _lb_decimal = [[UILabel alloc] init];
        _lb_decimal.textColor = [UIColor whiteColor];
        _lb_decimal.font = [UIFont systemFontOfSize:10];
        [_v_name_star addSubview:_lb_decimal];
        [_lb_decimal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lb_int.mas_top);
            make.left.equalTo(_lb_int.mas_right);
        }];
    }
    
    
    _lb_phone = [[UILabel alloc] init];
    _lb_phone.font = [UIFont systemFontOfSize:12];
    _lb_phone.textColor = [UIColor whiteColor];
    _lb_phone.translatesAutoresizingMaskIntoConstraints = NO;
//    _lb_phone.text = @"17708347776";
    [_mineHeaderView addSubview:_lb_phone];
    [_lb_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lb_name.mas_bottom).with.offset(8);
        make.centerX.equalTo(_mineHeaderView.mas_centerX).with.offset(6);
    }];
    
    _iv_phone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mine_head_phone"]];
    _iv_phone.translatesAutoresizingMaskIntoConstraints = NO;
    [_mineHeaderView addSubview:_iv_phone];
    [_iv_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_lb_phone.mas_left).with.offset(-4);
        make.centerY.equalTo(_lb_phone.mas_centerY);
    }];
}

- (void)toEditMine:(UITapGestureRecognizer *)recognizer {
    [PageJumpHelper pushToVCID:@"VC_EditMine" storyboard:Storyboard_Mine parent:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"我的";
    
    [self initData];
    [self layoutUI];
    [self loadCer:0];
}
-(void)loadCer:(NSInteger)touchType{
    if ([CommonUtil isLogin]) {
        //            查看认证信息
        [_producerService getSelfInfoToResult:^(NSInteger code, ProducerDomain *producer) {
            if (code==1) {
                _producer=producer;
                
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[[_arr_menu objectAtIndex:1]objectAtIndex:2]];
                 if (producer!=nil && producer.ProductLevel.Value !=nil && [producer.AuthStatus integerValue]==2) {
                    [dic setValue:producer.ProductLevel.Value forKey:kCellDefaultText];
                 }else if([producer.AuthStatus integerValue]==4){
                      [dic setValue:@"未通过" forKey:kCellDefaultText];
                 }else if([producer.AuthStatus integerValue]==1){
                     [dic setValue:@"审核中" forKey:kCellDefaultText];
                 }else if([producer.AuthStatus integerValue]==0){
                     [dic setValue:@"接单用户请在此认证" forKey:kCellDefaultText];
                 }
                    NSMutableArray  *arr=[NSMutableArray arrayWithArray:[_arr_menu objectAtIndex:1]];
                    [arr replaceObjectAtIndex:2 withObject:dic];
                    [_arr_menu replaceObjectAtIndex:1 withObject:arr];
                    [self reloadIndexSelction:1];
                [self.tableView reloadData];
                if (touchType==1) {
                    if (producer!=nil) {
                        if([producer.AuthStatus integerValue]==1){
                            [ProgressHUD showInfo:@"正在审核中，请耐心等待..." withSucc:NO withDismissDelay:2];
                        }else{
                            [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{@"producerdomian":producer,kPageType:@"0"} parent:self];
                        }
                    }else{
                        [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{kPageType:@"0"} parent:self];
                    }
                }
               
            }else{
                if (touchType==1) {
                    [ProgressHUD showInfo:@"获取数据失败，请稍后重试！" withSucc:NO withDismissDelay:2];
                }
            }
        }];
    }else{
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[[_arr_menu objectAtIndex:1]objectAtIndex:2]];
        [dic setValue:@"" forKey:kCellDefaultText];
        NSMutableArray  *arr=[NSMutableArray arrayWithArray:[_arr_menu objectAtIndex:1]];
        [arr replaceObjectAtIndex:2 withObject:dic];
        [_arr_menu replaceObjectAtIndex:1 withObject:arr];
        [self reloadIndexSelction:1];
        if (touchType==1) {
             [PageJumpHelper presentLoginViewController];
        }
    
    }

}
- (void)reloadIndexSelction:(NSInteger)selctionindex {
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:selctionindex];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self statusBarLightContent];
    [CommonUtil setSelectIndex:2];
    if ([CommonUtil isLogin]) {
        [self showLoginHeader];
    } else {
        [self showLogoutHeader];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (firstEnter) {
        firstEnter = NO;
        [CommonUtil setPublishCount];
    }
}

- (void)showLoginHeader {
    _iv_avater.hidden = NO;
    _lb_name.hidden = NO;
    _lb_phone.hidden = NO;
    _iv_phone.hidden = NO;
    _v_name_star.hidden = NO;
    _lb_welcome.hidden = YES;
    _iv_btn_back.hidden = YES;
    
    _user = [CommonUtil getUserDomain];
    _lb_name.text = _user.UserName;
    _lb_phone.text = _user.Phone;
    [_iv_avater sd_setImageWithURL:[NSURL URLWithString:_user.HeadImg] placeholderImage:[UIImage imageNamed:@"default_avater"]];
    
    //设置评分
    NSString *rating = _user.Rank;
    NSArray *arr_rating = [rating componentsSeparatedByString:@"."];
    NSInteger r_int = [arr_rating.firstObject integerValue];
    for (int i = 0; i < r_int; i++) {
        UIImageView *iv = [_v_name_star viewWithTag:(RatingBarBeginTag + i)];
        if (iv != nil) {
            [iv setImage:[UIImage imageNamed:@"Mine_Star_2"]];
        }
    }
    
    NSInteger r_decimal = [arr_rating.lastObject integerValue];
    if (r_decimal >= 5) {
        UIImageView *iv = [_v_name_star viewWithTag:(100 + r_int)];
        [iv setImage:[UIImage imageNamed:@"Mine_Star_1"]];
    }
    
    _lb_int.text = arr_rating.firstObject;
    _lb_decimal.text = [NSString stringWithFormat:@".%@", arr_rating.lastObject];
    
}

- (void)showLogoutHeader {
    _iv_avater.hidden = YES;
    _lb_name.hidden = YES;
    _lb_phone.hidden = YES;
    _iv_phone.hidden = YES;
    _v_name_star.hidden = YES;
    _lb_welcome.hidden = NO;
    _iv_btn_back.hidden = NO;
    
    _user = nil;
    _lb_name.text = @"";
    _lb_name.text = @"";
}


#pragma mark - UITableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_menu objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MineCell";
    static NSString *HeaderCellIdentifier = @"Cell_MineCustom";
    if (indexPath.section == 0) {
        Cell_MineCustom *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
        cell.delegate = self;
//        cell.user = _user;
        return cell;
    } else {
        NSDictionary *paramDic = [[_arr_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.imageView.image = [UIImage imageNamed:paramDic[kCellImage]];
        cell.textLabel.text = paramDic[kCellName];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        if ([paramDic[kCellKey] isEqualToString:CellCertification]) {
            cell.detailTextLabel.text=@"";
            UIButton *btn_certification = [cell.contentView viewWithTag:100001];
            if (btn_certification == nil) {
                if ([paramDic[kCellDefaultText] isEqualToString:@"接单用户请在此认证"]||[paramDic[kCellDefaultText] isEqualToString:@"未通过"]||[paramDic[kCellDefaultText] isEqualToString:@"审核中"]||[paramDic[kCellDefaultText] isEmptyString]) {
                    NSArray *arr = cell.contentView.subviews;
                    for (UIView *tmpView in arr) {
                        if ([tmpView isKindOfClass:[UIButton class]]) {
                            [tmpView removeFromSuperview];
                        }
                    }
                    cell.detailTextLabel.text =paramDic[kCellDefaultText];
                } else {
                    btn_certification=[[UIButton alloc]init];
                    btn_certification.tag = 100001;
                    [btn_certification setBackgroundImage:[UIImage imageNamed:@"cer_bg"] forState:UIControlStateNormal];
                    [btn_certification setImage:[UIImage imageNamed:@"cerfication_b1"] forState:UIControlStateNormal];
                    btn_certification.titleLabel.font=[UIFont systemFontOfSize:12.0];
                    [btn_certification setTitleColor:[UIColor colorWithHex:@"ff9200"] forState:UIControlStateNormal];
                    [btn_certification setTitle:[NSString stringWithFormat:@"  %@",paramDic[kCellDefaultText]]forState:UIControlStateNormal];
                    btn_certification.userInteractionEnabled=NO;
                    [cell.contentView addSubview:btn_certification];
                    [btn_certification mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(cell.contentView.mas_right).with.offset(-8);
                        make.centerY.equalTo(cell.contentView.mas_centerY).with.offset(0);
                    }];
                }
            }
        } else {
            UIButton *btn_certification = [cell.contentView viewWithTag:100001];
            if (btn_certification != nil) {
                [btn_certification removeFromSuperview];
            }
            cell.detailTextLabel.text = paramDic[kCellDefaultText];
            if([paramDic[kCellKey] isEqualToString:CellCompany]) {
                if ([CommonUtil isLogin] && [CommonUtil getUserDomain].Sites.count > 0) {
                    cell.detailTextLabel.text = [CommonUtil getUserDomain].Sites.firstObject.CompanyName;
                } else {
                    cell.detailTextLabel.text = paramDic[kCellDefaultText];
                }
            }
        }
      return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 82;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *paramDic = [[_arr_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *key = paramDic[kCellKey];
    if (key != nil) {
        if ([CellScore isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_Score" storyboard:Storyboard_Mine parent:self];
        }
        else if ([CellOrderTaking isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_MyOrder" storyboard:Storyboard_Mine parent:self];
        }
        else if ([CellSetting isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_SystemSet" storyboard:Storyboard_Mine parent:self];
        }else if ([CellInvite isEqualToString:key]){
            [self shareUI];
        }else if ([CellCompany isEqualToString:key]){
            [PageJumpHelper pushToVCID:@"VC_InEnterprise" storyboard:Storyboard_Mine parent:self];
        } else if ([CellCompanyHelp isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_Customer" storyboard:Storyboard_Mine parent:self];
        } else if ([CellCertification isEqualToString:key]){
//            if ([CommonUtil isLogin]) {
//                //            查看认证信息
//                [_producerService getSelfInfoToResult:^(NSInteger code, ProducerDomain *producer) {
//                    if (code==1) {
//                        if (producer!=nil) {
//                            if([producer.AuthStatus integerValue]==1){
//                                [ProgressHUD showInfo:@"正在审核中，请耐心等待..." withSucc:NO withDismissDelay:2];
//                            }else{
//                                [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{@"producerdomian":producer,kPageType:@"0"} parent:self];
//                            }
//                        }else{
//                            [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{kPageType:@"0"} parent:self];
//                        }
//                        
//                    }else{
//                        [ProgressHUD showInfo:@"获取数据失败，请稍后重试！" withSucc:NO withDismissDelay:2];
//                    }
//                }];
//            } else {
//                [PageJumpHelper presentLoginViewController];
//            }
            [self loadCer:1];
//            if ([CommonUtil isLogin]) {
//                [PageJumpHelper pushToVCID:@"VC_Authen" storyboard:Storyboard_Mine parent:self];
//            } else {
//                [PageJumpHelper presentLoginViewController];
//            }
            
        }else if ([CellWallet isEqualToString:key]){
//            [PageJumpHelper pushToVCID:@"VC_MyWallet" storyboard:Storyboard_Mine parent:self];
            
            if ([CommonUtil isLogin]) {
                [self checkPushToMyWallet];
            } else {
                [PageJumpHelper presentLoginViewController];
            }
            
        }else if([CellOrder isEqualToString:key]){
            [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parent:self];
        }else if([CellCollection isEqualToString:key]){
            [PageJumpHelper pushToVCID:@"VC_MyCollection" storyboard:Storyboard_Mine parent:self];
        }
    }
}

- (void)checkPushToMyWallet {
    [_payService getWalletInfoToResult:^(NSInteger code, WalletDomain *wallet) {
        if (code != 1) {
            return;
        }
        if (wallet.Balance == nil) {
            [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parent:self];
        } else {
            [PageJumpHelper pushToVCID:@"VC_MyWallet" storyboard:Storyboard_Mine parameters:@{kPageDataDic: wallet} parent:self];
        }
    }];
}

- (void)toWalletVC {
    [_payService getWalletInfoToResult:^(NSInteger code, WalletDomain *wallet) {
        if (code != 1) {
            return;
        }
        UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        [self.navigationController popToViewController:VC animated:NO];
        [PageJumpHelper pushToVCID:@"VC_MyWallet" storyboard:Storyboard_Mine parameters:@{kPageDataDic: wallet} parent:self];
    }];
}


#pragma mark --分享
-(void)shareUI{
    ShareHelper *sharehelper=[[ShareHelper alloc] init];
    sharehelper.shareTitle=@"分享邀请好友";
    [sharehelper setButtonTitles:[NSMutableArray arrayWithObjects:@"QQ好友", @"微信好友",@"朋友圈", @"短信", nil]];
    [sharehelper setButtonImages:[NSMutableArray arrayWithObjects:@"m1", @"m2",@"m3", @"m4", @"m4",nil]];
    [sharehelper setOnButtonTouchUpInside:^(ShareHelper *shareHelper, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[shareHelper tag]);
        [self shareButtonIndex:buttonIndex];
        [shareHelper close];
        
    }];
    [sharehelper show];
}

-(void)shareButtonIndex:(int)buttonIndex{
    if (buttonIndex !=9999) {
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"sharedImage"]];
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"资质查询、投标技术标、投标预算、银行保函http://www.ziyouzhao.com"
                                             images:imageArray
                                                url:[NSURL URLWithString:@"http://www.ziyouzhao.com"]
                                              title:@"建筑招投标必备手机软件 "
                                               type:SSDKContentTypeAuto];
        [ShareSDK share:[[_sharePlatformSubType objectAtIndex:buttonIndex]integerValue] parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            NSLog(@"====%@", error);
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [ProgressHUD showInfo:@"分享成功" withSucc:NO withDismissDelay:2];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [ProgressHUD showInfo:@"分享失败" withSucc:NO withDismissDelay:2];
                    break;
                }
                default:
                    break;
            }
        }];

    }
  }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取当前活动的tableview
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        _mineHeaderView.frame = CGRectMake(offsetY/2, offsetY, ScreenSize.width - offsetY, _headerHeight - offsetY);  // 修改头部的frame值就行了
    }
}

#pragma mark - CustomCell click
- (void)clickWithMineCustomType:(MineCustomType)type {
    NSString *vcID = @"";
    switch (type) {
        case MinePublish:
        {
            //原我的发布===改为我的钱包
            if ([CommonUtil isLogin]) {
                [self checkPushToMyWallet];
            } else {
                [PageJumpHelper presentLoginViewController];
            }
        }
            break;
        case MineApply: //原我的接单--改为我的收藏
//            vcID = @"VC_MyCollection";//@"VC_OurAttention";
        {
            //又改为我的订单
            [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parent:self];
        }
            break;
        case MineCustomer:
//            vcID = @"VC_Customer";
        {
            //原我的客户==改为我要接单
            [PageJumpHelper pushToVCID:@"VC_MyOrder" storyboard:Storyboard_Mine parent:self];
        }
            break;
        default:
            break;
    }
//    [PageJumpHelper pushToVCID:vcID storyboard:Storyboard_Mine parent:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
