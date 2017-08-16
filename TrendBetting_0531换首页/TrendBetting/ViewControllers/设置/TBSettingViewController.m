//
//  TBSettingViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBSettingViewController.h"

@interface TBSettingViewController ()<switchOnOrOffProtocol>
{
    NSArray*dataArray;
    NSUserDefaults*defaults;
}
@end
@implementation switchUItableViewCell
- (IBAction)switchChange:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(switchClick:)]) {
//        [self.delegate switchClick:_indexStr];
//    }
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    switch ([_indexStr intValue]) {
        case 10:
             [defaults setObject:@"YES" forKey:SAVE_oneNORule];
            break;
            
        default:
            break;
    }
}
@end
@implementation TBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    defaults=[NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBarHidden=NO;
    dataArray=@[@"区域选择",@"资金策略",@"下注提示选择",@"正反",@"洗码基数",@"设置组",@"长跳个数设置",@"长连个数设置",@"小二路个数设置",@"只看大路",@"把把庄闲选择",@"一带不规则",@"不规则带一",@"一带规则",@"规则带一",@"平头规则",@"文字区域的规则"];
    _tableview.tableFooterView=[[UIView alloc]init];
    
    
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIndentier=@"switchTableViewCell";
    switchUItableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndentier forIndexPath:indexPath];
    cell.delegate=self;
    if (indexPath.row<=10)
    {
        cell.mySwitch.hidden=YES;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        cell.mySwitch.hidden=NO;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        switch (indexPath.row) {
            case 11:
                cell.mySwitch.on=[[defaults objectForKey:SAVE_oneNORule] isEqualToString:@"YES"];
                break;
            case 12:
                cell.mySwitch.on=[[defaults objectForKey:SAVE_noRuleOne] isEqualToString:@"YES"];
                break;
            case 13:
                cell.mySwitch.on=[[defaults objectForKey:SAVE_oneRule] isEqualToString:@"YES"];
                break;
            case 14:
                cell.mySwitch.on=[[defaults objectForKey:SAVE_ruleOne] isEqualToString:@"YES"];
                break;
            case 15:
                cell.mySwitch.on=[[defaults objectForKey:SAVE_sameRule] isEqualToString:@"YES"];
                break;
            case 16:
                cell.mySwitch.on=[[defaults objectForKey:SAVE_wordRule] isEqualToString:@"YES"];
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
    if (indexPath.row<=10)
    {
        NSString*str=@"show_setting_areaVC";
        NSDictionary*dic=nil;
        switch (indexPath.row)
        {
            case 1:
               str=@"show_setting_moneyVC";
                break;
            case 2:
                str=@"show_setting_rbVC";
                break;
            case 3:
                str=@"show_setting_reverseVC";
                break;
            case 4:
                dic=@{@"tagStr":@"0"};
                str=@"show_setting_backMoneyVC";
                break;
            case 5:
                str=@"show_setting_groupVC";
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
            case 9:
                str=@"show_setting_bigRoadVC";
                break;
            case 10:
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
