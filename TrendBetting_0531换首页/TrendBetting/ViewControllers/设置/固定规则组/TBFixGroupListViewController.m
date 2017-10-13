//
//  TBFixGroupListViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBFixGroupListViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBFixGroupListViewController ()<TBSelectTableViewCellDelegate>
{
    NSMutableArray*allArr;
//    NSArray*nameArr;
    tenRuleModel*tenM;
    NSUserDefaults *defaults;
}
@end

@implementation TBFixGroupListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择组";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"添加组" style:UIBarButtonItemStylePlain target:self action:@selector(addGroupBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
//    allDic=[[NSMutableDictionary alloc] initWithDictionary: [[Utils sharedInstance] readTenData:[NSString stringWithFormat:@"%@/%@",SAVE_RULE_FILENAME,SAVE_TenGroup_TXT]]];
//    nameArr=[allDic allKeys];
    _tableview.tableFooterView=[[UIView alloc]init];
     defaults=[NSUserDefaults standardUserDefaults];
     tenM=[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:SAVE_TenListBlodRule]];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    allArr=[[NSMutableArray alloc] initWithArray: [[Utils sharedInstance] readTenData:[NSString stringWithFormat:@"%@/%@",SAVE_RULE_FILENAME,SAVE_TenGroup_TXT]]];
    [_tableview reloadData];
}
-(void)addGroupBtnAction
{
    [self performSegueWithIdentifier:@"edit_fixgroupVC" sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary*dic=allArr[indexPath.row];
    
    cell.nameLab.text=dic[@"name"];

   
        cell.selectBtn.hidden=NO;
        if ([tenM.nameStr isEqualToString:dic[@"name"]])
        {
            cell.selectBtn.selected=YES;
        }
        else
        {
            cell.selectBtn.selected=NO;
        }
    
   
    cell.delegate=self;
    cell.selectedInp=indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"edit_fixgroupVC" sender:@{@"indexStr":@(indexPath.row)}];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        NSDictionary*dic=allArr[indexPath.row];
        if ([tenM.nameStr isEqualToString:dic[@"name"]]) {
            [defaults removeObjectForKey:SAVE_TenListBlodRule];
            if ([defaults objectForKey:SAVE_TenDeleteBlodRule]) {
                [defaults removeObjectForKey:SAVE_TenDeleteBlodRule];
            }
            [defaults synchronize];
        }
        [allArr removeObjectAtIndex:indexPath.row];
        tenM=nil;
       [[Utils sharedInstance] saveTenData:allArr name:SAVE_TenGroup_TXT];
        [_tableview reloadData];

        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--TBSelectTableViewCellDelegate
-(void)backSelected:(NSInteger)selectedIndex
{
    NSDictionary*dic=allArr[selectedIndex];
    tenM=[[tenRuleModel alloc]init];
    [tenM initWithDic:dic];
    tenM.nameStr=dic[@"name"];
    
    NSData*data=[NSKeyedArchiver archivedDataWithRootObject:tenM];
    [defaults setObject:data forKey:SAVE_TenListBlodRule];
    
    if ([defaults objectForKey:SAVE_TenDeleteBlodRule]) {
        [defaults setObject:data forKey:SAVE_TenDeleteBlodRule];
    }
    [defaults synchronize];
    [_tableview reloadData];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit_fixgroupVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
