//
//  VC_Base.m
//  奔跑兄弟
//
//  Created by guojie on 16/4/20.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import "VC_Base.h"
#import "UINavigationBar+BackgroundColor.h"

@interface VC_Base ()
{
    UINavigationBar *_keyboardNavigationbar;
}
@end

@implementation VC_Base

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [BaseService sharedService];
    [self addToolbar];
    [self registKeyboardNotification];
    self.view.backgroundColor = [CommonUtil zyzBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)addToolbar {
    self.jx_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 64)];
    self.jx_navigationBar.barTintColor = [UIColor colorWithHex:@"EBEBEB"];
    [self.view addSubview:self.jx_navigationBar];
    UINavigationItem *item = [[UINavigationItem alloc] init];
    self.jx_navigationBar.items = @[item];
    //添加返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 44, 44);
        [backButton setImage:[UIImage imageNamed:@"backbutton"] forState:UIControlStateNormal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:self
                                                                                   action:nil];
        flexSpacer.width = -15;
        item.leftBarButtonItems = [NSArray arrayWithObjects:flexSpacer,backItem, nil];
    }
}

- (void)setJx_title:(NSString *)jx_title {
    self.jx_navigationBar.items.firstObject.title = jx_title;
}

- (void)setJx_titleColor:(UIColor *)jx_titleColor {
    [self.jx_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: jx_titleColor}];
}

- (void)setJx_background:(UIColor *)jx_background {
//    self.jx_navigationBar.barTintColor = jx_background;
    [self.jx_navigationBar jj_setBackgroundColor:jx_background];
}

- (void) setNavigationBarLeftItem:(UIBarButtonItem *)item {
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = -10;
    self.jx_navigationBar.items.firstObject.leftBarButtonItems = [NSArray arrayWithObjects:flexSpacer,item, nil];
}

- (void) setNavigationBarRightItem:(UIBarButtonItem *)item {
    [self setNavigationBarRightItem:item spaceWidth:0];
}

- (void) setNavigationBarRightItem:(UIBarButtonItem *)item spaceWidth:(NSInteger) width {
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = width;
    [self.jx_navigationBar.items.firstObject setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,item, nil]];
}

- (void)setNavigationBarTitleView:(UIView *)view {
    self.jx_navigationBar.items.firstObject.titleView = view;
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)hideTableViewFooter:(UITableView *)tableView {
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 0.1)]];
}

- (void)hideTableViewHeader:(UITableView *)tableView {
    [tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 0.1)]];
}

#pragma mark - 处理输入框被键盘遮挡
- (void)registKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    if (nil == self.tf_check && nil == self.tv_check) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin inself's view's coordinate system. The bottom of the text view's frame shouldalign with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.2f;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect textFrame;//当前UITextField的位置
    if (self.tf_check != nil) {
        textFrame = [self.tf_check convertRect:self.tf_check.frame toView:self.view] ;
    } else {
        textFrame = [self.tv_check convertRect:self.tv_check.frame toView:self.view] ;
    }
    
    float textY = textFrame.origin.y + textFrame.size.height;//得到UITextField下边框距离顶部的高度
    float bottomY = self.view.frame.size.height - textY;//得到下边框到底部的距离
    if(bottomY >=keyboardRect.size.height ){//键盘默认高度,如果大于此高度，则直接返回
        return;
    }
    float moveY = keyboardRect.size.height - bottomY;
    
    // Animate the resize of the text view's frame in sync with the keyboard'sappearance.
    [self moveInputBarWithKeyboardHeight:moveY withDuration:animationDuration];
    
}

//键盘被隐藏的时候调用的方法
- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of thekeyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.2f;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

-(void)moveInputBarWithKeyboardHeight:(float)_CGRectHeight withDuration:(NSTimeInterval)_NSTimeInterval {
    
    CGRect rect = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:_NSTimeInterval];
    
    rect.origin.y = -_CGRectHeight;//view往上移动
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)statusBarLightContent {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)statusBarDefault {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (NSString *)shortVersion {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return version;
}

- (NSInteger)version {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return [version integerValue];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)endingMJRefreshWithTableView:(UITableView *)tableView {
    if ([tableView.mj_header isRefreshing]) {
        [tableView.mj_header endRefreshing];
    }
    if ([tableView.mj_footer isRefreshing]) {
        [tableView.mj_footer endRefreshing];
    }
}

- (void)endingNoMoreWithTableView:(UITableView *)tableview {
    [tableview.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreStatusWithTableView:(UITableView *)tableView {
    [tableView.mj_footer resetNoMoreData];
}

- (void)zyzOringeNavigationBar {
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];
    self.jx_navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self layoutKeyboardToolbar];
    self.tf_check = textField;
    self.tf_check.inputAccessoryView = _keyboardNavigationbar;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tf_check = nil;
}

#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self layoutKeyboardToolbar];
    self.tv_check = textView;
    self.tv_check.inputAccessoryView = _keyboardNavigationbar;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.tv_check = nil;
    return YES;
}

#pragma mark - keyboard toolbar
- (void)layoutKeyboardToolbar {
    if (_keyboardNavigationbar == nil) {
        _keyboardNavigationbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
        _keyboardNavigationbar.barStyle = UIBarStyleBlack;
        UINavigationItem *item = [[UINavigationItem alloc] init];
        _keyboardNavigationbar.items = @[item];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishEditing)];
        _keyboardNavigationbar.items.firstObject.rightBarButtonItem = finish;
//        [_keyboardNavigationbar jj_setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)finishEditing {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removeNotification];
}

@end
