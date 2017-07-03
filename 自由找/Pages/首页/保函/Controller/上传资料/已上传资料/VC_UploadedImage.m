//
//  VC_UploadedImage.m
//  zyz
//
//  Created by 郭界 on 16/11/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_UploadedImage.h"
#import "LetterOrderDetailDomain.h"
#import "Cell_UploadedImage.h"
#import "LetterService.h"
#import "JZAlbumViewController.h"

@interface VC_UploadedImage ()<UICollectionViewDelegate, UICollectionViewDataSource, UploadedImageDelegate>
{
    LetterOrderDetailDomain *_letterOrderDetail;
    NSMutableArray *_arr_image;
    LetterService *_letterService;
    JZAlbumViewController *_jzAlbumVC;
}
@end

@implementation VC_UploadedImage

- (void)initData {
    _letterService = [LetterService sharedService];
    _letterOrderDetail = [self.parameters objectForKey:kPageDataDic];
    if (_letterOrderDetail != nil) {
        _arr_image = [NSMutableArray arrayWithArray:_letterOrderDetail.MaterialList];
    }
}

- (void)layoutUI {
    _jzAlbumVC = [[JZAlbumViewController alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"继续上传资料";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arr_image.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_UploadedImage";
    Cell_UploadedImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.imageUrl = [_arr_image objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _jzAlbumVC.currentIndex =indexPath.row;//这个参数表示当前图片的index，默认是0
    _jzAlbumVC.imgArr = _arr_image;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:_jzAlbumVC animated:YES completion:nil];
}

#pragma mark - delete image
- (void)deleteImageWithImageUrl:(NSString *)imageUrl {
    __block VC_UploadedImage *weakSelf = self;
    [JAlertHelper jSheetWithTitle:@"确定删除该图片?" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [weakSelf deleteImageUrl:imageUrl];
        }
    }];
}

- (void)deleteImageUrl:(NSString *)imageUrl {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:_arr_image];
    [tmpArray removeObject:imageUrl];
    [_letterService uploadLetterOrderInfo:_letterOrderDetail imageUrls:tmpArray result:^(NSInteger code) {
        if (code == 1) {
            [_arr_image removeObject:imageUrl];
            _letterOrderDetail.MaterialList = _arr_image;
            [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:2];
            [_collectionView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
            //更新详情页信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_LetterDetail" object:nil];
        }
    }];
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

- (IBAction)btn_toUpload_pressed:(id)sender {
    [PageJumpHelper pushToVCID:@"VC_UploadData" storyboard:Storyboard_Main parameters:@{kPageDataDic:_letterOrderDetail, kPageType:@3} parent:self];
}
@end
