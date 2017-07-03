//
//  VC_Home.m
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Home.h"
#import <ShareSDK/ShareSDK.h>
#import "JXBannerView.h"
#import "BaseService.h"
#import "JXRatingView.h"
#import "MineService.h"
#import "NoneView.h"
#import "PayUtil.h"
#import "WXApi.h"
#import "UpdateWindow.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIImageView+WebCache.h"
#import "RSKImageCropViewController.h"
#import <CoreLocation/CoreLocation.h>

#define BtnWidthScal 0.176

@interface VC_Home ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *_arr_banner;
    BaseService *_baseService;
    MineService *_mineService;
    BOOL _isRequestBanner;
    UIImagePickerController *_imagePickerController;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation VC_Home

- (void)startUpLocation {
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        [_locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@提示 message:@定位不成功 ,请确认开启定位 delegate:nil cancelButtonTitle:@取消 otherButtonTitles:@确定, nil];
//        [alertView show];
    }
}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             NSLog(@"定位完成:%@",city);
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

- (void)initData {
    _arr_banner = [NSMutableArray arrayWithCapacity:0];
    _baseService = [BaseService sharedService];
    _mineService = [MineService sharedService];
    _isRequestBanner = NO;
    
//    [self startUpLocation];
    
//    UIFont *font = [UIFont systemFontOfSize:14];
//    NSString *string = @"是第四爱iasisdidsids";
//    CGSize titleSize = [@"是第四爱iasisdidsids" sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
//    string boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>
    
    
}

- (void)layoutUI {
    self.jx_background = [CommonUtil zyzOrangeColor];
//    self.jx_navigationBar.tintColor =  [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
//    self.jx_navigationBar.alpha = 0.3;
//     self.jx_navigationBar.translucent = YES;
    [self layoutHeadView];
    [self setupLayout];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    [_imagePickerController.navigationController.navigationBar jj_setBackgroundColor:[UIColor colorWithHex:@"ff7b23"]];
    [_imagePickerController.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

- (void)setupLayout {
    if (IS_IPHONE_6) {
        //默认
        return;
    }
    
    CGFloat width = ScreenSize.width * BtnWidthScal;
    CGFloat fontSize = 15;
    CGFloat padding_x_1 = 0;
    CGFloat padding_x_2 = 0;
    CGFloat padding_x_3 = 0;
    CGFloat padding_x_4 = 0;
    CGFloat padding_y_1 = 0;
    CGFloat padding_y_2 = 0;
    CGFloat padding_y_3 = 0;
    CGFloat padding_y_4 = 0;
    CGFloat padding_baohan_x = 0;
    if (IS_IPHONE_4_OR_LESS) {
        width = 44;
        fontSize = 12;
        _layout_yuanpan_top.constant = _layout_yuanpan_bottom.constant = 2;
        
        padding_x_1 = 89;
        padding_y_1 = 5;
        
        padding_x_2 = 127;
        padding_y_2 = 55;
        
        padding_x_3 = 129;
        padding_y_3 = 120;
        
        padding_x_4 = 95;
        padding_y_4 = 170;
        
        padding_baohan_x = 16;
    } else if (IS_IPHONE_5) {
        
        _layout_yuanpan_top.constant = _layout_yuanpan_bottom.constant = 30;
        
        padding_x_1 = 89;
        padding_y_1 = 18;
        
        padding_x_2 = 146;
        padding_y_2 = padding_y_1 + width + 12;
        
        padding_x_3 = 146;
        padding_y_3 = padding_y_2 + width + 28;
        
        padding_x_4 = 89;
        padding_y_4 = padding_y_3 + width + 12;
        
        padding_baohan_x = 14;
        
        fontSize = 14;
    } else { // if (IS_IPHONE_6P)
        padding_x_1 = 112;
        padding_y_1 = 27;
        
        padding_x_2 = 200;
        padding_y_2 = padding_y_1 + width + 18;
        
        padding_x_3 = 200;
        padding_y_3 = padding_y_2 + width + 54;
        
        padding_x_4 = 112;
        padding_y_4 = padding_y_3 + width + 23;
        
        padding_baohan_x = 22;
    }
    
    _layout_img1_left.constant = padding_x_1;
    _layout_img2_left.constant = padding_x_2;
    _layout_img3_left.constant = padding_x_3;
    _layout_img4_left.constant = padding_x_4;
    
    _layout_img1_top.constant = padding_y_1;
    _layout_img2_top.constant = padding_y_2;
    _layout_img3_top.constant = padding_y_3;
    _layout_img4_top.constant = padding_y_4;
    
    _layout_baohan_left.constant = padding_baohan_x;
    
    [self setImgWidth:width];
    [self setLabeFontSize:fontSize];
//    return;
////    CGFloat width = ScreenSize.width * BtnWidthScal;
//    //6 的间距
////    CGFloat padding_x_1 = 87;
////    CGFloat padding_x_2 = 148;
////    CGFloat padding_x_3 = 153;
////    CGFloat padding_x_4 = 97;
////    CGFloat padding_y_1 = 18;
////    CGFloat padding_y_2 = 101;
////    CGFloat padding_y_3 = 208;
////    CGFloat padding_y_4 = 301;
////    padding_x_1 = ScreenSize.width/ 375 * padding_x_1;
////    padding_x_2 = ScreenSize.width/ 375 * padding_x_2;
////    padding_x_3 = ScreenSize.width/ 375 * padding_x_3;
////    padding_x_4 = ScreenSize.width/ 375 * padding_x_4;
////    
////    padding_y_1 = (ScreenSize.height - 66) / 601 * padding_y_1;
////    padding_y_2 = (ScreenSize.height - 66) / 601 * padding_y_2;
////    padding_y_3 = (ScreenSize.height - 66) / 601 * padding_y_3;
////    padding_y_4 = (ScreenSize.height - 66) / 601 * padding_y_4;
//    
//    
////    CGFloat fontSize = 15;
//    
//    if (IS_IPHONE_4_OR_LESS) {
//        width = 44;
//        padding_x_1 = 34 + 55;
//        padding_x_2 = 72 + 35;
//        padding_y_2 = 63;
//        
//        padding_x_3 = 75 + 32;
//        padding_y_3 = 116;
//        
//        padding_x_4 = 42 + 45;
//        padding_y_4 = 166;
//        
//        padding_baohan_x = 6;
//        
//        fontSize = 12;
//        
//        _layout_yuanpan_top.constant = _layout_yuanpan_bottom.constant = 2;
//        
//    } else if (IS_IPHONE_5) {
//        padding_x_1 = 70;
//        
//        padding_x_2 = 116;
//        padding_y_2 = padding_y_1 + width + 12;
//        
//        padding_x_3 = 118;
//        padding_y_3 = padding_y_2 + width + 22;
//        
//        padding_x_4 = 72;
//        padding_y_4 = padding_y_3 + width + 17;
//        
//        padding_baohan_x = 5;
//        
//        fontSize = 14;
//
//    } else if (IS_IPHONE_6P) {
//        padding_x_1 = 108;
//        
//        padding_x_2 = 176;
//        padding_y_2 = padding_y_1 + width + 23;
//        
//        padding_x_3 = 183;
//        padding_y_3 = padding_y_2 + width + 48;
//        
//        padding_x_4 = 120;
//        padding_y_4 = padding_y_3 + width + 30;
//
//    }
//    [self setImgWidth:width];
//    [_iv_yuanpan setNeedsUpdateConstraints];
//    [_iv_yuanpan updateConstraintsIfNeeded];
//    CGFloat height = [_iv_yuanpan systemLayoutSizeFittingSize:ScreenSize].height;
//    NSLog(@"%lf", height);
//    NSLog(@"%@", _iv_yuanpan);
//    
////    [_iv_yuanpan addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionInitial context:nil];
//    
//    
//    _layout_img1_left.constant = padding_x_1;
//    _layout_img2_left.constant = padding_x_2;
//    _layout_img3_left.constant = padding_x_3;
//    _layout_img4_left.constant = padding_x_4;
//    
//    _layout_img1_top.constant = padding_y_1;
//    _layout_img2_top.constant = padding_y_2;
//    _layout_img3_top.constant = padding_y_3;
//    _layout_img4_top.constant = padding_y_4;
//    
//    _layout_baohan_left.constant = padding_baohan_x;
//    
//    [self setLabeFontSize:fontSize];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == _iv_yuanpan && [keyPath isEqualToString:@"bounds"])
    {
        CGRect rect = _iv_yuanpan.frame;
        _layout_img1_left.constant = rect.size.width * 0.503;
        _layout_img2_left.constant = rect.size.width * 0.856;
    }
//    [_iv_yuanpan removeObserver:self forKeyPath:@"bounds"];
}

- (void)setImgWidth:(CGFloat)width {
    _layout_img1_width.constant = _layout_img1_height.constant =
    _layout_img2_width.constant = _layout_img2_height.constant =
    _layout_img3_width.constant = _layout_img3_height.constant =
    _layout_img4_width.constant = _layout_img4_height.constant =
    width;
    
    _layout_baohan_width.constant = _layout_baohan_height.constant = width;
}

- (void)setLabeFontSize:(CGFloat)size {
    UIFont *font = [UIFont systemFontOfSize:size];
    _lb_1.font = _lb_2.font = _lb_3.font = _lb_4.font = _lb_baohan.font = font;
}

- (void)layoutHeadView {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"home_head_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(home_head_left_pressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self setNavigationBarLeftItem:leftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(home_head_right_pressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self setNavigationBarRightItem:rightItem spaceWidth:-10];
    
    UIView *backTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width - 96, 30)];
    backTitleView.backgroundColor = [UIColor whiteColor];
    backTitleView.layer.masksToBounds = YES;
    backTitleView.layer.cornerRadius = 5;
    [backTitleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(home_head_search_pressed)]];
    UIImageView *iv_search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_head_search"]];
    iv_search.translatesAutoresizingMaskIntoConstraints = NO;
    [backTitleView addSubview:iv_search];
    NSLayoutConstraint *search_leftConstraint = [NSLayoutConstraint constraintWithItem:iv_search attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:backTitleView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
    NSLayoutConstraint *search_centerYConstraint = [NSLayoutConstraint constraintWithItem:iv_search attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backTitleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [backTitleView addConstraint:search_leftConstraint];
    [backTitleView addConstraint:search_centerYConstraint];
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UIColor colorWithHex:@"666666"]];
    [label setFont:[UIFont systemFontOfSize:13]];
    label.text = @"搜索企业/资质/人员/业绩";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [backTitleView addSubview:label];
    NSLayoutConstraint *label_left_constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:iv_search attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10];
    NSLayoutConstraint *label_centerY_constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backTitleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [backTitleView addConstraint:label_left_constraint];
    [backTitleView addConstraint:label_centerY_constraint];
    [self setNavigationBarTitleView:backTitleView];
}

- (void)layoutBannerView {
    [_baseService getBannerToResult:^(NSArray *bannerList, NSInteger code) {
        if (code == 1 && bannerList.count > 0) {
            [_arr_banner removeAllObjects];
            for (NSDictionary *tmpDic in bannerList) {
                BannerPageDomain *domain = [BannerPageDomain domainWithObject:tmpDic];
                [_arr_banner addObject:domain];
            }
            [self removeBannerView];
            [self addBannerView];
            _isRequestBanner = YES;
        }
    }];
}

- (void)addDefaultBannerView {
    [self addBannerDefault];
    [self addBannerView];
}

- (void)removeBannerView {
    JXBannerView *v = [_v_banner viewWithTag:1000];
    if (v != nil) {
        [v removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutUI];
    [self verfityAutoLogin];
    [self listenNetWork];
    [self updateVersion];
    
    [_iv_avater layoutIfNeeded];
    _iv_avater.layer.masksToBounds = YES;
    _iv_avater.layer.cornerRadius = _iv_avater.width / 2;
    
    [self setAvaterImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAvaterImage) name:@"NotificationChangeHomeAvater" object:nil];
}

- (void)setAvaterImage {
    if ([CommonUtil isLogin]) {
        UserDomain *user = [CommonUtil getUserDomain];
        [_iv_avater sd_setImageWithURL:[NSURL URLWithString:user.HeadImg] placeholderImage:[UIImage imageNamed:@"home_logo"]];
    } else {
        [_iv_avater setImage:[UIImage imageNamed:@"home_logo"]];
    }
}

- (void)verfityAutoLogin {
    if ([CommonUtil isLogin]) {
        [_mineService autoLoginToresult:^(UserDomain *user, NSInteger code) {
            if (code == 1) {
                //统计账号
                [MobClick profileSignInWithPUID:user.UserId];
                [CommonUtil saveUserDomian:user];
                [self verfityMessages:user];
                [self checkMsgAndPublishCount];
                [self checkNoneRequest];
            }
            [self setAvaterImage];
        }];
    }
}

- (void)verfityMessages:(UserDomain *)user {
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

- (void)checkMsgAndPublishCount {
    [_baseService getMessageCountWithResult:^(NSInteger count, NSInteger code) {
        if (code == 1) {
            [CommonUtil setMsgCount:count];
        }
    }];
    
    [_baseService getMinePublishCountWithResult:^(NSInteger count, NSInteger code) {
        if (code == 1) {
            [CommonUtil setMineCount:count];
        }
    }];
}

- (void)checkNoneRequest {
    NSString *jishu = [[CommonUtil objectForUserDefaultsKey:JiShuNoneRequest] toString];
    if (jishu != nil) {
        [self httpJishu:[jishu integerValue]];
    }
    
    NSString *yusuan = [[CommonUtil objectForUserDefaultsKey:YusuanNoneRequest] toString];
    if (yusuan != nil) {
        //提交，提交成功后移除
        [self httpYuSuan:[yusuan integerValue]];
    }
    NSString *bank = [[CommonUtil objectForUserDefaultsKey:BankNoneRequest] toString];
    if (yusuan != nil) {
        //提交，提交成功后移除
        [self httpYuSuan:[bank integerValue]];
    }
}

- (void)httpJishu:(NSInteger)data {
    [_baseService countHomeDataWithInterestType:1 isInterest:data result:^(NSInteger code) {
        if (code == 1) {
            [CommonUtil removeObjectforUserDefaultsKey:JiShuNoneRequest];
        }
    }];
}
- (void)httpYuSuan:(NSInteger)data {
    [_baseService countHomeDataWithInterestType:2 isInterest:data result:^(NSInteger code) {
        if (code == 1) {
            [CommonUtil removeObjectforUserDefaultsKey:JiShuNoneRequest];
        }
    }];
}
- (void)httpBank:(NSInteger)data {
    [_baseService countHomeDataWithInterestType:3 isInterest:data result:^(NSInteger code) {
        if (code == 1) {
            [CommonUtil removeObjectforUserDefaultsKey:BankNoneRequest];
        }
    }];
}

- (void)addBannerDefault {
    [_arr_banner removeAllObjects];
    BannerPageDomain *domain = [[BannerPageDomain alloc] init];
    domain.ImgUrl = @"default_banner";
    domain.ToUrl = @"";
    domain.Title = @"重庆自由找网络科技有限公司";
    [_arr_banner addObject:domain];
}

- (void)addBannerView {
    JXBannerView *bannerView = [JXBannerView bannerWithFrame:CGRectMake(0, 0, _v_banner.size.width, _v_banner.size.height) pages:_arr_banner];
//    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    bannerView.jx_clickAtIndex = ^(NSInteger index) {
        BannerPageDomain *domain = _arr_banner[index];
        if (domain.ToUrl != nil && ![domain.ToUrl isKindOfClass:[NSNull class]] &&![domain.ToUrl isEqualToString:@""] ) {
            [CommonUtil jxWebViewShowInController:self loadUrl:domain.ToUrl backTips:nil];
        }
    };
    bannerView.tag = 1000;
    [_v_banner addSubview:bannerView];
    
//    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_v_banner.mas_top);
//        make.left.equalTo(_v_banner.mas_left);
//        make.bottom.equalTo(_v_banner.mas_bottom);
//        make.right.equalTo(_v_banner.mas_right);
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self statusBarLightContent];
    [CommonUtil setSelectIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isRequestBanner) {
        [self addDefaultBannerView];
        [self layoutBannerView];
    }
}

#pragma mark - tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"招投标";
    } else {
        cell.textLabel.text = @"资质查询";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [PageJumpHelper pushToVCID:@"VC_QRequire" storyboard:Storyboard_Main parent:self];
    } else {
        [PageJumpHelper pushToVCID:@"VC_QueryQualification" storyboard:Storyboard_Main parent:self];
    }
}

#pragma mark - homepage click event
- (void)home_head_left_pressed {
    [PageJumpHelper pushToVCID:@"VC_CodeScan" storyboard:Storyboard_Main parent:self];
}

- (void)home_head_right_pressed {
    [PageJumpHelper pushToVCID:@"VC_Help" storyboard:Storyboard_Mine parent:self];
}

- (void)home_head_search_pressed {
//    [PageJumpHelper pushToVCID:@"VC_QueryQualification" storyboard:Storyboard_Main parent:self];
    [PageJumpHelper pushToVCID:@"VC_NewQuery" storyboard:Storyboard_Main parent:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_bid_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_QRequire" storyboard:Storyboard_Main parent:self];
    
    //原投标合作改为银行保函
    [PageJumpHelper pushToVCID:@"VC_LetterMain" storyboard:Storyboard_Main parent:self];
}

- (IBAction)btn_search_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_QueryQualification" storyboard:Storyboard_Main parent:self];
    [PageJumpHelper pushToVCID:@"VC_NewQuery" storyboard:Storyboard_Main parent:self];
}

- (IBAction)btn_jishu_pressed:(id)sender {
//    [NoneView showWithType:0];
    [PageJumpHelper pushToVCID:@"VC_Technology" storyboard:Storyboard_Main parent:self];
}

- (IBAction)btn_yusuan_pressed:(id)sender {
    
     [PageJumpHelper pushToVCID:@"VC_Budget" storyboard:Storyboard_Main parent:self];
//    [NoneView showWithType:1];
}

- (IBAction)btn_baohan_pressed:(id)sender {
//    NSString *orderString = @"biz_content=%7b%22subject%22%3a%22pay%22%2c%22body%22%3a%22pay%22%2c%22out_trade_no%22%3a%22T2010123456125%22%2c%22total_amount%22%3a%220.01%22%2c%22seller_id%22%3a%222088221665605324%22%2c%22product_code%22%3a%22QUICK_MSECURITY_PAY%22++%7d&method=alipay.trade.app.pay&version=1.0&app_id=2016052501440851&timestamp=2016-08-18+14%3a30%3a00&sign_type=RSA&charset=utf-8&sign=MC5uVfDuGPGmO8vhJAjHUkzPD0w%2fjF1EgAYAnojYRA1mXXO8NPq%2bGcgg%2fIF4XdwV91xqiV6b2tbyndfbTLiixNnOdK672hxrtVdFbOT3LZglsOxPp3nUg3oDrz8U2WdjuZ8Z6nGEovl9sHif9xdwUe8nGC6fCKIOle1dXKhszak%3d";
////    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)orderString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    
//    
//    [PayUtil alipayWithOrder:orderString fromScheme:@"" callback:^(NSDictionary *resultDic) {
//        NSLog(@"%@", resultDic);
//    }];
}

- (IBAction)btn_bank_pressed:(id)sender {
//    [NoneView showWithType:3];
//    [PageJumpHelper pushToVCID:@"VC_LetterMain" storyboard:Storyboard_Main parent:self];
    if ([CommonUtil isLogin]) {
        [self showImagePickerView];
    } else {
        [PageJumpHelper presentLoginViewController];
    }
    
}

- (void)showImagePickerView {
    //选择图片
    [JAlertHelper jSheetWithTitle:@"请设置您的头像" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"恢复默认头像" OtherButtonsArray:@[@"从相册中选择", @"拍照"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSDictionary *paramDic = @{kUserHeadImg: @""};
            [self modifyWithDic:paramDic];
        } else if (buttonIndex == 2) {
            //从相册中选择
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self openSelectImageView];
        } else if (buttonIndex == 3) {
            //拍照
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self openSelectImageView];
        }
    }];
}

- (void)openSelectImageView {
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - imagepickerview
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_imagePickerController dismissViewControllerAnimated:NO completion:nil];
    UIImage *img_select = info[UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:img_select];
    imageCropVC.view.backgroundColor = [UIColor whiteColor];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:NO completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    [_mineService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:croppedImage type:1 success:^(id responseObject, NSInteger code) {
        if (code != 1) {
            return ;
        }
        [ProgressHUD hideProgressHUD];
        NSString *urlPath = responseObject[kResponseDatas];
        NSDictionary *paramDic = @{kUserHeadImg: urlPath};
        [self modifyWithDic:paramDic];
    } fail:^{
    }];
}

- (void)modifyWithDic:(NSDictionary *)paramDic {
    [_mineService modifyUserInfoWithParameters:paramDic result:^(UserDomain *user, NSInteger code) {
        if (code == 1) {
            [CommonUtil saveUserDomian:user];
            [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:1];
            [self setAvaterImage];
        }
    }];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateVersion {
    [_baseService checkUpdateWithVersion:[self version] ToResult:^(AppInfoDomain *appInfo, NSInteger code) {
        if (code != 1) {
            return ;
        }
        if (appInfo.Force == 1) {
//            [JAlertHelper jAlertWithTitle:@"有新版本,请更新" message:nil cancleButtonTitle:@"去更新" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//            }];
            [[UpdateWindow sharedInstance] showInContent:appInfo.Content version:appInfo.LatestVersion donwloadUrlString:appInfo.DownloadUrl type:1];
            
        } else if (appInfo.Force == 0) {
//            [JAlertHelper jAlertWithTitle:@"有新版本,前往更新" message:nil cancleButtonTitle:@"暂不更新" OtherButtonsArray:@[@"前往更新"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//            }];
            [[UpdateWindow sharedInstance] showInContent:appInfo.Content version:appInfo.LatestVersion donwloadUrlString:appInfo.DownloadUrl type:0];
        }
    }];
}

- (void)listenNetWork {
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
     AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
     AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
     AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
     };
     */
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                [[[UIAlertView alloc] initWithTitle:@"未识别的网络!请确认网络畅通后使用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                [[[UIAlertView alloc] initWithTitle:@"网络链接断开!请确认网络畅通后使用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                if (!_isRequestBanner) {
                    [self layoutBannerView];
                }
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                if (!_isRequestBanner) {
                    [self layoutBannerView];
                }
            }
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}
@end
