//
//  TBDeleteFixViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/9/17.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "arbitrageListViewController.h"
#import "TBSwitchTableViewCell.h"
#import "TBSelectTableViewCell.h"
@interface arbitrageListViewController ()<TBSelectTableViewCellDelegate>
{
    NSMutableArray*allArr;

    NSUserDefaults *defaults;
}
@end

@implementation arbitrageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"套利规则";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"添加套利规则" style:UIBarButtonItemStylePlain target:self action:@selector(addRuleBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    


    _tableview.tableFooterView=[[UIView alloc]init];
    defaults=[NSUserDefaults standardUserDefaults];
    //    tenM=[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:SAVE_TenListBlodRule]];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    allArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].arbitrageRuleArray];
    [allArr insertObject:@"无" atIndex:0];
    [_tableview reloadData];
}
-(void)addRuleBtnAction
{
    [self performSegueWithIdentifier:@"edit_arbitrageVC" sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selectBtn.hidden=NO;
    if (indexPath.row==0) {
        cell.nameLab.text=allArr[0];
        cell.selectBtn.selected=[Utils sharedInstance].selectArbitrageRuleName.length<=0;

    } else {
        NSDictionary*dic=allArr[indexPath.row];
        cell.nameLab.text=[self replaceToChina:dic[@"name"]];
        cell.selectBtn.selected=[[Utils sharedInstance].selectArbitrageRuleName isEqualToString:dic[@"name"]];
    }

    cell.delegate=self;
    cell.selectedInp=indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0)
    {
        [self performSegueWithIdentifier:@"edit_arbitrageVC" sender:@{@"selectedIndex":@(indexPath.row-1),@"selectedDic":allArr[indexPath.row]}];
    }

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0)
    {
        return YES;
    }
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSMutableArray * tepArr = [NSMutableArray arrayWithArray:[Utils sharedInstance].arbitrageRuleArray];
        [tepArr removeObjectAtIndex:indexPath.row-1];
        BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tepArr filePathStr:SAVE_arbitrageRule];
        if (issuccess)
        {
            [Utils sharedInstance].arbitrageRuleArray = tepArr;
            [[Utils sharedInstance] getSelectarbitrageRuleArray];
            allArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].arbitrageRuleArray];
            [allArr insertObject:@"无" atIndex:0];
            [_tableview reloadData];
            [self.view makeToast:@"删除成功" duration:0.5f position:CSToastPositionCenter];

        }
        else
        {
            [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
        }


        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--TBSelectTableViewCellDelegate
-(void)backSelected:(NSInteger)selectedIndex
{

    [self clearSelect:selectedIndex-1];

    [_tableview reloadData];

}
-(NSString*)replaceToChina:(NSString*)str
{
    str=[str stringByReplacingOccurrencesOfString:@"R" withString:@"庄"];
    str=[str stringByReplacingOccurrencesOfString:@"B" withString:@"闲"];
    return  str;
}
-(void)clearSelect:(NSInteger)indexp{
    NSMutableArray * tepArr = [NSMutableArray arrayWithArray:[Utils sharedInstance].arbitrageRuleArray];
    
    for (int i=0; i<tepArr.count; i++) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:tepArr[i]];
        if (i==indexp) {
            dic[@"select"] = @"YES";
            [Utils sharedInstance].selectArbitrageRuleName = dic[@"name"];
        } else {
            dic[@"select"] = @"NO";
        }
        [tepArr replaceObjectAtIndex:i withObject:dic];
    }
    if (indexp<0) {
        [Utils sharedInstance].selectArbitrageRuleName = @"";
    }
    [Utils sharedInstance].arbitrageRuleArray = tepArr;
    [[Utils sharedInstance] saveData:nil saveArray:tepArr filePathStr:SAVE_arbitrageRule];
    allArr =[[NSMutableArray alloc] initWithArray:tepArr];
    [allArr insertObject:@"无" atIndex:0];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit_arbitrageVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
