//
//  TBResultRoomViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBResultViewController.h"
#import "TBFileRoomResult_entry.h"
#import "TBFileRoomResult_roomArr.h"
@interface TBResultViewController ()
{
    NSArray*dataArray;
}
@end

@implementation TBResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"结果查看";
    self.navigationController.navigationBarHidden=NO;
    _tableview.tableFooterView=[[UIView alloc]init];
    dataArray=@[@"读取的数据结果",@"我保存的数据结果",@"读取设置组结果",@"读取新规则结果"];
   
    // Do any additional setup after loading the view.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIndentier=@"cellIndentier";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndentier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text=dataArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        [self performSegueWithIdentifier:@"showRoomDetailVC" sender:nil];
    }
    else if(indexPath.row==1)
    {
        [self getDataRead];
         [self performSegueWithIdentifier:@"showresultRoomVC" sender:@{@"selectedTitle":@"我保存的数据"}];
    }
    else if(indexPath.row==2)
    {
         [self performSegueWithIdentifier:@"show_groupRoomVC" sender:nil];
        
    }
    else{
         [self performSegueWithIdentifier:@"show_newResultRoomVC" sender:nil];
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataRead
{
    NSArray*monthsArr=[[Utils sharedInstance] getAllFileName:SAVE_DATA_FILENAME];
    NSMutableDictionary* housesDic=[[NSMutableDictionary alloc]init];

        NSMutableDictionary*monthsDic=[[NSMutableDictionary alloc] init];
        float winMoney=0;
        for (NSString*monthstr in monthsArr)
        {
            NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",SAVE_DATA_FILENAME,monthstr];
            NSArray*daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
            NSMutableDictionary*daysDic=[[NSMutableDictionary alloc]init];
            for (NSString*dayStr in daysArr)
            {
                NSArray*array=[dayStr componentsSeparatedByString:@"."];
                NSDictionary*tepDic=[[Utils sharedInstance] getDayData:monthFileNameStr dayStr:array[0]];
                NSArray*tepArr=tepDic[@"daycount"];
                winMoney=winMoney+[tepArr[5] floatValue];
                [daysDic setObject:tepDic forKey:array[0]];
            }
            [monthsDic setObject:daysDic forKey:monthstr];
        }
    [housesDic setObject:monthsDic forKey:@"我保存的数据"];
    [Utils sharedInstance].housesDic=[[NSDictionary alloc] initWithDictionary:housesDic];
  
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"showRoomDetailVC"])
//    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
//    }
}


@end
