//
//  TBSettingViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBSettingViewController.h"

@interface TBSettingViewController ()
{
    NSArray*dataArray;
}
@end

@implementation TBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    self.navigationController.navigationBarHidden=NO;
    dataArray=@[@"区域选择",@"资金策略",@"下注提示选择",@"正反",@"洗码基数",@"设置组"];
    _tableview.tableFooterView=[[UIView alloc]init];
    
    
    // Do any additional setup after loading the view.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIndentier=@"cellindentier";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndentier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text=dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*str=@"show_setting_areaVC";
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
            str=@"show_setting_backMoneyVC";
            break;
        case 5:
            str=@"show_setting_groupVC";
            break;
            
            
            
        default:
            break;
    }
    [self performSegueWithIdentifier:str sender:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRuleEditVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
