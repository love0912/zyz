//
//  VC_TextInput.m
//  自由找
//
//  Created by guojie on 16/7/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_TextInput.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIImageView+WebCache.h"
#define CollectionCell_Upload @"CollectionCell_Upload"
#define CollectionCell_WebImage @"CollectionCell_WebImage"
#define CollectionCel_NativeImage @"CollectionCel_NativeImage"
#define kUploadImageUrl @"ImageUrl"
#define KUploadImage @"Image"
#define ImageUrlSeparator @","

#define InputMaxCount 500

@interface VC_TextInput ()
{
    NSMutableArray *_arr_imageUrls;
    UINavigationBar *_keyboardNavigationbar;
    NSDictionary *_uploadDic;
    BaseService *_baseService;
    UIImagePickerController *_imagePickerController;
    
    NSString *_oldText;
    NSString *_oldImgUrls;
}
@end

@implementation VC_TextInput

- (void)initData {
    if (_type == 0) {
        _layout_backView_height.constant = 220;
        _collectionView.hidden = YES;
    } else {
        _baseService = [BaseService sharedService];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _uploadDic = @{
                      kCellEditType: CollectionCell_Upload
                      };
        if (_arr_imageUrls == nil) {
            _arr_imageUrls = [NSMutableArray arrayWithArray:[_imageUrls componentsSeparatedByString:ImageUrlSeparator]];
            
        }
        if (_arr_imageUrls.count < 3) {
            [_arr_imageUrls addObject:_uploadDic];
        }
    }
}

- (void)layoutUI {
    [self layoutRightItem];
    [self layoutKeyboardToolbar];
    if (_inputTitle == nil || [_inputTitle isEmptyString]) {
        _inputTitle = @"请输入";
    }
    if (_tipText != nil && ![_tipText isEmptyString]) {
        _lb_tips.text = _tipText;
    }
    self.jx_title = _inputTitle;
    if (_text != nil && ![_text isEqualToString:@""]) {
        _textView.text = _text;
        _lb_tips.hidden = YES;
    }
    _oldText = _textView.text;
    _oldImgUrls = _imageUrls == nil ? @"" : _imageUrls;
    
    if (_maxCount == 0) {
        _maxCount = InputMaxCount;
    }
    NSString *text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)_textView.text.length, (long)_maxCount];
    _lb_count.text = text;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
    [_imagePickerController.navigationController.navigationBar jj_setBackgroundColor:[UIColor colorWithHex:@"ff7b23"]];
    [_imagePickerController.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

- (void)layoutRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commitPressed)];
    [self setNavigationBarRightItem:item];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)setText:(NSString *)text maxCount:(NSInteger)count {
    self.text = text;
    self.maxCount = count;
    self.type = 0;
}

- (void)setText:(NSString *)text maxCount:(NSInteger)count imageUrls:(NSString *)urls {
    self.type = 1;
    [self setText:text maxCount:count];
    _arr_imageUrls = [NSMutableArray arrayWithArray:[urls componentsSeparatedByString:ImageUrlSeparator]];
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.textView.inputAccessoryView = _keyboardNavigationbar;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _textView) {
        if (_maxCount > 0) {
            NSString *toBeString = textView.text;
            NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; //[[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
            NSString *title = [NSString stringWithFormat:@"最大字数为%ld,您的输入超过字数限制!", (long)_maxCount];
            if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [textView markedTextRange];
                //获取高亮部分
                UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (!position) {
                    if (toBeString.length > _maxCount) {
                        textView.text = [toBeString substringToIndex:_maxCount];
                        [ProgressHUD showInfo:title withSucc:NO withDismissDelay:2];
                    }
                }
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
                else{
                    
                }
            }
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            else{
                if (toBeString.length > _maxCount) {
                    textView.text = [toBeString substringToIndex:_maxCount];
                    [ProgressHUD showInfo:title withSucc:NO withDismissDelay:2];
                }
            }
            [self setCountLabelText];
        }
    }
}

- (void)setCountLabelText {
    NSString *text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)_textView.text.length, (long)_maxCount];
    _lb_count.text = text;
    if (_textView.text.length > 0) {
        _lb_tips.hidden = YES;
    } else {
        _lb_tips.hidden = NO;
    }
}

- (void)backPressed {
    [_textView resignFirstResponder];
    id object = _arr_imageUrls.lastObject;
    if ([object isKindOfClass:[NSDictionary class]]) {
        [_arr_imageUrls removeObject:object];
    }
    _imageUrls = [_arr_imageUrls componentsJoinedByString:ImageUrlSeparator];
    if ([_oldText isEqualToString:_textView.text] && [_oldImgUrls isEqualToString:_imageUrls]) {
        [self goBack];
    } else {
        [JAlertHelper jAlertWithTitle:@"你还未保存输入项" message:@"是否保存" cancleButtonTitle:@"否" OtherButtonsArray:@[@"保存"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                self.inputBlock(_textView.text, _imageUrls);
            }
            [self goBack];
        }];
    }
}

- (void)commitPressed {
    id object = _arr_imageUrls.lastObject;
    if ([object isKindOfClass:[NSDictionary class]]) {
        [_arr_imageUrls removeObject:object];
    }
    _imageUrls = [_arr_imageUrls componentsJoinedByString:ImageUrlSeparator];
    self.inputBlock(_textView.text.trimWhitesSpace, _imageUrls);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textView resignFirstResponder];
}

#pragma mark - collectionview 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arr_imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id object = [_arr_imageUrls objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSDictionary class]]) {
        Cell_Upload *uploadCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Upload" forIndexPath:indexPath];
        return uploadCell;
    }
    NSString *url = object;
    Cell_Image *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Image" forIndexPath:indexPath];
    imageCell.row = indexPath.row;
    imageCell.delegate = self;
    [imageCell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_avater"]];
    return imageCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id object = [_arr_imageUrls objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSDictionary class]]) {
        //选择图片
        [JAlertHelper jSheetWithTitle:@"请选择" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"从相册中选择" OtherButtonsArray:@[@"拍照"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //从相册中选择
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self openSelectImageView];
            } else if (buttonIndex == 2) {
                //拍照
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self openSelectImageView];
            }
        }];
    } else {
        
    }
}

- (void)openSelectImageView {
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

/**
 *  删除图片
 */
- (void)deleteImageWithRow:(NSInteger) row {
    [_arr_imageUrls removeObjectAtIndex:row];
    id object = _arr_imageUrls.lastObject;
    if ([object isKindOfClass:[NSString class]]) {
        [_arr_imageUrls addObject:_uploadDic];
    }
    [_collectionView reloadData];
}

#pragma mark - keyboard toolbar
- (void)layoutKeyboardToolbar {
    if (_keyboardNavigationbar == nil) {
        _keyboardNavigationbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
//                _keyboardNavigationbar.barStyle = UIBarStyleBlack;
        UINavigationItem *item = [[UINavigationItem alloc] init];
        _keyboardNavigationbar.items = @[item];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishEditing)];
        _keyboardNavigationbar.items.firstObject.rightBarButtonItem = finish;
        [_keyboardNavigationbar jj_setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - imagepickerview
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_imagePickerController dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [_baseService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:image type:2 success:^(id responseObject, NSInteger code) {
        if (code != 1) {
            return ;
        }
        [ProgressHUD hideProgressHUD];
        NSString *urlPath = responseObject[kResponseDatas];
//        NSLog(@"%@", responseObject);
        [_arr_imageUrls insertObject:urlPath atIndex:0];
        if (_arr_imageUrls.count > 3) {
            [_arr_imageUrls removeObject:_uploadDic];
        }
        [_collectionView reloadData];
    } fail:^{
        
    }];
}

- (void)finishEditing {
    [self.textView resignFirstResponder];
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

@end
