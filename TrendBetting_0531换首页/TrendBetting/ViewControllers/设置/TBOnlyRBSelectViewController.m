//
//  TBOnlyRBSelectViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/7/17.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBOnlyRBSelectViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBOnlyRBSelectViewController ()<TBSelectTableViewCellDelegate>
{
    NSArray*dataArray;
    NSString*resultStr;
    
}
@end

@implementation TBOnlyRBSelectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    if ( [_isMainVC intValue]==0) {
        self.title=@"把把庄闲选择";
        dataArray=@[@"关闭",@"把把庄",@"把把闲"];
        resultStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect];
    } else {
        self.title=@"主路选择";
        dataArray=@[@"大路",@"大眼仔路",@"小路",@"小强路"];
        resultStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_mainSelect];
    }
    
    _tableview.tableFooterView=[[UIView alloc]init];
    
    
    // Do any additional setup after loading the view.
}
-(void)saveBtnAction
{
    
    if ( [_isMainVC intValue]==0) {
        if (![resultStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect]])
        {
            [[NSUserDefaults standardUserDefaults] setObject:resultStr forKey:SAVE_isOnlyRBSelect];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_isOnlyRBSelect}];
        }
    }else {
        if (![resultStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_mainSelect]])
        {
            [[NSUserDefaults standardUserDefaults] setObject:resultStr forKey:SAVE_mainSelect];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_mainSelect}];
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.nameLab.text=dataArray[indexPath.row];
    cell.selectBtn.selected=NO;
    
    if ([resultStr intValue]==indexPath.row)
    {
        cell.selectBtn.selected=YES;
    }
    cell.delegate=self;
    cell.selectedInp=indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self backSelected:indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--TBSelectTableViewCellDelegate
-(void)backSelected:(NSInteger)selectedIndex
{
    resultStr=[NSString stringWithFormat:@"%ld",selectedIndex];
    [_tableview reloadData];
}

@end
