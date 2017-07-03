//
//  VC_UploadData.m
//  自由找
//
//  Created by 郭界 on 16/10/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_UploadData.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "Cell_LetterImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import <Masonry.h>
#import "LetterService.h"
#import "LetterOrderDetailDomain.h"

@interface VC_UploadData ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    NSString *_tipString;
    
    //1 -- 购买之后直接进入上传资料, 2 -- 订单详情里面进入上传资料(未上传过资料)
    //3 -- 从已上传图片页面进入, 4 -- 从待支付订单支付完成后进入
    NSInteger _type;
    
    //0 -- 标准格式， 1 -- 自定义格式
    NSInteger _letterType;
    
    //订单ID
//    NSString *_orderID;
    
    LetterOrderDetailDomain *_letterDetail;
    
    
    /*  上传图片 */
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _itemHH;
    CGFloat _margin;
    
    NSMutableArray *_arr_imageUrl;
    NSMutableArray *_arr_failImage;
    
    LetterService *_letterService;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation VC_UploadData

- (void)initData {
    
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    _letterDetail = [self.parameters objectForKey:kPageDataDic];
//    _orderID = [self.parameters objectForKey:kPageDataDic];
    if (_letterDetail != nil) {
        _letterType = _letterDetail.BaoHanStyle.integerValue;
    }
    
    if (_letterType == 0) {
        _tipString = @"上传招标文件投标人须知附表和营业执照扫描件照片（如果您购买的多份保函，需上传多个营业执照扫描件照片），不得剪切涂鸦，保证信息的清晰显示，否则将无法完成购买！";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_tipString];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(2,11)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(14,7)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(38,9)];
        _lb_tips.attributedText = attributeString;
    } else {
        _tipString = @"上传投标保函格式、招标文件投标人须知附表和营业执照扫描件照片（如果您购买的多份保函，需上传多个营业执照扫描件照片），不得剪切涂鸦，保证信息的清晰显示，否则将无法完成购买！";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_tipString];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(2,6)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(9,11)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(21,7)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(45,9)];
        _lb_tips.attributedText = attributeString;
    }
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    _letterService = [LetterService sharedService];
}

- (void)layoutUI {
    [self configCollectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"上传资料";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = YES;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell_LetterImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_LetterImage" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"kuangtj"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
            [sheet showInView:self.view];
        } else {
            [self pushImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        if (isVideo) { // perview video / 预览视频
//            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//            vc.model = model;
//            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 9;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.allowTakePicture = YES;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemHH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = NO;
        tzImagePickerVc.allowTakePicture = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    if (_selectedAssets.count > 0) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    _itemHH = _itemWH * 154 / 214;
    layout.itemSize = CGSizeMake(_itemWH, _itemHH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    _collectionView.collectionViewLayout = layout;
//    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_v_collection_back addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_v_collection_back.mas_left);
        make.top.equalTo(_v_collection_back.mas_top);
        make.right.equalTo(_v_collection_back.mas_right);
        make.bottom.equalTo(_v_collection_back.mas_bottom);
    }];
    
    [_collectionView registerClass:[Cell_LetterImage class] forCellWithReuseIdentifier:@"Cell_LetterImage"];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backPressed {
    if (_type == 1) {
        [JAlertHelper jAlertWithTitle:@"您还未上传资料，稍后可在【我的订单】里对该订单上传资料" message:nil cancleButtonTitle:@"现在上传" OtherButtonsArray:@[@"知道了"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self customBack];
            }
        }];
    } else if (_type == 4) {
        [self customBack];
    }else {
        [self goBack];
    }
}

- (void)customBack {
    NSArray *vcs = self.navigationController.viewControllers;
    if (_type == 1) {
        if (vcs.count < 4) {
            return;
        }
        UIViewController *vc = [vcs objectAtIndex:(vcs.count - 4)];
        [self.navigationController popToViewController:vc animated:YES];
    } else if (_type == 2) {
        if (vcs.count < 3) {
            return;
        }
        UIViewController *vc = [vcs objectAtIndex:(vcs.count - 3)];
        [self.navigationController popToViewController:vc animated:YES];
    } else if (_type == 4) {
        NSArray *vcs = self.navigationController.viewControllers;
        UIViewController *vc = [vcs objectAtIndex:(vcs.count - 3)];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
        [self.navigationController popToViewController:vc animated:YES];
    } else {
        if (vcs.count < 4) {
            return;
        }
        UIViewController *vc = [vcs objectAtIndex:(vcs.count - 4)];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_upload_pressed:(id)sender {
    if (_selectedPhotos.count > 0) {
        [CountUtil countBidLetterUpload];
        if (_arr_imageUrl == nil) {
            _arr_imageUrl = [NSMutableArray arrayWithCapacity:_selectedPhotos.count];
            _arr_failImage = [NSMutableArray arrayWithCapacity:0];
        }
        __block VC_UploadData *weakSelf = self;
        [_selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *image = obj;
            [weakSelf uploadImage:image];
        }];
    } else {
        [ProgressHUD showInfo:@"您还未选择照片" withSucc:NO withDismissDelay:2];
    }
}

- (void)uploadImage:(UIImage *)image {
    __block VC_UploadData *weakSelf = self;
    [_letterService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:image type:2 success:^(id responseObject, NSInteger code) {
        if (code != 1) {
            [weakSelf uploadImage:image];
            return ;
        }
        [_arr_imageUrl addObject:responseObject[kResponseDatas]];
        if (_arr_imageUrl.count == _selectedPhotos.count) {
            [self uploadOrder];
        }
    } fail:^{
        [weakSelf uploadImage:image];
        [ProgressHUD showInfo:@"上传失败" withSucc:NO withDismissDelay:2];
    }];
}

- (void)uploadOrder {
    NSMutableArray *arrImg = [NSMutableArray arrayWithArray:_letterDetail.MaterialList];
    [arrImg addObjectsFromArray:_arr_imageUrl];
    [_letterService uploadLetterOrderInfo:_letterDetail imageUrls:arrImg result:^(NSInteger code) {
        if (code == 1) {
            //            [ProgressHUD showInfo:@"上传成功" withSucc:YES withDismissDelay:2];
            if (_type == 1) {
                //购买进入
                [JAlertHelper jAlertWithTitle:@"资料上传成功，在【我的订单】里可以查看该订单" message:nil cancleButtonTitle:@"知道了" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    [self customBack];
                }];
            } else {
                [ProgressHUD showInfo:@"上传成功" withSucc:YES withDismissDelay:2];
                //从订单详情页进入
                [self customBack];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
                //更新详情页信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_LetterDetail" object:nil];
                
            }
        }
    }];
}



@end
