//
//  TBNewRule_MonthResultViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/8/24.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_MonthResultViewController.h"

@interface TBNewRule_MonthResultViewController ()
{
    NSArray*titleArr;
}
@end

@implementation TBNewRule_MonthResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"结果数据";
    titleArr=@[@"           只有大路有趋势",@"大路和其他一路有趋势",@"大路和其他二路有趋势",@"大路和其他三路有趋势",@"大路和其他四路有趋势"];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
   
    
    _tableview.tableFooterView=[[UIView alloc]init];
   
    
    [_tableview reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _winArray.count;
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
    cell.textLabel.text=[NSString stringWithFormat:@"%@ ：赢%@   输%@",titleArr[indexPath.row],_winArray[indexPath.row],_failArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}


@end
