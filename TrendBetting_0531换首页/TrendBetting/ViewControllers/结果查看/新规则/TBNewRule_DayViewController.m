//
//  TBNewRule_DayViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_DayViewController.h"
#import "TBFileRoomResult_dataArr.h"
//#import "JHLineChart.h"
//#import "WSLineChartView.h"
#import "Charts-Swift.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface TBNewRule_DayViewController ()<UICollectionViewDelegate,ChartViewDelegate>
{
    NSArray*dataArray;
//    JHLineChart *lineChart;
//    JHLineChart *totalLineChart;
    NSMutableArray*answerArray;
    NSMutableArray*totalAnswerArray;
    NSThread*thread;
     LineChartView*_chartView;
    
}
@end

@implementation newRuleDayCollectionViewCell
@end



@implementation TBNewRule_DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    
    
    
  
    if ([_isCurrentDay intValue]==1) {
        
        [self getDataRead];
    } else {
        self.title=_selectedTitle;
        [self updateView];
    }
    
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
    NSArray*curDay=[[Utils sharedInstance] getCurrentYearMonthDay];
    self.title=[NSString stringWithFormat:@"%@-%@-%@",curDay[0],curDay[1],curDay[2]];
    _dayDic=[[Utils sharedInstance] getNewRuleDayData:[NSString stringWithFormat:@"%@/%@-%02d",_selectedTitle,curDay[0],[curDay[1] intValue]] dayStr:curDay[2]];
    [self updateView];

}
-(void)updateView{
    
    dataArray=[[NSMutableArray alloc]init];
    answerArray=[[NSMutableArray alloc]init];
    totalAnswerArray=[[NSMutableArray alloc]init];
    NSArray*tempArr=_dayDic[@"daycount"];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:tempArr[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:tempArr[8]];
    _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",tempArr[0],tempArr[1],tempArr[2]];
    _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",tempArr[4],tempArr[3],[[Utils sharedInstance]removeFloatAllZero:tempArr[5]],reduceStr,backmoneyStr];
    
    
    NSMutableArray*array=[[NSMutableArray alloc]initWithArray:[_dayDic allKeys]];
    [array removeObject:@"daycount"];
    dataArray=[[Utils sharedInstance] orderArr:array isArc:YES];
    for (int i=0; i<dataArray.count; i++)
    {
        NSArray*tparray=_dayDic[dataArray[i]];
        [answerArray addObject:[[Utils sharedInstance]removeFloatAllZero:tparray[5]]];
        float a=[tparray[5] floatValue]+[[totalAnswerArray lastObject] floatValue];
        [totalAnswerArray addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];
        
    }
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot1"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    newRuleDayCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"newRuleDayCollectionIdentifier" forIndexPath:indexPath];
    
    cell.qtyLab.text=[NSString stringWithFormat:@"%@局",dataArray[indexPath.item]];
    cell.winLab.text=answerArray[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showNewRule_TimeVC" sender:@{@"dataArray":_dayDic[dataArray[indexPath.item]],@"selectedTitle":[NSString stringWithFormat:@"第%ld局",indexPath.item+1]}];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView*resView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot1" forIndexPath:indexPath];
    if (dataArray.count>1)
    {
        
//        [self showFirstAndFouthQuardrant:dataArray vArray:answerArray];
//        [resView addSubview:lineChart];
//
//        [self showFirstAndFouthQuardrant1:dataArray vArray:totalAnswerArray];
        [self initChartView];
        [resView addSubview:_chartView];
    }
    return resView;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (dataArray.count>1)
    {
        return CGSizeMake(SCREEN_WIDTH, 300);
    }
    else
    {
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
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
    if ([segue.identifier isEqualToString:@"showNewRule_TimeVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}



-(void)initChartView {
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
    [self setData];
    [_chartView animateWithXAxisDuration:2.5];
//    [_mainScrollView addSubview:_chartView];
}
-(void)setData{
    
    NSMutableArray *values1 = [[NSMutableArray alloc] init];
    NSMutableArray *values2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dataArray.count; i++)
    {
        float x = [dataArray[i] floatValue];
        float y1 = [answerArray[i] floatValue];
        float y2 = [totalAnswerArray[i] floatValue];
        [values1 addObject:[[ChartDataEntry alloc] initWithX:x y:y1]];
        [values2 addObject:[[ChartDataEntry alloc] initWithX:x y:y2]];
    }
    
    //创建LineChartDataSet对象
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:values1 label:@"局结果"];
    set1.drawIconsEnabled = NO;
//    set1.lineDashLengths = @[@5.f, @2.5f];
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
    
    //创建LineChartDataSet对象
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithValues:values2 label:@"局累加结果"];
    set2.drawIconsEnabled = NO;
//    set2.lineDashLengths = @[@5.f, @2.5f];
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#0.0"];
    
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc]initWithFormatter:formatter]];
    
    _chartView.data = data;
    
}

@end
