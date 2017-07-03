//
//  NoneView.m
//  自由找
//
//  Created by guojie on 16/7/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "NoneView.h"
#import "Masonry.h"
#import "BaseConstants.h"
#import "BaseService.h"

@interface NoneView ()
{
    BaseService *_baseService;
}
@end

@implementation NoneView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btn_konw_pressed:(id)sender {
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.5;
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
//    animation.values = values;
//    animation.delegate = self;
//    [self.v_content.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        _v_content.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    if (_type==3 && sender!=nil){
        [CommonUtil callWithPhone:@"4000213618"];

    }
}

//- (void)animationDidStart:(CAAnimation *)anim {
//}
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self removeFromSuperview];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    _baseService = [BaseService sharedService];
    _v_content.layer.masksToBounds = YES;
    _v_content.layer.cornerRadius = 12;
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    if (IS_IPHONE_6P) {
        _lb_content.font = [UIFont systemFontOfSize:14];
    }
    if (IS_IPHONE_5_OR_LESS) {
        _layout_btnknowToBottom.constant=30.0;
    }else{
        _layout_btnknowToBottom.constant=15.0;
    }
}

+ (void)showWithType:(NSInteger)type {
    
    NoneView *view = [[NSBundle mainBundle] loadNibNamed:@"NoneView" owner:self options:nil].firstObject;
    view.type = type;
    NSString *text = @"1、这里将是一个“投标技术标”的供给平台；\n2、我们为需要投标的企业或个人编制投标技术标方案；\n3、有经验的工程师也可以在这里承接投标技术标方案的编制工作；\n4、该功能近期开放。";
    NSString *title = @"编制技术标";
    if (type == 1) {
        title = @"编制投标预算";
        text = @"1、这里将是一个“投标预算”的供给平台；\n2、我们为需要投标的企业或个人编制投标预算；\n3、有经验的预算人员也可以在这里承接投标预算的编制工作；\n4、该功能近期开放。";
        view.iv_background.image = [UIImage imageNamed:@"None_top3"];
    }else if (type==3){
        title = @"获取银行保函";
        text = @"1、我们为全国各地投标企业、中标企业和个人需要开具银行投标保函、履约保函；\n2、我们平台上将连接全国各地的担保公司，供需求用户自由选择；\n3、各地的担保公司也可以在这里承接银行保函业务；\n4、该功能线上交易近期开放。";
        view.iv_background.image = [UIImage imageNamed:@"None_top2"];
    }
    view.lb_content.text = text;
    view.lb_title.text = title;
    [view layoutButtonType:type];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(window.mas_top);
        make.left.equalTo(window.mas_left);
        make.bottom.equalTo(window.mas_bottom);
        make.right.equalTo(window.mas_right);
    }];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [view.v_content.layer addAnimation:animation forKey:nil];
}

- (void)layoutButtonType:(NSInteger)type {
    NSObject *obj = [CommonUtil objectForUserDefaultsKey:None_Requested_Jishu];
    if (type == 1) {
        obj = [CommonUtil objectForUserDefaultsKey:None_Requested_Yusuan];
    }else if (type == 3){
        [self.btn_agree setTitle:@"有需求" forState:UIControlStateNormal];
        [self.btn_disagree setTitle:@"无需求" forState:UIControlStateNormal];
        self.btn_phone.hidden=NO;
        obj = [CommonUtil objectForUserDefaultsKey:None_Requested_Bank];
    }
    if (obj == nil) {
        self.btn_know.hidden = YES;
        self.btn_agree.hidden = NO;
        self.btn_disagree.hidden = NO;
    } else {
        self.btn_know.hidden = NO;
        [self.btn_know setTitle:@" 4000213618" forState:UIControlStateNormal];
        [self.btn_know setImage:[UIImage imageNamed:@"noneView_phone"] forState:UIControlStateNormal];
        [self.btn_know setBackgroundColor:[UIColor whiteColor]];
        self.btn_agree.hidden = YES;
        self.btn_disagree.hidden = YES;
    }
    
}

- (IBAction)btn_disagree_pressed:(id)sender {
    [self setClicked];
    if ([CommonUtil isLogin]) {
        //提交
        [self httpCountWithData:0];
    } else {
        [self saveNoneRequestWithType:@"0"];
        
    }
    [self btn_konw_pressed:nil];
}
- (IBAction)btn_agree_pressed:(id)sender {
    [self setClicked];
    if ([CommonUtil isLogin]) {
        //提交
        [self httpCountWithData:1];
        
    } else {
        [self saveNoneRequestWithType:@"1"];
        
    }
    [self btn_konw_pressed:nil];
    
}

- (void)httpCountWithData:(NSInteger)data {
    NSInteger type = _type + 1;
    [_baseService countHomeDataWithInterestType:type isInterest:data result:^(NSInteger code) {
        if (code != 1) {
            [self saveNoneRequestWithType:[NSString stringWithFormat:@"%ld", (long)code]];
        }
    }];
}

- (void)setClicked {
    if (_type == 0) {
        [CommonUtil saveObject:@"1" forUserDefaultsKey:None_Requested_Jishu];
    }else if(_type == 3){
        [CommonUtil saveObject:@"1" forUserDefaultsKey:None_Requested_Bank];
    }else {
        [CommonUtil saveObject:@"1" forUserDefaultsKey:None_Requested_Yusuan];
    }
}

- (void)saveNoneRequestWithType:(NSString *)str {
    NSString *key = JiShuNoneRequest;
    if (_type == 1) {
        key = YusuanNoneRequest;
    }else if (_type==3){
        key=BankNoneRequest;
    }
    [CommonUtil saveObject:str forUserDefaultsKey:key];
}
- (IBAction)btn_phone_pressed:(id)sender {
    [CommonUtil callWithPhone:@"4000213618"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        _v_content.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end
