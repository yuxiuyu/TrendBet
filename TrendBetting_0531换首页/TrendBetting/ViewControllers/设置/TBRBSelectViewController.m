//
//  TBRBSelectViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBRBSelectViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBRBSelectViewController ()<TBSelectTableViewCellDelegate>
{
    NSArray*dataArray;
    
//    NSMutableArray*answerArray;
}
@end

@implementation TBRBSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"下注提示选择";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    dataArray=@[@"庄",@"闲"];

    if (_isback)
    {
//        _resultStr=@"";
    }
    else
    {
        _resultStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RBSELECT];
    }
    _tableview.tableFooterView=[[UIView alloc]init];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}
-(void)saveBtnAction
{
    if (_isback)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedGroupRule" object:self userInfo:@{@"indexp":@"1",@"rbSelect":_resultStr}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:_resultStr forKey:SAVE_RBSELECT];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_RBSELECT}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    if ((indexPath.row==0&&[_resultStr containsString:@"R"])||(indexPath.row==1&&[_resultStr containsString:@"B"]))
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
    if ([_resultStr containsString:selectedIndex==0?@"R":@"B"])
    {
        if (_resultStr.length==1)
        {
            return;
        }
        _resultStr=[_resultStr stringByReplacingOccurrencesOfString:selectedIndex==0?@"R":@"B" withString:@""];
    }
    else
    {
        _resultStr=[NSString stringWithFormat:@"%@%@",_resultStr,selectedIndex==0?@"R":@"B"];
    }
    [_tableview reloadData];
    
}


@end
