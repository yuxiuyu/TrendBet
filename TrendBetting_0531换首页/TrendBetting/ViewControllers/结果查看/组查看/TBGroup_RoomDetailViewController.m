//
//  TBGroup_RoomDetailViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBGroup_RoomDetailViewController.h"

@interface TBGroup_RoomDetailViewController ()
{
    NSArray*monthsArr;
}
@end

@implementation TBGroup_RoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_selectedTitle;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
    _tableview.tableFooterView=[[UIView alloc]init];
    
   
    monthsArr=[[Utils sharedInstance] getAllFileName:_selectedTitle];////房间里的数据

    [_tableview reloadData];
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return monthsArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIndentier=@"cellIndentier";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndentier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    cell.textLabel.text=monthsArr[indexPath.row];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"show_groupMonthVC" sender:@{@"selectedTitle":monthsArr[indexPath.row],@"roomStr":_selectedTitle}];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_groupMonthVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}

@end
