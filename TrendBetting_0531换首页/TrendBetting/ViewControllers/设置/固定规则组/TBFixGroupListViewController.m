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
    NSMutableDictionary*allDic;
    NSArray*nameArr;
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
    
    allDic=[[NSMutableDictionary alloc] initWithDictionary: [[Utils sharedInstance] readTenData:[NSString stringWithFormat:@"%@/%@",SAVE_RULE_FILENAME,SAVE_TenGroup_TXT]]];
    nameArr=[allDic allKeys];
    _tableview.tableFooterView=[[UIView alloc]init];
     defaults=[NSUserDefaults standardUserDefaults];
     tenM=[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:SAVE_TenListBlodRule]];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    allDic=[[NSMutableDictionary alloc] initWithDictionary: [[Utils sharedInstance] readTenData:[NSString stringWithFormat:@"%@/%@",SAVE_RULE_FILENAME,SAVE_TenGroup_TXT]]];
     nameArr=[allDic allKeys];
    [_tableview reloadData];
}
-(void)addGroupBtnAction
{
    [self performSegueWithIdentifier:@"edit_fixgroupVC" sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    NSDictionary*dic=allDic[nameArr[indexPath.row]];
    cell.nameLab.text=nameArr[indexPath.row];

   
        cell.selectBtn.hidden=NO;
        if ([tenM.nameStr isEqualToString:nameArr[indexPath.row]])
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
    
    [self performSegueWithIdentifier:@"edit_fixgroupVC" sender:@{@"keyStr":nameArr[indexPath.row]}];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nameArr.count>1?YES:NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        [allDic removeObjectForKey:nameArr[indexPath.row]];
        if ([tenM.nameStr isEqualToString:nameArr[indexPath.row]]) {
            [defaults removeObjectForKey:SAVE_TenListBlodRule];
            if ([defaults objectForKey:SAVE_TenDeleteBlodRule]) {
                [defaults removeObjectForKey:SAVE_TenDeleteBlodRule];
            }
            [defaults synchronize];
        }
        nameArr=[allDic allKeys];
        tenM=nil;
       [[Utils sharedInstance] saveTenData:allDic name:SAVE_TenGroup_TXT];
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
    NSDictionary*dic=allDic[nameArr[selectedIndex]];
    tenM=[[tenRuleModel alloc]init];
    [tenM initWithDic:dic];
    tenM.nameStr=nameArr[selectedIndex];
    
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
