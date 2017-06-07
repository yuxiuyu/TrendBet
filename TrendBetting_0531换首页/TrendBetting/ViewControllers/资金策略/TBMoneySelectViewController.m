//
//  TBMoneySelectViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/22.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBMoneySelectViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBMoneySelectViewController ()<TBSelectTableViewCellDelegate>

@end

@implementation TBMoneySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"资金策略";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"添加资金策略" style:UIBarButtonItemStylePlain target:self action:@selector(editMoneyBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    _tableview.tableFooterView=[[UIView alloc]init];
    
    

// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}
-(void)editMoneyBtnAction
{
    [self performSegueWithIdentifier:@"showMoneyEditVC" sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Utils sharedInstance].moneyRuleArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSDictionary*dic=[Utils sharedInstance].moneyRuleArray[indexPath.row];
    cell.nameLab.text=dic[@"name"];
    if ([dic[@"isselected"] isEqualToString:@"YES"])
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

    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:[Utils sharedInstance].moneyRuleArray[indexPath.row]];
    [self performSegueWithIdentifier:@"showMoneyEditVC" sender:@{@"selectedDic":dic,@"selectedIndex":[NSString stringWithFormat:@"%ld",indexPath.row]}];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Utils sharedInstance].moneyRuleArray.count>1?YES:NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].moneyRuleArray];
        [tempArr removeObjectAtIndex:indexPath.row];
        BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_MONEY_TXT];
        if (issuccess)
        {
             NSDictionary*dic=[Utils sharedInstance].moneyRuleArray[indexPath.row];
            [[Utils sharedInstance].moneyRuleArray removeObjectAtIndex:indexPath.row];
            if ([dic[@"isselected"] isEqualToString:@"YES"])
            {
                [self backSelected:0];
            }
            [_tableview reloadData];
        }
        else
        {
            [self.view makeToast:@"删除失败" duration:0.5f position:CSToastPositionCenter];
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
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:[Utils sharedInstance].moneyRuleArray[selectedIndex]];
    
    if (![dic[@"isselected"] isEqualToString:@"YES"])
    {
        for (int i=0; i<[Utils sharedInstance].moneyRuleArray.count; i++)
        {
            NSMutableDictionary*tepDic=[[NSMutableDictionary alloc]initWithDictionary:[Utils sharedInstance].moneyRuleArray[i]];
            [tepDic setObject:@"NO" forKey:@"isselected"];
            [[Utils sharedInstance].moneyRuleArray replaceObjectAtIndex:i withObject:tepDic];
        }
        [dic setObject:@"YES" forKey:@"isselected"];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].moneyRuleArray];
            [tempArr replaceObjectAtIndex:selectedIndex withObject:dic];
            BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_MONEY_TXT];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (issuccess)
                {
                    [Utils sharedInstance].moneyRuleArray=tempArr;
                    [Utils sharedInstance].moneySelectedArray=dic[@"moneyRule"];
                    [_tableview reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_MONEY_TXT}];
                }
                else
                {
                    [self.view makeToast:@"修改失败" duration:0.5f position:CSToastPositionCenter];
                }
            });
        });

    }
    

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMoneyEditVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
