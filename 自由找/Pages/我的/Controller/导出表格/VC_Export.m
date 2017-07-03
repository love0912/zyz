//
//  VC_Export.m
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Export.h"
#import <libxlsxwriter/xlsxwriter.h>
#import "ExpCompanyDomain.h"
#import "ExpBidDomain.h"

@interface VC_Export ()<UIDocumentInteractionControllerDelegate>
{
    NSMutableArray *_arr_export_domain;
    NSString *_xlsxPath;
}

@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation VC_Export

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"1"]) {
        self.jx_title = @"导出报名用户";
    } else {
        self.jx_title = @"导出我的报名项目";
    }
    [self zyzOringeNavigationBar];
    _type = [self.parameters objectForKey:kExportType];
    _arr_export = [self.parameters objectForKey:kExportArray];
    _exportTitle = [self.parameters objectForKey:kExportTitle];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(btn_send_pressed)];
    [self setNavigationBarRightItem:item];
    
    _arr_export_domain = [NSMutableArray arrayWithCapacity:_arr_export.count];
    self.navigationItem.title = _exportTitle;
    for (NSDictionary *tmpDic in _arr_export) {
        if ([_type isEqualToString:@"1"]) {
            ExpCompanyDomain *exportDomain = [ExpCompanyDomain domainWithObject:tmpDic];
            [_arr_export_domain addObject:exportDomain];
        } else {
            ExpBidDomain *project = [ExpBidDomain domainWithObject:tmpDic];
            [_arr_export_domain addObject:project];
        }
        
    }
    if ([_type isEqualToString:@"1"]) {
        [self createExcel_1];
    } else {
        [self createExcel_2];
    }
    
    [self showExcel];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)createExcel_1 {
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    _exportTitle = [_exportTitle stringByReplacingOccurrencesOfString:@"/" withString:@"--"];
    NSString *fileName = [NSString stringWithFormat:@"%@报名企业列表.xlsx", _exportTitle];
    _xlsxPath = [documentPath stringByAppendingPathComponent:fileName];
    
    
    lxw_workbook  *workbook  = new_workbook([_xlsxPath UTF8String]); //workbook_new([filename cStringUsingEncoding:NSUTF8StringEncoding]);
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    /* Add a format. */
    lxw_format *format = workbook_add_format(workbook);
    
    /* Set the bold property for the format */
    format_set_bold(format);
    
    /* Change the column width for clarity. */
    worksheet_set_column(worksheet, 0, 0, 30, NULL, 0);
    worksheet_set_column(worksheet, 1, 1, 20, NULL, 0);
    worksheet_set_column(worksheet, 2, 2, 30, NULL, 0);
    worksheet_set_column(worksheet, 3, 3, 20, NULL, 0);
    worksheet_write_string(worksheet, 0, 0, [_exportTitle UTF8String], format);
    worksheet_merge_range(worksheet, 0,0, 0,3, [_exportTitle UTF8String],format);
    
    /* Write some simple text. */
    worksheet_write_string(worksheet, 1, 0, "企业名称", NULL);
    /* Text with formatting. */
    worksheet_write_string(worksheet, 1, 1, "状态", format);
    worksheet_write_string(worksheet, 1, 2, "联系人", format);
    worksheet_write_string(worksheet, 1, 3, "联系电话", format);
    
    for (int i = 0; i < _arr_export_domain.count; i++) {
        ExpCompanyDomain *domain = _arr_export_domain[i];
        worksheet_write_string(worksheet, i+2, 0, [domain.CompanyName UTF8String], NULL);
        /* Text with formatting. */
        worksheet_write_string(worksheet, i+2, 1, [domain.Status UTF8String], format);
        worksheet_write_string(worksheet, i+2, 2, [domain.Contact UTF8String], format);
        worksheet_write_string(worksheet, i+2, 3, [domain.Phone UTF8String], format);
    }
    
    //    /* Writer some numbers. */
    //    worksheet_write_number(worksheet, 2, 0, 123,     NULL);
    //    worksheet_write_number(worksheet, 3, 0, 123.456, NULL);
    
    /* Insert an image. */
    //    worksheet_insert_image(worksheet, 1, 2, "logo.png");
    
    workbook_close(workbook);
}

- (void)createExcel_2 {
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.xlsx", _exportTitle];
    _xlsxPath = [documentPath stringByAppendingPathComponent:fileName];
    
    
    lxw_workbook  *workbook  = new_workbook([_xlsxPath UTF8String]); //workbook_new([filename cStringUsingEncoding:NSUTF8StringEncoding]);
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    /* Add a format. */
    lxw_format *format = workbook_add_format(workbook);
    
    /* Set the bold property for the format */
    format_set_bold(format);
    
    /* Change the column width for clarity. */
    worksheet_set_column(worksheet, 0, 0, 30, NULL, 0);
    worksheet_set_column(worksheet, 1, 1, 20, NULL, 0);
    
    /* Write some simple text. */
    worksheet_write_string(worksheet, 1, 0, "项目名称", NULL);
    /* Text with formatting. */
    worksheet_write_string(worksheet, 1, 1, "日期", format);
    
    for (int i = 0; i < _arr_export_domain.count; i++) {
        ExpBidDomain *domain = _arr_export_domain[i];
        worksheet_write_string(worksheet, i+2, 0, [domain.ProjectName UTF8String], NULL);
        /* Text with formatting. */
        worksheet_write_string(worksheet, i+2, 1, [domain.CreateDate UTF8String], format);
    }
    
    //    /* Writer some numbers. */
    //    worksheet_write_number(worksheet, 2, 0, 123,     NULL);
    //    worksheet_write_number(worksheet, 3, 0, 123.456, NULL);
    
    /* Insert an image. */
    //    worksheet_insert_image(worksheet, 1, 2, "logo.png");
    
    workbook_close(workbook);
}

- (void)showExcel {
    NSURL *xls_url = [NSURL fileURLWithPath:_xlsxPath];
    [_webView loadRequest:[NSURLRequest requestWithURL:xls_url]];
}

- (void)btn_send_pressed {
    if (self.documentController == nil) {
        self.documentController = [UIDocumentInteractionController
                                   interactionControllerWithURL:[NSURL fileURLWithPath:_xlsxPath]];
        self.documentController.delegate = self;
    }
    //    [self.documentController presentPreviewAnimated:YES];
    self.documentController.UTI = @"com.microsoft.excel.xls";
    [self.documentController presentOpenInMenuFromRect:CGRectZero
                                                inView:self.view
                                              animated:YES];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
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

@end
