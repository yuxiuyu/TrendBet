//
//  TBNewRule_MonthViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_MonthViewController.h"
#import "MyCalendarItem.h"
//#import "JHChart.h"
//#import "JHLineChart.h"
#import "Charts-Swift.h"
@interface TBNewRule_MonthViewController ()<ChartViewDelegate>
{
    NSMutableArray*daysNameArr;//有数据的天名
    NSMutableArray*totalYArr;
    NSMutableArray*showTotalYArr;

    NSMutableArray*totalNArr;
//    NSMutableArray*nameArr;
//    NSMutableArray*showNameArr;
//    NSArray*colorArray;
    NSString*ruleStr;
    CGFloat sHeight;
    NSThread*thread;
    BOOL isrefresh;

    LineChartView*_chartView;
   

    
    
}
//@property(nonatomic,strong)NSDictionary*monthDic;
@property(nonatomic,strong)NSMutableDictionary*daysDic;
@property(nonatomic,strong)MyCalendarItem *myCalendarView;

@end

@implementation TBNewRule_MonthViewController


-(MyCalendarItem *)myCalendarView{
    if (_myCalendarView==nil) {
        _myCalendarView = [[MyCalendarItem alloc] init];
        _myCalendarView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVBAR_HEIGHT-20);
        
    }
    return _myCalendarView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//     NSArray*tepMonthKeyArray=[[Utils sharedInstance] orderArr:[_allmonthDic allKeys] isArc:YES];
    self.title=_selectedTitle;
    
     UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"数据结果" style:UIBarButtonItemStylePlain target:self action:@selector(resultBtnAction)];
//    UIBarButtonItem*goItem=[[UIBarButtonItem alloc]initWithTitle:@"连日结果" style:UIBarButtonItemStylePlain target:self action:@selector(goDaysresultBtnAction)];
    self.navigationItem.rightBarButtonItems=@[item];
    
    _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",_winCountArray[0],_winCountArray[1],_winCountArray[2]];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:_winCountArray[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:_winCountArray[8]];
    _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",_winCountArray[4],_winCountArray[3],[[Utils sharedInstance] removeFloatAllZero:_winCountArray[5]],reduceStr,backmoneyStr];
    _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVBAR_HEIGHT-20);
    [_mainScrollView addSubview:self.myCalendarView];
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    

    

    self.myCalendarView.fileDateDic=_monthDic;
    self.myCalendarView.date=[formatter dateFromString:self.title];
    __weak typeof(self)weakself= self;
    self.myCalendarView.calendarBlock=^(NSInteger day, NSInteger month, NSInteger year)
    {
        
        NSString*dayStr=[NSString stringWithFormat:@"%ld",day];
       
        if (weakself.monthDic[dayStr])
        {
            [weakself performSegueWithIdentifier:@"showNewRule_DayVC" sender:@{@"selectedTitle":[NSString stringWithFormat:@"%@-%@",weakself.title,dayStr],@"dayDic":weakself.monthDic[dayStr]}];
        }
        
    };
    NSArray*tepArray=[_monthDic allKeys];
//
    NSArray*xArray=[[Utils sharedInstance] orderArr:tepArray isArc:YES];
    NSMutableArray*vArray=[[NSMutableArray alloc]init];
    NSMutableArray*totalvArray=[[NSMutableArray alloc]init];
    for (int i=0; i<xArray.count; i++)
    {
        NSDictionary*dic=self.myCalendarView.fileDateDic[xArray[i]];
        NSArray*dataarray=dic[@"daycount"];
        [vArray addObject:[[Utils sharedInstance]removeFloatAllZero:dataarray[5]]];
        float a= [dataarray[5] floatValue]+[[totalvArray lastObject] floatValue];
        [totalvArray addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];
    }
    if (xArray.count>1)
    {
//        [self showFirstAndFouthQuardrant:xArray vArray:vArray count:0];
//        [self showFirstAndFouthQuardrant:xArray vArray:totalvArray count:1];
        [self initChartView:xArray yarray1:vArray yarray2:totalvArray];
        _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVBAR_HEIGHT-20+300);
    }
    
    // Do any additional setup after loading the view.
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
//    if ([segue.identifier isEqualToString:@"showNewRule_DayVC"])
//    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
//    }
}
#pragma mark--resultBtnAction
-(void)resultBtnAction
{
    [self performSegueWithIdentifier:@"show_newMonthResultVC" sender:@{@"winArray":_winCountArray[9],@"failArray":_winCountArray[10]
                                                                       }];
}
//-(void)goDaysresultBtnAction{
//    [self performSegueWithIdentifier:@"show_goMonthTimeResultVC" sender:@{@"allmonthDic":_allmonthDic,@"titleStr":@"连日结果",@"selectP":_selectP}];
//    
//}

-(void)initChartView:(NSArray*)xarray yarray1:(NSArray*)yarray1 yarray2:(NSArray*)yarray2 {
    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVBAR_HEIGHT-20, SCREEN_WIDTH, 300)];
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
    [self setData:xarray yarray1:yarray1 yarray2:yarray2];
    [_chartView animateWithXAxisDuration:2.5];
    [_mainScrollView addSubview:_chartView];
}
-(void)setData:(NSArray*)xarray yarray1:(NSArray*)yarray1 yarray2:(NSArray*)yarray2{
    
    NSMutableArray *values1 = [[NSMutableArray alloc] init];
    NSMutableArray *values2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < xarray.count; i++)
    {
        float x = [xarray[i] floatValue];
        float y1 = [yarray1[i] floatValue];
        float y2 = [yarray2[i] floatValue];
        [values1 addObject:[[ChartDataEntry alloc] initWithX:x y:y1]];
        [values2 addObject:[[ChartDataEntry alloc] initWithX:x y:y2]];
    }
    
    //创建LineChartDataSet对象
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:values1 label:@"日结果"];
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
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithValues:values2 label:@"日累加结果"];
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
    //    }
}

@end
