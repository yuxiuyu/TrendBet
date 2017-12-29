//
//  TBNewRuleRoomDetailViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_RMDetailViewController.h"
//#import "JHLineChart.h"
#import "Charts-Swift.h"
@interface TBNewRule_RMDetailViewController ()<ChartViewDelegate>
{
    
    NSMutableArray*dataArray;
    NSMutableDictionary*dateDic;
    NSMutableArray*houseSumWinCountArray;
    NSMutableDictionary*houseMonthDic;
    NSThread*thread;
    NSMutableArray*totalDayKeyArr;//所有月连日
    NSMutableArray*totalDayValueArr;//所有月连日结果相加
    //    NSMutableArray*dayValueArr;//所有月连日结果相加
    //    JHLineChart *lineChart;
    //    JHLineChart *totalLineChart;
    
    NSMutableArray*oneAnswerArray;
    NSMutableArray*totalOneAnswerArray;
    LineChartView*_chartView;
    
    
}
@end

@implementation TBNewRule_RMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_selectedTitle;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"数据结果" style:UIBarButtonItemStylePlain target:self action:@selector(resultBtnAction)];
    //    self.navigationItem.rightBarButtonItem=item;
    
    UIBarButtonItem*goItem=[[UIBarButtonItem alloc]initWithTitle:@"连月结果" style:UIBarButtonItemStylePlain target:self action:@selector(goMonthsresultBtnAction)];
    self.navigationItem.rightBarButtonItems=@[goItem,item];
    
    totalDayKeyArr=[[NSMutableArray alloc]init];
    totalDayValueArr=[[NSMutableArray alloc]init];
    //    dayValueArr=[[NSMutableArray alloc]init];
    _tableview.tableFooterView=[[UIView alloc]init];
    
    
    dateDic=[[NSMutableDictionary alloc]init];
    dataArray=[[NSMutableArray alloc]init];
    
    oneAnswerArray = [[NSMutableArray alloc]init];
    totalOneAnswerArray = [[NSMutableArray alloc]init];
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
//-(void)viewWillAppear:(BOOL)animated{
//    [super view]
//}
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
    NSArray*tepMonthKeyArray=[[Utils sharedInstance] orderArr:[houseMonthDic allKeys] isArc:YES];
    for (int p=0; p<tepMonthKeyArray.count; p++) {
        
        //    [houseMonthDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString*key=tepMonthKeyArray[p];
        NSDictionary*daysDic=houseMonthDic[key];
        [dataArray addObject:key];
        
        NSMutableArray*monthSumWinCountArray=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",winArr,failArr]];
        NSArray*tepDayKeyArray=[[Utils sharedInstance] orderArr:[daysDic allKeys] isArc:YES];
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
            [totalDayKeyArr addObject:[NSString stringWithFormat:@"%@.%@.%@",monKey[0],monKey[1],tepDayKeyArray[k]]];
            [totalDayValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];
            //            [dayValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",[array[5] floatValue]]]];
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
    float ysum = 0;
    for (int y=0; y<dataArray.count; y++) {
        NSArray*yarray=dateDic[dataArray[y]];
        ysum = ysum + [yarray[5] floatValue];
        [oneAnswerArray addObject:[[Utils sharedInstance]removeFloatAllZero:yarray[5]]];
        [totalOneAnswerArray addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",ysum]]];
    }
    [_tableview reloadData];
    _tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 340)];
    //    _tableview.tableFooterView.backgroundColor=[UIColor redColor];
    //    [self showFirstAndFouthQuardrant:dataArray vArray:oneAnswerArray];
    //    [_tableview.tableFooterView addSubview:lineChart];
    //
    //    [self showFirstAndFouthQuardrant1:dataArray vArray:totalOneAnswerArray];
    //    [_tableview.tableFooterView addSubview:totalLineChart];
    
    [self initChartView];
    
    
//    [self initChartView];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 45;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 600)];
//    view.backgroundColor = [UIColor clearColor];
////    if (dataArray.count>1)
////    {
////        [self showFirstAndFouthQuardrant:dataArray vArray:oneAnswerArray];
////        [resView addSubview:lineChart];
////
////        [self showFirstAndFouthQuardrant1:dataArray vArray:totalOneAnswerArray];
////        [resView addSubview:totalLineChart];
////    }
//    return view;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 600;
//}

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
    [self performSegueWithIdentifier:@"show_goMonthHouseResultVC" sender:@{@"totalDayKeyArr":totalDayKeyArr,@"totalDayValueArr":totalDayValueArr,@"titleStr":[NSString stringWithFormat:@"%@-连月结果",_selectedTitle]}];
    
}
-(void)initChartView{
    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    _chartView.backgroundColor=TBLineGaryColor;
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.xAxis.granularityEnabled = YES;//设置重复的值不显示
    _chartView.xAxis.labelPosition = XAxisLabelPositionBottomInside;// X轴的位置
    
    //
    //
    _chartView.xAxis.gridLineDashLengths = @[@5.0, @10.0];
    
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    [self setDta];
    [_chartView animateWithXAxisDuration:2.5];
    [_tableview.tableFooterView addSubview:_chartView];
}
-(void)setDta{
    
    //横轴数据
    NSMutableArray *xValues1 = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i ++) {
        [xValues1 addObject:dataArray[i]];
    }
    //设置横轴数据给chartview
    _chartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues1];
    //纵轴数据
    NSMutableArray *yValues1 = [NSMutableArray array];
    for (int i = 0; i <oneAnswerArray.count; i ++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[oneAnswerArray[i] floatValue]];
        [yValues1 addObject:entry];
    }
    
    //创建LineChartDataSet对象
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:yValues1 label:@"月结果"];
    set1.drawIconsEnabled = NO;
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.orangeColor];
    [set1 setCircleColor:UIColor.orangeColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:8.f];
    set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;
    
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    
    
    //纵轴数据
    NSMutableArray *yValues2 = [NSMutableArray array];
    for (int i = 0; i <totalOneAnswerArray.count; i ++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[totalOneAnswerArray[i] floatValue]];
        [yValues2 addObject:entry];
    }
    //创建LineChartDataSet对象
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithValues:yValues2 label:@"月累加结果"];
    set2.drawIconsEnabled = NO;
    set2.lineDashLengths = @[@5.f, @2.5f];
    set2.highlightLineDashLengths = @[@5.f, @2.5f];
    [set2 setColor:UIColor.greenColor];
    [set2 setCircleColor:UIColor.greenColor];
    set2.lineWidth = 1.0;
    set2.circleRadius = 3.0;
    set2.drawCircleHoleEnabled = NO;
    set2.valueFont = [UIFont systemFontOfSize:8.f];
    set2.formLineDashLengths = @[@5.f, @2.5f];
    set2.formLineWidth = 1.0;
    set2.formSize = 15.0;
    [dataSets addObject:set2];
    
    
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    _chartView.data = data;
    //    }
}

//第一四象限
//- (void)showFirstAndFouthQuardrant:(NSArray*)xarray vArray:(NSArray*)vArray
//{
//    if (!lineChart)
//    {
//        lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
//        lineChart.xLineDataArr = xarray;
//        lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
//        lineChart.valueArr = @[vArray];
//        lineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
//        lineChart.valueFontSize = 9.0;
//        /* 值折线的折线颜色 默认暗黑色*/
//        lineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
//
//        /* 值点的颜色 默认橘黄色*/
//        lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
//
//        /*        是否展示Y轴分层线条 默认否        */
//        lineChart.showYLevelLine = NO;
//        lineChart.showValueLeadingLine = NO;
//        lineChart.showYLevelLine = YES;
//        lineChart.showYLine = YES;
//
//        /* X和Y轴的颜色 默认暗黑色 */
//        lineChart.xAndYLineColor = [UIColor darkGrayColor];
//        lineChart.backgroundColor = [UIColor whiteColor];
//        /* XY轴的刻度颜色 m */
//        lineChart.xAndYNumberColor = [UIColor darkGrayColor];
//
//        lineChart.contentFill = YES;
//
//        lineChart.pathCurve = YES;
//
//        lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
//        [lineChart showAnimation];
//
//    }
//}
//
////第一四象限
//- (void)showFirstAndFouthQuardrant1:(NSArray*)xarray vArray:(NSArray*)vArray
//{
//    if (!totalLineChart)
//    {
//        totalLineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 300, SCREEN_WIDTH-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
//        totalLineChart.xLineDataArr = xarray;
//        totalLineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
//        totalLineChart.valueArr = @[vArray];
//        totalLineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
//        totalLineChart.valueFontSize = 9.0;
//        /* 值折线的折线颜色 默认暗黑色*/
//        totalLineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
//
//        /* 值点的颜色 默认橘黄色*/
//        totalLineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
//
//        /*        是否展示Y轴分层线条 默认否        */
//        totalLineChart.showYLevelLine = NO;
//        totalLineChart.showValueLeadingLine = NO;
//        totalLineChart.showYLevelLine = YES;
//        totalLineChart.showYLine = YES;
//
//        /* X和Y轴的颜色 默认暗黑色 */
//        totalLineChart.xAndYLineColor = [UIColor darkGrayColor];
//        totalLineChart.backgroundColor = [UIColor whiteColor];
//        /* XY轴的刻度颜色 m */
//        totalLineChart.xAndYNumberColor = [UIColor darkGrayColor];
//
//        totalLineChart.contentFill = YES;
//
//        totalLineChart.pathCurve = YES;
//
//        totalLineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
//        [totalLineChart showAnimation];
//
//    }
//}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController*vc=[segue destinationViewController];
    [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    
}

@end
