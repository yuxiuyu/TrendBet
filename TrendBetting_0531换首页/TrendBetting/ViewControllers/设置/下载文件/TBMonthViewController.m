//
//  TBMonthViewController.m
//  TrendBetting
//
//  Created by WX on 2017/10/19.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBMonthViewController.h"

@interface monthCell ()
@property (weak, nonatomic) IBOutlet UILabel *monthLab;

@end

@implementation monthCell



@end



@interface TBMonthViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*allMonthArr;
    NSMutableArray*monthStrArr;
}

@end

@implementation TBMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"月份";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    
    self.navigationController.navigationBarHidden=NO;
    
    allMonthArr = [[NSMutableArray alloc]init];
    monthStrArr = [[NSMutableArray alloc]init];
    for (int i =4; i<month+1; i++) {
        NSString *mothStr = [NSString stringWithFormat:@"%d-%02d",year,i];
        NSString *moth = [NSString stringWithFormat:@"%02d",i];
        [allMonthArr addObject:mothStr];
        [monthStrArr addObject:moth];
    }
    
    // Do any additional setup after loading the view.
}



#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allMonthArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    monthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"monthCell"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.monthLab.text = allMonthArr[indexPath.row];
    
    return cell;
}




#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[Utils sharedInstance] initSetTenModel];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.selectedRoom,@"selectedRoom",monthStrArr[indexPath.row],@"selectedMonth", nil];
    [self performSegueWithIdentifier:@"showDayVC" sender:dic];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showDayVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
