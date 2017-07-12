//
//  TBBigRoadSelectViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/7/3.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBigRoadSelectViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBBigRoadSelectViewController ()<TBSelectTableViewCellDelegate>
{
    NSArray*dataArray;
    NSString*resultStr;
    
}
@end

@implementation TBBigRoadSelectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"区域选择";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    dataArray=@[@"看所有",@"只看大路"];
    _tableview.tableFooterView=[[UIView alloc]init];
    resultStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isbigRoad];

    // Do any additional setup after loading the view.
}
-(void)saveBtnAction
{
   
        
        if (![resultStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isbigRoad]])
        {
            [[NSUserDefaults standardUserDefaults] setObject:resultStr forKey:SAVE_isbigRoad];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_isbigRoad}];
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
    
    if (([resultStr isEqualToString:@"0"]&&indexPath.row==0)||([resultStr isEqualToString:@"1"]&&indexPath.row==1))
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
    resultStr=[resultStr isEqualToString:@"0"]?@"1":@"0";
    [_tableview reloadData];
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
