//
//  TBGroupListViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/19.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBGroupListViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBGroupListViewController ()<TBSelectTableViewCellDelegate>

@end

@implementation TBGroupListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择组";
    [[Utils sharedInstance] getSelectedGroupArr];
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"添加组" style:UIBarButtonItemStylePlain target:self action:@selector(addGroupBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    _tableview.tableFooterView=[[UIView alloc]init];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}
-(void)addGroupBtnAction
{
    [self performSegueWithIdentifier:@"edit_groupVC" sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Utils sharedInstance].groupArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary*dic=[Utils sharedInstance].groupArray[indexPath.row];
    cell.nameLab.text=dic[@"name"];
    if ([dic[@"selected"] isEqualToString:@"YES"])
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
    
    [self performSegueWithIdentifier:@"edit_groupVC" sender:@{@"selectedIndex":[NSString stringWithFormat:@"%ld",indexPath.row]}];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Utils sharedInstance].groupArray.count>1?YES:NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].groupArray];
        [tempArr removeObjectAtIndex:indexPath.row];
        BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_Group_TXT];
        if (issuccess)
        {
            
            
            NSDictionary*dic=[Utils sharedInstance].groupArray[indexPath.row];
            [[Utils sharedInstance].groupArray removeObjectAtIndex:indexPath.row];
            if ([dic[@"selected"] isEqualToString:@"YES"]&&[Utils sharedInstance].groupSelectedArr.count==1)
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
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:[Utils sharedInstance].groupArray[selectedIndex]];
    NSString*str=dic[@"selected"];
    if ([str isEqualToString:@"YES"])
    {
        if ([Utils sharedInstance].groupSelectedArr.count==1)
        {
            return;
        }
        [dic setObject:@"NO" forKey:@"selected"];
    }
    else
    {
        [dic setObject:@"YES" forKey:@"selected"];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].groupArray];
        [tempArr replaceObjectAtIndex:selectedIndex withObject:dic];
        BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_Group_TXT];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (issuccess)
            {
                [Utils sharedInstance].groupArray=tempArr;
                [[Utils sharedInstance]getSelectedGroupArr];
                [_tableview reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_RULE_TXT}];
            }
            else
            {
                [self.view makeToast:@"修改失败" duration:0.5f position:CSToastPositionCenter];
            }
        });
    });
    
    
    
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit_groupVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end



