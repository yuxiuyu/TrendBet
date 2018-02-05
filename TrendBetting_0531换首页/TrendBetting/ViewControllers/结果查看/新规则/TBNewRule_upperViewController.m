//
//  TBNewRule_upperViewController.m
//  TrendBetting
//
//  Created by 王昕 on 2018/1/7.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "TBNewRule_upperViewController.h"
#import "Charts-Swift.h"
@interface TBNewRule_upperViewController ()<ChartViewDelegate>
{
    NSMutableArray*ansArr;
    LineChartView*_chartView;
}
@end

@implementation TBNewRule_upperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"统计结果";
    _tableview.tableFooterView=[[UIView alloc]init];
    [self dealData];
    [self initChartView];

    // Do any additional setup after loading the view.
}
-(void)dealData{
    ansArr = [[NSMutableArray alloc]init];
    for (int j=0; j<_dataArray.count; j++) {
        
    
    NSArray*tepArr =_dataArray[j];
    NSArray*backtepArr = _backdataArray[j];
    float totalMonney = 0.0; //总盈亏
    int wincount = 0;
    int failcount = 0;
    float winMoney = 0.0;
    float failMomey = 0.0;
    float backMoney = 0.0;
    for (int i=0; i<tepArr.count-2; i++) {
        totalMonney+=[tepArr[i] floatValue];
        backMoney +=[backtepArr[i] floatValue];
        if ([tepArr[i] floatValue]>=0) {
            wincount++;
            winMoney+=[tepArr[i] floatValue];
        }else {
            failcount++;
            failMomey+=[tepArr[i] floatValue];
        }
    }
        float winSqr =wincount!=0? winMoney/wincount:0;
        float failSqr = failcount!=0?failMomey/failcount:0;
    //    float wfSqr = 0.0;
    NSArray*answerArr=@[[NSString stringWithFormat:@"%0.2f",totalMonney], //总盈亏
                        @(tepArr.count-2), //交易次数
                        @(wincount),  //盈利次数
                        @(failcount),  //亏损次数
                        [NSString stringWithFormat:@"%0.2f",winMoney], //总盈利次数
                        [NSString stringWithFormat:@"%0.2f",failMomey], //总亏损次数
                        [NSString stringWithFormat:@"%0.2f",winSqr], //平均每次盈利
                        [NSString stringWithFormat:@"%0.2f",failSqr], //平均每次亏损
                        [NSString stringWithFormat:@"%0.2f",failcount!=0?wincount/failcount:0.0], //胜率
                        [NSString stringWithFormat:@"%0.2f",failSqr!=0?winSqr/failSqr:0], //盈亏比
                        [NSString stringWithFormat:@"%0.2f",backMoney], //返利
                        tepArr[tepArr.count-2], //最大回测金额
                        [tepArr lastObject] //最大回测金额比
                        ];
    [ansArr addObject:answerArr];
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
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
    NSArray*array=ansArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:13.0f];

    cell.textLabel.text=[NSString stringWithFormat:@"第%ld条均线     总盈亏:%@  交易次数:%@  盈利次数:%@  亏损次数:%@  总盈利金额:%@  总亏损金额:%@  平均每次盈利:%@  平均每次亏损:%@  胜率:%@  盈亏比:%@  返利:%@  最大回撤金额:%@  最大回撤百分比:%@",indexPath.row+1,array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8],array[9],array[10],array[11],array[12]];
    cell.textLabel.numberOfLines=0;
    return cell;
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
    return 55;
}


-(void)initChartView{
    _tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 340)];
    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-30)];
    _chartView.backgroundColor=TBLineGaryColor;
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.xAxis.labelPosition = XAxisLabelPositionBottomInside;// X轴的位置

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
      NSInteger maxInt = 0;
      for (int j=0; j<_dataArray.count; j++) {
          NSArray*tempArr=_dataArray[j];
          if (tempArr.count-2>maxInt) {
              maxInt = tempArr.count;
          }
      }
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    //横轴数据
    NSMutableArray *xValues1 = [NSMutableArray array];
    for (int k = 0; k < maxInt; k++) {
        [xValues1 addObject:[NSString stringWithFormat:@"%d",k+1]];
    }
    //设置横轴数据给chartview
    _chartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues1];
    for (int j=0; j<_dataArray.count; j++) {

        NSArray*tempArr=_dataArray[j];


    //纵轴数据
    NSMutableArray *yValues1 = [NSMutableArray array];
    for (int i = 0; i <tempArr.count-2; i ++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[tempArr[i] floatValue]];
        [yValues1 addObject:entry];
    }


    //创建LineChartDataSet对象
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:yValues1 label:[NSString stringWithFormat:@"%d",j+1]];
    set1.drawIconsEnabled = NO;
    //    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    switch (j) {
        case 0:
            [set1 setColor:UIColor.greenColor];
            [set1 setCircleColor:UIColor.greenColor];
            break;
        case 1:
            [set1 setColor:UIColor.redColor];
            [set1 setCircleColor:UIColor.redColor];
            break;
        case 2:
            [set1 setColor:UIColor.blueColor];
            [set1 setCircleColor:UIColor.blueColor];
            break;
            default:
                break;
        }
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
    //    _chartView.scaleYEnabled = NO;//取消Y轴缩放
    set1.valueFont = [UIFont systemFontOfSize:8.f];
    set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;

    [dataSets addObject:set1];






    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#0.00"];

    [data setValueFormatter:[[ChartDefaultValueFormatter alloc]initWithFormatter:formatter]];

    _chartView.data = data;
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
