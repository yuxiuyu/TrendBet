//
//  TBDeleteFixViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/9/17.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBDeleteFixViewController.h"
#import "TBSwitchTableViewCell.h"
@interface TBDeleteFixViewController ()<switchOnOrOffProtocol>
{
    NSArray*dataArray;
    NSMutableArray*ansArr;
    NSMutableArray*fixansArr;
    NSMutableDictionary*allDic;
}
@end

@implementation TBDeleteFixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"要去掉的规则组";
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
     dataArray=@[@"长跳",@"长连",@"小二路",@"一带不规则",@"不规则带一",@"一带规则",@"规则带一",@"平头规则",@"文字区域的规则",@"和暂停"];
    ansArr=[[NSMutableArray alloc] initWithArray:@[@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES"]];
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSData*data=[defaults objectForKey:SAVE_TenListBlodRule];
    if (!data) {
        data=[defaults objectForKey:SAVE_TenBlodRule];
    }
    tenRuleModel*tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    fixansArr=[NSMutableArray arrayWithArray:@[tenM.gotwoLu,tenM.goLu,tenM.goXiaoLu,tenM.oneNORule,tenM.noRuleOne,tenM.oneRule,tenM.ruleOne,tenM.sameRule,tenM.wordRule,tenM.tRule]];
     NSData*data1=[defaults objectForKey:SAVE_TenDeleteBlodRule];
    if (!data1) {
        ansArr=[NSMutableArray arrayWithArray:fixansArr];
    } else {
        tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data1];
        ansArr=[NSMutableArray arrayWithArray:@[tenM.gotwoLu,tenM.goLu,tenM.goXiaoLu,tenM.oneNORule,tenM.noRuleOne,tenM.oneRule,tenM.ruleOne,tenM.sameRule,tenM.wordRule,tenM.tRule]];
    }

    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ansArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark--switchOnOrOffProtocol
-(void)switchClick:(NSString*)indexStr{
    
    [ansArr replaceObjectAtIndex:[indexStr intValue] withObject:[ansArr[[indexStr intValue]] isEqualToString:@"YES"]?@"NO":@"YES"];
}
-(void)saveBtnAction
{
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];

    tenRuleModel*tenM=[[tenRuleModel alloc] init];
    [tenM initWithDic:@{@"listTen":ansArr}];
    NSData*data=[NSKeyedArchiver archivedDataWithRootObject:tenM];
    [defaults setObject:data forKey:SAVE_TenDeleteBlodRule];
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
