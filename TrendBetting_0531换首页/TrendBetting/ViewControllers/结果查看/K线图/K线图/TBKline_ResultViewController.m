//
//  TBKline_ResultViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 2018/3/23.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "TBKline_ResultViewController.h"

@interface TBKline_ResultViewController ()

@end

@implementation TBKline_ResultViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"结果数据";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
    
    
    _tableview.tableFooterView=[[UIView alloc]init];
    
    
    [_tableview reloadData];
    [self getTotalData];
    
    
}
-(void)getTotalData{
    int failcount = 0;
    float xicount = 0.0;
    for (int i=0; i<_dataArr.count; i++) {
        NSDictionary*dic=_dataArr[i];
        failcount+=[dic[@"failMoney"] intValue];
        xicount+=[dic[@"bcount"] floatValue];
    }
    _totalLab.text =[NSString stringWithFormat:@"    亏损总和:%d     洗码总和:%0.3f",failcount,xicount];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIndentier=@"cellIndentier";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndentier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    NSDictionary*dic=_dataArr[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"开始日期:%@     %@根K线     亏损:%@     洗码:%@",dic[@"date"],dic[@"time"],dic[@"failMoney"],dic[@"bcount"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}

@end
