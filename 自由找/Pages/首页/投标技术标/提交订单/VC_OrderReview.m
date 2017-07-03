//
//  VC_OrderReview.m
//  自由找
//
//  Created by guojie on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_OrderReview.h"
#import "ProductService.h"
#import "UIImageView+WebCache.h"
#import "BidService.h"
#import "VC_Choice.h"

@interface VC_OrderReview ()
{
    ProductDomain *_product;
    NSDictionary *_regionDic;
    NSInteger _type;
    NSInteger _count;
    ProductService *_productService;
}
@end

@implementation VC_OrderReview

- (void)initData {
    
    _productService = [ProductService sharedService];
    
    _product = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"Product"];
    _regionDic = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"Region"];
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    _count = 1;
}

- (void)layoutUI {
    _lb_message.text = @"留言(选填)";
    if (_type == 1) {
        _lb_email_name.text = @"接收技术标方案资料邮箱(选填)";
    } else {
        _lb_email_name.text = @"接收投标预算资料邮箱(选填)";
    }
    _lb_orderName.text = _product.Name;
    if (IS_IPHONE_5_OR_LESS) {
        _lb_orderName.font = [UIFont systemFontOfSize:22];
        UIFont *font = [UIFont systemFontOfSize:12];
        _lb_money.font = font;
        _lb_moneyTag.font = font;
        _lb_serviceTag.font = font;
        _btn_pei.titleLabel.font = font;
        _lb_message.font = font;
        _lb_contact.font = font;
        _layout_lb_contact_top.constant = 10;
        _layout_lb_money_width.constant = 120;
    }
    _tf_contact.placeholder=@"请输入您的邮箱地址（选填）";
    [_imgv_product sd_setImageWithURL:[NSURL URLWithString:_product.LogoUrl] placeholderImage:[UIImage imageNamed:@"Order_intro"]];
    _lb_money.text = [NSString stringWithFormat:@"%@元/份", _product.DiscountPrice];
    [self setCount:_count];
    
    
    CGFloat paddingTop = 10;
    if (IS_IPHONE_4_OR_LESS) {
        paddingTop = 8;
    } else if (IS_IPHONE_5) {
        paddingTop = 8;
    } else if (IS_IPHONE_6P) {
        paddingTop = 14;
    }
    _layout_tip1_top.constant = _layout_tip2_top.constant = _layout_tip3_top.constant = paddingTop;
    
    NSString *city = _regionDic[kCommonValue];
    NSString *wenxinString = @"";
    if (_type == 1) {
        wenxinString = [NSString stringWithFormat:@"自由找提供的编制投标技术标服务，需要满足您的项目所在省市规章制度的要求，因此需要确认您的项目所在省市。您现在选择的项目所在地是%@，您可以切换区域!", city];
    } else {
        wenxinString = [NSString stringWithFormat:@"自由找提供的编制投标预算服务，需要满足您的项目所在省市规章制度的要求，因此需要确认您的项目所在省市。您现在选择的项目所在地是%@，您可以切换区域!", city];
    }
    _lb_wenxinTip_1.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _lb_wenxinTip_1.linkAttributes = @{(NSString *)kCTFontAttributeName:(id)[UIFont systemFontOfSize:13],(id)kCTForegroundColorAttributeName:[UIColor colorWithHex:@"f21313"]};
    [_lb_wenxinTip_1 setText:wenxinString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        [mutableAttributedString addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor colorWithHex:@"f21313"] range:NSMakeRange(wenxinString.length - 9 - city.length, 3)];
        [mutableAttributedString addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor colorWithHex:@"f21313"] range:NSMakeRange(wenxinString.length - 5, 4)];
        [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]  range:NSMakeRange(wenxinString.length - 5, 4)];
        
        return mutableAttributedString;
    }];
    
    //正则
    NSRange linkRange = NSMakeRange(wenxinString.length - 5, 4);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ziyouzhao.com/"]];
    //设置链接的url
    [_lb_wenxinTip_1 addLinkToURL:url withRange:linkRange];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [self choiceCity];
}

- (void)choiceCity {
    if (_type == 1) {
        [CountUtil countTechExchangeRegion];
    } else {
        [CountUtil countBudgeExchangeRegion];
    }
    
    [[BidService sharedService] getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        NSMutableArray *selectArray = [NSMutableArray array];
        [selectArray addObject:_regionDic[kCommonKey]];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tech_Buy_Change_Area" object:resultDic];
            NSArray *vcs = self.navigationController.viewControllers;
            if (vcs.count > 4) {
                UIViewController *descVC = [vcs objectAtIndex:vcs.count - 4];
                [self.navigationController popToViewController:descVC animated:YES];
            } else {
                [self goBack];
            }
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

- (void)setCount:(NSInteger)count {
    NSString *countString = [NSString stringWithFormat:@"%ld", (long)count];
//    [_btn_count setTitle:countString forState:UIControlStateDisabled];
    _tf_count.text = countString;
    
    CGFloat price = [_product.DiscountPrice floatValue];
    CGFloat totalPrice = price * _count;
    NSString *total = [NSString stringWithFormat:@"%.0f元", totalPrice];
    _lb_total.text = total;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"提交订单";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_OrderSubmit_pressed:(id)sender {
    if (_type == 1) {
        [CountUtil countTechSubmit];
    } else {
        [CountUtil countBudgeSubmit];
    }
    
    
    if (_count > 0) {
        [_productService createOrderWithProductNo:_product.SerialNo region:_regionDic quantity:[NSString stringWithFormat:@"%ld", (long)_count] remark:_tv_content.text contact:_tf_contact.text result:^(NSInteger code, OrderInfoDomain *orderInfo) {
            if (code == 1) {
                [PageJumpHelper pushToVCID:@"VC_OrderSubmit" storyboard:Storyboard_Main parameters:@{kPageDataDic: orderInfo, kPageType:@1, @"ProductType": @(_type)} parent:self];
            }
        }];
    } else {
        [ProgressHUD showInfo:@"购买数量不能为0" withSucc:NO withDismissDelay:2];
    }
    
//    [PageJumpHelper pushToVCID:@"VC_OrderSubmit" storyboard:Storyboard_Main parent:self];
}

- (IBAction)btn_sub_pressed:(id)sender {
    if (_count > 1) {
        _count--;
        [self setCount:_count];
    }
}

- (IBAction)btn_add_pressed:(id)sender {
    _count++;
    [self setCount:_count];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _lb_tv_tips.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([_tv_content.text.trimWhitesSpace isEmptyString]) {
        _lb_tv_tips.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _tf_count) {
        _count = [_tf_count.text integerValue];
        [self setCount:_count];
    }
}

@end
