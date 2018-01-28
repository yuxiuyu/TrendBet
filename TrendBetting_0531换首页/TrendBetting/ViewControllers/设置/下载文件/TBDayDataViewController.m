//
//  TBDayDataViewController.m
//  TrendBetting
//
//  Created by WX on 2017/10/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBDayDataViewController.h"
#import "SVProgressHUD.h"
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
    }
}


@end




@interface TBDayDataViewController ()<UITableViewDataSource,UITableViewDelegate,downBtnActionDelegate>
{
    NSMutableArray *dayDataArr;
    NSInteger allday;
    NSArray*daysArr;
    NSInteger selectIndex;
}

@end

@implementation TBDayDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=[NSString stringWithFormat:@"%@号房间 %@月",self.selectedRoom,self.selectedMonth];

    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"下载全部" style:UIBarButtonItemStylePlain target:self action:@selector(downLoadAll)];
    self.navigationItem.rightBarButtonItem = item;


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nofileNotificationAction:) name:@"noFileInfoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errNotificationAction:) name:@"DownErrNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucNotificationAction:) name:@"InfoNotification" object:nil];
    
    NSString*monthFileNameStr=[NSString stringWithFormat:@"%@号/%@",self.selectedRoom,self.selectedMonth];
    daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据

    dayDataArr = [[NSMutableArray alloc]init];

    NSDateFormatter*formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    if ([_selectedMonth isEqualToString:[formatter stringFromDate:[NSDate date]]])
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
        int hour = (int)[dateComponent hour];
        int minute = (int)[dateComponent minute];
        if (hour>11||(hour==11&&minute>=15)) {
            dateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]]];
        }
         allday = (int)[dateComponent day];
    } else {
        allday =[[Utils sharedInstance]getAllDayFromDate:[formatter dateFromString:_selectedMonth]];

    }
    for (NSInteger i =allday; i>0; i--) {
        NSString *dayDataStr = [NSString stringWithFormat:@"%ld.txt",i];
        [dayDataArr addObject:dayDataStr];
    }
    _mytableView.tableFooterView=[[UIView alloc]init];

    
    
    // Do any additional setup after loading the view.
}


-(void)downLoadAll{
    
    
    if ([Utils sharedInstance].isNetwork&&[Utils sharedInstance].isWifi) {
        [self downAllFile];
    } else if(![Utils sharedInstance].isNetwork) {
         [self.view makeToast:@"请检查网络设置" duration:3.0f position:CSToastPositionCenter];
    } else if([Utils sharedInstance].isNetwork&&![Utils sharedInstance].isWifi){
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"你现在非wifi环境，确认要下载？" preferredStyle:UIAlertControllerStyleAlert];
        //添加取消到UIAlertController中
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cancelAction];
        
        //添加确定到UIAlertController中
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self downAllFile];
        }];
        [alertVC addAction:OKAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    
    }
    
    
    
   
}
-(void)downAllFile{
    for (NSInteger i=0; i<dayDataArr.count; i++) {
        NSString *fileName = dayDataArr[i];
        if (![daysArr containsObject:fileName]) {
            [self downBtnClick:allday - i];
        }
        
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dayDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dayCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.downBtn.selected = NO;
    cell.downBtn.userInteractionEnabled = YES;
    cell.downBtn.tag = allday - indexPath.row + CELL_TAG;
    
    NSString *fileName = dayDataArr[indexPath.row];
    cell.yicunzai.hidden = YES;
    if ([daysArr containsObject:fileName]) {
        cell.yicunzai.hidden = NO;
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
    if ([Utils sharedInstance].isNetwork) {
        NSLog(@"下载文件:%@号 %@ %ld.txt",self.selectedRoom,self.selectedMonth,tag);
        NSString *timeStr = [NSString stringWithFormat:@"%@-%ld",self.selectedMonth,tag];
        selectIndex =allday - tag;
        [[Utils sharedInstance] downLoadServerFile:self.selectedRoom timeStr:timeStr isanimated:YES];
    } else {
        [self.view makeToast:@"请检查网络设置" duration:3.0f position:CSToastPositionCenter];
    }

    
}


#pragma mark -- notification
-(void)nofileNotificationAction:(NSNotification *)d
{
    //    NSDictionary *userInfo = d.userInfo;
    NSString *tipStr = [NSString stringWithFormat:@"文件不存在"];
    [self.view makeToast:tipStr duration:3.0f position:CSToastPositionCenter];
    //    [SVProgressHUD showErrorWithStatus:tipStr];
    
}

-(void)errNotificationAction:(NSNotification *)d
{
    //    NSDictionary *userInfo = d.userInfo;
    NSString *tipStr = [NSString stringWithFormat:@"下载超时"];
    [self.view makeToast:tipStr duration:3.0f position:CSToastPositionCenter];
    //    [SVProgressHUD showErrorWithStatus:tipStr];
    
}

-(void)sucNotificationAction:(NSNotification *)d
{
    //    NSDictionary *userInfo = d.userInfo;
    
    NSString *tipStr = [NSString stringWithFormat:@"下载成功"];
    NSString*monthFileNameStr=[NSString stringWithFormat:@"%@号/%@",self.selectedRoom,self.selectedMonth];
    daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
    [self.view makeToast:tipStr duration:1.0f position:CSToastPositionCenter];
  
    //通知主线程刷新
    [_mytableView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //刷新数据
//        NSIndexPath *index = [NSIndexPath indexPathForRow:selectIndex inSection:0];
//        dayCell *cell = [_mytableView cellForRowAtIndexPath:index];
//        cell.yicunzai.hidden = NO;
//        [_mytableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//    });
   
  
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
