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
    NSString *allday;
}

@end

@implementation TBMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@号房间",self.selectedRoom];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    allMonthArr = [[NSMutableArray alloc]init];
//    [allMonthArr addObjectsFromArray:[self getAllMonthFrom:@"2017-04" endDate:[NSDate date]]];
        
    NSDate*currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    if (hour>11||(hour==11&&minute>=15)) {
       currentDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDate];//后一天
    }
    [allMonthArr addObjectsFromArray:[self getAllMonthFrom:@"2017-04" endDate:currentDate]];

}
-(NSArray*)getAllMonthFrom:(NSString*)fromDate endDate:(NSDate*)endDate{
    NSMutableArray*resultArr=[[NSMutableArray alloc]init];
    NSDateFormatter*formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate*beginDate =[formatter dateFromString:fromDate];
    while ([[Utils sharedInstance] compareDate:beginDate endDate:endDate]) {
        [resultArr addObject:[formatter stringFromDate:beginDate]];
        beginDate = [[Utils sharedInstance] monthAddOneMonth:beginDate];
    }
    return resultArr;
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
    
    cell.monthLab.text = allMonthArr[allMonthArr.count-1-indexPath.row];
    
    return cell;
}




#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[Utils sharedInstance] initSetTenModel];
    NSDictionary *dic = @{@"selectedRoom":self.selectedRoom,
                          @"selectedMonth":allMonthArr[allMonthArr.count-1-indexPath.row],
                          @"currentAllDay":@""};
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
