//
//  TBBaseViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 16/12/28.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"
#import "SVProgressHUD.h"
@interface TBBaseViewController ()

@end

@implementation TBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:nil];
    // Do any additional setup after loading the view.
}
- (void) showProgress:(BOOL) show
{
    if (show)
    {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
         [SVProgressHUD showWithStatus:@"数据读取中"];
    }
}

- (void) hidenProgress
{
    [SVProgressHUD dismiss];
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
