//
//  TBSettingViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBSettingViewController.h"
#import "TBSwitchTableViewCell.h"
@interface TBSettingViewController ()<switchOnOrOffProtocol>
{
    NSArray*dataArray;
    NSUserDefaults*defaults;
    BOOL ispostNotification;
    BOOL iswordpostNotification;
    tenRuleModel*tenM;
}
@end

@implementation TBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    defaults=[NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBarHidden=NO;
//    dataArray=@[@"区域选择",@"资金策略",@"下注提示选择",@"正反",@"洗码基数",@"设置组",@"设置新规则组",@"去掉规则组",@"长跳个数设置",@"长连个数设置",@"小二路个数设置",@"只看大路",@"把把庄闲选择",@"长跳",@"长连",@"小二路",@"一带不规则",@"不规则带一",@"一带规则",@"规则带一",@"平头规则",@"文字区域的规则",@"和暂停"];
     dataArray=@[@"资金策略",@"下注提示选择",@"正反",@"洗码基数",@"设置新规则组",@"去掉规则组",@"长跳个数设置",@"长连个数设置",@"小二路个数设置",@"把把庄闲选择",@"长跳",@"长连",@"小二路",@"一带不规则",@"不规则带一",@"一带规则",@"规则带一",@"平头规则",@"文字区域的规则",@"和暂停"];
    _tableview.tableFooterView=[[UIView alloc]init];
    tenM=[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:SAVE_TenBlodRule]];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (ispostNotification)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_oneNORule}];
    }
    if (iswordpostNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_wordRule}];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString*cellIndentier=@"switchTableViewCell";
    TBSwitchTableViewCell*cell=[TBSwitchTableViewCell loadSwitchTableViewCell:tableView];
    cell.delegate=self;
    if (indexPath.row<=9)
    {
        cell.mySwitch.hidden=YES;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        cell.mySwitch.hidden=NO;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        switch (indexPath.row) {
            case 10:
                cell.mySwitch.on=[tenM.gotwoLu isEqualToString:@"YES"];
                break;
            case 11:
                cell.mySwitch.on=[tenM.goLu isEqualToString:@"YES"];
                break;
            case 12:
                cell.mySwitch.on=[tenM.goXiaoLu isEqualToString:@"YES"];
                break;
            case 13:
                cell.mySwitch.on=[tenM.oneNORule isEqualToString:@"YES"];
                break;
            case 14:
                cell.mySwitch.on=[tenM.noRuleOne isEqualToString:@"YES"];
                break;
            case 15:
                cell.mySwitch.on=[tenM.oneRule isEqualToString:@"YES"];
                break;
            case 16:
                cell.mySwitch.on=[tenM.ruleOne isEqualToString:@"YES"];
                break;
            case 17:
                cell.mySwitch.on=[tenM.sameRule isEqualToString:@"YES"];
                break;
            case 18:
                cell.mySwitch.on=[tenM.wordRule isEqualToString:@"YES"];
                break;
            case 19:
                cell.mySwitch.on=[tenM.tRule isEqualToString:@"YES"];
                break;
                
            default:
                break;
        }
    }
    cell.indexStr=[NSString stringWithFormat:@"%ld",indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLab.text=dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<=9)
    {
        NSString*str=@"show_setting_areaVC";
        NSDictionary*dic=nil;
        switch (indexPath.row)
        {
            case 0:
               str=@"show_setting_moneyVC";
                break;
            case 1:
                str=@"show_setting_rbVC";
                break;
            case 2:
                str=@"show_setting_reverseVC";
                break;
            case 3:
                dic=@{@"tagStr":@"0"};
                str=@"show_setting_backMoneyVC";
                break;
//            case 5:
//                str=@"show_setting_groupVC";
//                break;
            case 4:
                str=@"show_setting_fixgroupVC";
                break;
            case 5:
                str=@"show_setting_deleteFixVC";
                break;
            case 6:
                dic=@{@"tagStr":@"1"};
                str=@"show_setting_backMoneyVC";
                break;
            case 7:
                dic=@{@"tagStr":@"2"};
                str=@"show_setting_backMoneyVC";
                break;
            case 8:
                dic=@{@"tagStr":@"3"};
                str=@"show_setting_backMoneyVC";
                break;
//            case 9:
//                str=@"show_setting_bigRoadVC";
//                break;
            case 9:
                str=@"show_setting_onlyRBSelectVC";
                break;
            default:
                break;
        }
        [self performSegueWithIdentifier:str sender:dic];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--switchOnOrOffProtocol
-(void)switchClick:(NSString*)indexStr{
  
    switch ([indexStr intValue]) {
        case 10:
        {
           tenM.gotwoLu=[tenM.gotwoLu isEqualToString:@"YES"]?@"NO":@"YES";
           ispostNotification=YES;
        }
            break;
        case 11:
        {
            tenM.goLu=[tenM.goLu isEqualToString:@"YES"]?@"NO":@"YES";
            ispostNotification=YES;
        }
            break;
        case 12:
        {
            tenM.goXiaoLu=[tenM.goXiaoLu isEqualToString:@"YES"]?@"NO":@"YES";
            ispostNotification=YES;
        }
            break;
        case 13:
        {
             tenM.oneNORule=[tenM.oneNORule isEqualToString:@"YES"]?@"NO":@"YES";
            ispostNotification=YES;
        }
            break;
        case 14:
        {
             tenM.noRuleOne=[tenM.noRuleOne isEqualToString:@"YES"]?@"NO":@"YES";
              ispostNotification=YES;
        }
            break;
        case 15:
        {
              tenM.oneRule=[tenM.oneRule isEqualToString:@"YES"]?@"NO":@"YES";
              ispostNotification=YES;
        }
            break;
        case 16:
        {
            tenM.ruleOne=[tenM.ruleOne isEqualToString:@"YES"]?@"NO":@"YES";
            ispostNotification=YES;
        }
            break;
        case 17:
        {
             tenM.sameRule=[tenM.sameRule isEqualToString:@"YES"]?@"NO":@"YES";
              ispostNotification=YES;
        }
            break;
        case 18:
        {
             tenM.wordRule=[tenM.wordRule isEqualToString:@"YES"]?@"NO":@"YES";
            iswordpostNotification=YES;
        }
            break;
        case 19:
        {
             tenM.tRule=[tenM.tRule isEqualToString:@"YES"]?@"NO":@"YES";
            iswordpostNotification=YES;
        }
            break;
            
        default:
            break;
    }
    NSData*data=[NSKeyedArchiver archivedDataWithRootObject:tenM];
    [defaults setObject:data forKey:SAVE_TenBlodRule];
    [defaults synchronize];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
        
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
