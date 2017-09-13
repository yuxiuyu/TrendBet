//
//  TBNewRuleRoomDetailViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_RMDetailViewController.h"

@interface TBNewRule_RMDetailViewController ()
{
    
    NSMutableArray*dataArray;
    NSMutableDictionary*dateDic;
    NSMutableArray*houseSumWinCountArray;
    NSMutableDictionary*houseMonthDic;
    NSThread*thread;
    NSMutableArray*totalDayKeyArr;//所有月连日
    NSMutableArray*totalDayValueArr;//所有月连日结果相加
    
    
}
@end

@implementation TBNewRule_RMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_selectedTitle;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"数据结果" style:UIBarButtonItemStylePlain target:self action:@selector(resultBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    UIBarButtonItem*goItem=[[UIBarButtonItem alloc]initWithTitle:@"连月结果" style:UIBarButtonItemStylePlain target:self action:@selector(goMonthsresultBtnAction)];
    self.navigationItem.rightBarButtonItems=@[goItem,item];
    
    totalDayKeyArr=[[NSMutableArray alloc]init];
    totalDayValueArr=[[NSMutableArray alloc]init];
    
    _tableview.tableFooterView=[[UIView alloc]init];
    dateDic=[[NSMutableDictionary alloc]init];
    dataArray=[[NSMutableArray alloc]init];
    
    thread=[[NSThread alloc] initWithTarget:self selector:@selector(getDataRead) object:nil];
    [thread start];
   
//    NSDictionary*monthDic=[Utils sharedInstance].housesDic[_selectedTitle];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [thread cancel];
    thread=nil;
}
-(void)getDataRead
{
         [self showProgress:YES];
        houseMonthDic=[[NSMutableDictionary alloc]init];
        NSArray*monthsArr=[[Utils sharedInstance] getAllFileName:_selectedTitle];////房间里的数据
        for (NSString*monthstr in monthsArr)
        {
            NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",_selectedTitle,monthstr];
            NSArray*daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
            NSMutableDictionary*daysDic=[[NSMutableDictionary alloc]init];
            for (NSString*dayStr in daysArr)
            {
                if ([[NSThread currentThread] isCancelled])
                {
                    [self hidenProgress];
                    [NSThread exit];
                    return;
                }
                NSArray*array=[dayStr componentsSeparatedByString:@"."];
                NSDictionary*tepDic=[[Utils sharedInstance] getNewRuleDayData:monthFileNameStr dayStr:array[0] ];
                [daysDic setObject:tepDic forKey:array[0]];
            }
            [houseMonthDic setObject:daysDic forKey:monthstr];
        }

//    [Utils sharedInstance].housesDic=[[NSDictionary alloc] initWithDictionary:housesDic];
    [self performSelectorOnMainThread:@selector(dealData) withObject:nil waitUntilDone:YES];
}

-(void)dealData{
    NSMutableArray*winArr= [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
    NSMutableArray*failArr=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
    houseSumWinCountArray=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",winArr,failArr]];
    ///////
    NSArray*tepMonthKeyArray=[[Utils sharedInstance] orderArr:[houseMonthDic allKeys]];
    for (int p=0; p<tepMonthKeyArray.count; p++) {

//    [houseMonthDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString*key=tepMonthKeyArray[p];
        NSDictionary*daysDic=houseMonthDic[key];
        [dataArray addObject:key];
       
        NSMutableArray*monthSumWinCountArray=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",winArr,failArr]];
        NSArray*tepDayKeyArray=[[Utils sharedInstance] orderArr:[daysDic allKeys]];
        for (int k=0; k<tepDayKeyArray.count; k++) {
            
        
//        [daysDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSDictionary*dic=daysDic[tepDayKeyArray[k]];
            NSArray*array=dic[@"daycount"];
            float a= [array[5] floatValue]+[[totalDayValueArr lastObject] floatValue];
            for (int i=0; i<monthSumWinCountArray.count; i++)
            {
                if (i<=8) {
                    NSString*str1=[NSString stringWithFormat:@"%d",[monthSumWinCountArray[i] intValue]+[array[i] intValue]];
                    NSString*str2=[NSString stringWithFormat:@"%d",[houseSumWinCountArray[i] intValue]+[array[i] intValue]];
                    if (i==5||i==7||i==8)
                    {
                        str1=[NSString stringWithFormat:@"%0.3f",[monthSumWinCountArray[i] floatValue]+[array[i] floatValue]];
                        str2=[NSString stringWithFormat:@"%0.3f",[houseSumWinCountArray[i] floatValue]+[array[i] floatValue]];
                    }
                   
                    [monthSumWinCountArray replaceObjectAtIndex:i withObject:str1];
                    [houseSumWinCountArray replaceObjectAtIndex:i withObject:str2];
                } else {
                    NSMutableArray*wArr1=[[NSMutableArray alloc]initWithArray:monthSumWinCountArray[i]];
                    NSMutableArray*wArr2=[[NSMutableArray alloc]initWithArray:houseSumWinCountArray[i]];
                    for (int k=0; k<wArr1.count; k++) {
                        
                        NSString*s1=[NSString stringWithFormat:@"%d",[wArr1[k] intValue]+[array[i][k] intValue]];
                        [wArr1 replaceObjectAtIndex:k withObject:s1];
                        NSString*s2=[NSString stringWithFormat:@"%d",[wArr2[k] intValue]+[array[i][k] intValue]];
                        [wArr2 replaceObjectAtIndex:k withObject:s2];
                    }
                    [monthSumWinCountArray replaceObjectAtIndex:i withObject:wArr1];
                    [houseSumWinCountArray replaceObjectAtIndex:i withObject:wArr2];
                }
            }
            NSArray*monKey=[key componentsSeparatedByString:@"-"];
            [totalDayKeyArr addObject:[NSString stringWithFormat:@"%@.%d",monKey[1],k]];
            [totalDayValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];
        }
        [dateDic setObject:monthSumWinCountArray forKey:key];
    };
#warning - yxy0409 - edit
    NSArray*tepArray=[dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                      {
                          NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                          [formatter setDateFormat:@"yyyy-MM"];
                          NSDate*date1=[formatter dateFromString:obj1];
                          NSDate*date2=[formatter dateFromString:obj2];
                          NSComparisonResult result=[date1 compare:date2];
                          return result;
                      }];
    dataArray=[[NSMutableArray alloc]initWithArray:tepArray];
#warning - yxy0409 - edit
    [_tableview reloadData];
    
    
    _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",houseSumWinCountArray[0],houseSumWinCountArray[1],houseSumWinCountArray[2]];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:houseSumWinCountArray[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:houseSumWinCountArray[8]];
    _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",houseSumWinCountArray[4],houseSumWinCountArray[3],[[Utils sharedInstance]removeFloatAllZero:houseSumWinCountArray[5]],reduceStr,backmoneyStr];
     [self hidenProgress];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSArray*array=dateDic[dataArray[indexPath.row]];
    cell.textLabel.font=[UIFont systemFontOfSize:13.0f];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:array[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:array[8]];
    cell.textLabel.text=[NSString stringWithFormat:@"%@     庄:%@  闲:%@  和:%@  赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",dataArray[indexPath.row],array[0],array[1],array[2],array[4],array[3],[[Utils sharedInstance]removeFloatAllZero:array[5]],reduceStr,backmoneyStr];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString*str=dataArray[indexPath.row];
    [self performSegueWithIdentifier:@"showNewRule_MonthVC" sender:@{@"selectedTitle":str,@"roomStr":_selectedTitle,@"winCountArray":dateDic[dataArray[indexPath.row]],@"monthDic":houseMonthDic[str]}];
    
    
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
#pragma mark--resultBtnAction
-(void)resultBtnAction
{
    [self performSegueWithIdentifier:@"show_newHouseResultVC" sender:@{@"winArray":houseSumWinCountArray[9],@"failArray":houseSumWinCountArray[10]}];
}
-(void)goMonthsresultBtnAction{
    [self performSegueWithIdentifier:@"show_goMonthHouseResultVC" sender:@{@"totalDayKeyArr":totalDayKeyArr,@"totalDayValueArr":totalDayValueArr,@"titleStr":@"连月结果"}];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    
}

@end
