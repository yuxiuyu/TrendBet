//
//  TBDeleteFixViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/9/17.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBDeleteFixViewController.h"
#import "TBSwitchTableViewCell.h"
#import "TBSelectTableViewCell.h"
@interface TBDeleteFixViewController ()<switchOnOrOffProtocol,TBSelectTableViewCellDelegate>
{
    NSArray*dataArray;
    NSMutableArray*ansArr;
    NSMutableArray*fixansArr;
    NSMutableDictionary*allDic;
    NSUserDefaults* defaults;
}
@end

@implementation TBDeleteFixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"要去掉的规则组";
     self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    _tableview.tableFooterView=[[UIView alloc]init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSData*data1=[defaults objectForKey:SAVE_TenDeleteBlodRule];
    if (!data1) {
        dataArray=@[@"无"];
        ansArr=[[NSMutableArray alloc] initWithArray:@[@"YES"]];
    }
    else
    {
        [self getAllData];
    }
   
   
    
    

    // Do any additional setup after loading the view.
}
-(void)getAllData{
     NSData*data1=[defaults objectForKey:SAVE_TenDeleteBlodRule];
    dataArray=@[@"无",@"长跳",@"长连",@"小二路",@"一带不规则",@"不规则带一",@"一带规则",@"规则带一",@"平头规则",@"文字区域的规则",@"和暂停"];
    ansArr=[[NSMutableArray alloc] initWithArray:@[@"NO",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES"]];
    NSData*data2=[defaults objectForKey:SAVE_TenListBlodRule];
    if (!data2) {
        data2=[defaults objectForKey:SAVE_TenBlodRule];
    }
    tenRuleModel*tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data2];
    fixansArr=[NSMutableArray arrayWithArray:@[@"NO",tenM.gotwoLu,tenM.goLu,tenM.goXiaoLu,tenM.oneNORule,tenM.noRuleOne,tenM.oneRule,tenM.ruleOne,tenM.sameRule,tenM.wordRule,tenM.tRule]];
    if (!data1) {
        ansArr=[NSMutableArray arrayWithArray:fixansArr];
    } else {
        tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data1];
        ansArr=[NSMutableArray arrayWithArray:@[@"NO",tenM.gotwoLu,tenM.goLu,tenM.goXiaoLu,tenM.oneNORule,tenM.noRuleOne,tenM.oneRule,tenM.ruleOne,tenM.sameRule,tenM.wordRule,tenM.tRule]];
    }
    [_tableview reloadData];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ansArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLab.text=dataArray[indexPath.row];
        
        cell.selectBtn.selected=[ansArr[indexPath.row] isEqualToString:@"YES"];
        cell.selectBtn.hidden=NO;
        cell.delegate=self;
        cell.selectedInp=indexPath.row;
        return cell;
        
    } else {
        
        TBSwitchTableViewCell*cell=[TBSwitchTableViewCell loadSwitchTableViewCell:tableView];
        cell.delegate=self;
        cell.mySwitch.hidden=NO;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.titleLab.text=dataArray[indexPath.row];
        cell.mySwitch.on=[ansArr[indexPath.row] isEqualToString:@"YES"];
        cell.mySwitch.enabled=[fixansArr[indexPath.row] isEqualToString:@"NO"];
        cell.indexStr=[NSString stringWithFormat:@"%ld",indexPath.row];
        return cell;
    }
    
    
}

#pragma mark--switchOnOrOffProtocol
-(void)switchClick:(NSString*)indexStr{
    
    [ansArr replaceObjectAtIndex:[indexStr intValue] withObject:[ansArr[[indexStr intValue]] isEqualToString:@"YES"]?@"NO":@"YES"];
}
#pragma mark--TBSelectTableViewCellDelegate
-(void)backSelected:(NSInteger)selectedIndex
{
    if ([ansArr[selectedIndex] isEqualToString:@"YES"]) {
        [self getAllData];
    } else {
        dataArray=@[@"无"];
        ansArr=[[NSMutableArray alloc] initWithArray:@[@"YES"]];
        [_tableview reloadData];
    }
}

-(void)saveBtnAction
{
    if ([ansArr[0] isEqualToString:@"NO"]) {
        tenRuleModel*tenM=[[tenRuleModel alloc] init];
        [ansArr removeObjectAtIndex:0];
        [tenM initWithDic:@{@"listTen":ansArr}];
        NSData*data=[NSKeyedArchiver archivedDataWithRootObject:tenM];
        [defaults setObject:data forKey:SAVE_TenDeleteBlodRule];
    }
    else {
        [defaults removeObjectForKey:SAVE_TenDeleteBlodRule];
    }
     [defaults synchronize];
     [self.navigationController popViewControllerAnimated:YES];
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
