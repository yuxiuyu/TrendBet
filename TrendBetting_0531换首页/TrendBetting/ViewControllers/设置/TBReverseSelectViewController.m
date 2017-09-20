//
//  TBReverseSelectViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBReverseSelectViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBReverseSelectViewController ()<TBSelectTableViewCellDelegate>
{
    NSArray*dataArray;
    
}
@end

@implementation TBReverseSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"方向选择";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;

     dataArray=@[@"正向",@"反向"];
    _tableview.tableFooterView=[[UIView alloc]init];
//    if (!_isback)
//    {
//        _resultStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_REVERSESELECT];
//    }
    
    
    // Do any additional setup after loading the view.
}

-(void)saveBtnAction
{
//    if (_isback)
//    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedGroupRule" object:self userInfo:@{@"indexp":@"2",@"reverseSelect":_resultStr}];
       
//    }
//    else
//    {
//       
//        if (![_resultStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_REVERSESELECT]])
//        {
//            [[NSUserDefaults standardUserDefaults] setObject:_resultStr forKey:SAVE_REVERSESELECT];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_REVERSESELECT}];
//        }
//    }
  
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
   
    if (([_resultStr isEqualToString:@"NO"]&&indexPath.row==0)||([_resultStr isEqualToString:@"YES"]&&indexPath.row==1))
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
    _resultStr=[_resultStr isEqualToString:@"NO"]?@"YES":@"NO";
    [_tableview reloadData];
}


@end
