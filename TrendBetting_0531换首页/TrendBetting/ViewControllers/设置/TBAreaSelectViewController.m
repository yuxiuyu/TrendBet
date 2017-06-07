//
//  TBAreaViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/3.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBAreaSelectViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBAreaSelectViewController ()<TBSelectTableViewCellDelegate>
{
    NSArray*dataArray;
    NSMutableArray*answerArray;
}
@end

@implementation TBAreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"区域选择";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    dataArray=@[@"大路",@"大眼仔路",@"小路",@"小强路"];
    answerArray=[[NSMutableArray alloc]init];
   
    NSString*str=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_AREASELECT];
    answerArray=[NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"|"]];
    _tableview.tableFooterView=[[UIView alloc]init];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}
-(void)saveBtnAction
{
    NSString*str=[NSString stringWithFormat:@"%@|%@|%@|%@",answerArray[0],answerArray[1],answerArray[2],answerArray[3]];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:SAVE_AREASELECT];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_AREASELECT}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.nameLab.text=dataArray[indexPath.row];
    if ([answerArray[indexPath.row] intValue]==1)
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
//    [self backSelected:indexPath.row];
    NSString*str=@"show_area_ruleVC";
    [self performSegueWithIdentifier:str sender:@{@"tag":[NSString stringWithFormat:@"%ld",indexPath.row]}];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--TBSelectTableViewCellDelegate
-(void)backSelected:(NSInteger)selectedIndex
{
    if ([answerArray[selectedIndex] intValue]==1)
    {
        if ([self getSelectedAreaCount]==1)
        {
            return;
        }
        [answerArray replaceObjectAtIndex:selectedIndex withObject:@"0"];
    }
    else
    {
        [answerArray replaceObjectAtIndex:selectedIndex withObject:@"1"];
    }
    [_tableview reloadData];

}
-(NSInteger)getSelectedAreaCount
{
    NSInteger mycount=0;
    for (int i=0; i<answerArray.count; i++)
    {
        if ([answerArray[i] intValue]==1)
        {
            mycount++;
        }
    }
    return mycount;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show_area_ruleVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
