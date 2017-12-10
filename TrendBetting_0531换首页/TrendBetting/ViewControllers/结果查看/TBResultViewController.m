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
#import "SVProgressHUD.h"
@interface TBResultViewController ()
{
    NSArray*dataArray;
    NSInteger mytimeCount;
    BOOL isappera;
}
@end

@implementation TBResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"结果查看";
    isappera=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downErrNotificationAction:) name:@"DownErrNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucNotificationAction:) name:@"InfoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nofileNotificationAction:) name:@"noFileInfoNotification" object:nil];
    //下载文件
   
     if ([Utils sharedInstance].isNetwork) {
    mytimeCount=0;
    [SVProgressHUD showWithStatus:@"文件下载中"];
    NSArray*curDay=[[Utils sharedInstance] getCurrentYearMonthDay];
    for (int i = 1; i<5; i++) {
        NSString *timeStr = [NSString stringWithFormat:@"%d-%02d-%02d",[curDay[0] intValue],[curDay[1] intValue],[curDay[2] intValue]];
        [[Utils sharedInstance] downLoadServerFile:[NSString stringWithFormat:@"%d",i] timeStr:timeStr isanimated:NO];
    }
     } else{
          [self.view makeToast:@"请检查网络设置" duration:3.0f position:CSToastPositionCenter];
     }
    
    
    self.navigationController.navigationBarHidden=NO;
    _tableview.tableFooterView=[[UIView alloc]init];
    dataArray=@[@"读取新规则结果",@"读取今天的结果"];
//    dataArray=@[@"读取的数据结果",@"我保存的数据结果",@"读取设置组结果",@"读取新规则结果"];
//     dataArray=@[@"读取的数据结果",@"我保存的数据结果",@"读取设置组结果"];
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
//    if (indexPath.row==0)
//    {
//        [self performSegueWithIdentifier:@"showRoomDetailVC" sender:nil];
//    }
//    else if(indexPath.row==1)
//    {
//        [self getDataRead];
//         [self performSegueWithIdentifier:@"showresultRoomVC" sender:@{@"selectedTitle":@"我保存的数据"}];
//    }
//    else if(indexPath.row==2)
//    {
//         [self performSegueWithIdentifier:@"show_groupRoomVC" sender:nil];
//        
//    }
//    else{
    [self performSegueWithIdentifier:@"show_newResultRoomVC" sender:@{@"isCurrentDay":[NSString stringWithFormat:@"%ld",indexPath.row]}];
    
//    }
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


// 接收下载失败的通知
- (void)downErrNotificationAction:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *tipStr = [NSString stringWithFormat:@"%@号房间下载超时",[userInfo objectForKey:@"roomStr"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tipStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *reDown = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[Utils sharedInstance] downLoadServerFile:[userInfo objectForKey:@"roomStr"] timeStr:[userInfo objectForKey:@"timeStr"] isanimated:NO];
    }];
    [alert addAction:cancel];
    [alert addAction:reDown];
    [self presentViewController:alert animated:NO completion:nil];
     mytimeCount++;
    [self refreshData];
}

-(void)nofileNotificationAction:(NSNotification *)d
{
    NSDictionary *userInfo = d.userInfo;
    NSString *tipStr = [NSString stringWithFormat:@"%@号-%@ 文件不存在",userInfo[@"roomStr"],userInfo[@"timeStr"]];
    [self.view makeToast:tipStr duration:2.0f position:CSToastPositionBottom];
    mytimeCount++;
    [self refreshData];
    
}

-(void)sucNotificationAction:(NSNotification *)d
{
//    NSDictionary *userInfo = d.userInfo;
    mytimeCount++;
    [self refreshData];

}

-(void)refreshData{
    if (mytimeCount==4&&isappera) {
         [self hidenProgress];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isappera=NO;
}
@end
