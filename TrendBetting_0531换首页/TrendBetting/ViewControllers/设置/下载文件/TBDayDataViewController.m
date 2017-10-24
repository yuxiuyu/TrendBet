//
//  TBDayDataViewController.m
//  TrendBetting
//
//  Created by 王昕 on 2017/10/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBDayDataViewController.h"
//#import "Utils+encryption.h"
//#import "Utils+newRules.h"
//#import "Utils+reencryption.h"
//#import "Utils+xiasanluRule.h"


#define CELL_TAG 1000

@interface dayCell ()

@end

@implementation dayCell



- (IBAction)downBtnAction:(UIButton *)sender {

    UIButton*btn=(UIButton*)sender;
    if ([self.delegate respondsToSelector:@selector(downBtnClick:)])
    {
        [self.delegate downBtnClick:btn.tag-CELL_TAG];
        btn.selected = YES;
    }
}


@end




@interface TBDayDataViewController ()<UITableViewDataSource,UITableViewDelegate,downBtnActionDelegate>
{
    NSMutableArray *dayDataArr;
    NSInteger allday;
    NSArray*daysArr;
}

@end

@implementation TBDayDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文件";
    
    NSString*monthFileNameStr=[NSString stringWithFormat:@"%@号/2017-%@",self.selectedRoom,self.selectedMonth];
    daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
    
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];

    
    dayDataArr = [[NSMutableArray alloc]init];
    NSArray *arr1 = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    
    if ([self.selectedMonth integerValue] == month) {
        allday = day;
    }else if ([self.selectedMonth integerValue] == 2) {
        if (year%4 == 0) {
            allday = 29;
        }else{
            allday = 28;
        }
    }else if([arr1 containsObject:self.selectedMonth]){
        allday = 31;
    }else{
        allday = 30;
    }
    
    for (int i =1; i<allday+1; i++) {
        NSString *dayDataStr = [NSString stringWithFormat:@"%d.txt",i];
        [dayDataArr addObject:dayDataStr];
    }
    
    
    
    // Do any additional setup after loading the view.
}



#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dayDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dayCell"];
    cell.delegate = self;
    cell.downBtn.selected = NO;
    cell.downBtn.tag = indexPath.row + CELL_TAG;
    
    NSString *fileName = dayDataArr[indexPath.row];
    if ([daysArr containsObject:fileName]) {
        cell.downBtn.selected = YES;
    }
    cell.dayLab.text = fileName;
    
    return cell;
}




#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[Utils sharedInstance] initSetTenModel];
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.selectedRoom,@"selectedRoom",monthStrArr[indexPath.row],@"selectedRoom", nil];
//    [self performSegueWithIdentifier:@"showDayVC" sender:dic];
    
}

#pragma mark -- downBtnActionDelegate
-(void)downBtnClick:(NSInteger)tag
{
    // 下载按钮点击
    NSLog(@"下载文件:%@号 2017-%@ %ld.txt",self.selectedRoom,self.selectedMonth,tag+1);
    NSString *timeStr = [NSString stringWithFormat:@"2017-%@-%ld",self.selectedMonth,tag+1];
    
    [[Utils sharedInstance] downLoadServerFile:self.selectedRoom timeStr:timeStr];
    
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
