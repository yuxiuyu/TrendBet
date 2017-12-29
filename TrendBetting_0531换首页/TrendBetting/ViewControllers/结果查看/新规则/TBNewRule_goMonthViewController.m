//
//  TBNewRule_goMonthViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/6.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_goMonthViewController.h"
//#import "JHChart.h"
//#import "JHLineChart.h"
//#import "WSLineChartView.h"
#import "Charts-Swift.h"
//#define yxy 5
@interface TBNewRule_goMonthViewController ()<UIScrollViewDelegate,ChartViewDelegate>
{
    //    int keyWidth1;
    //    int keyWidth2;
    int dateSqrCount;
    NSMutableArray * totalQKeyArr;
    NSMutableArray * totalQValueArr;
    LineChartView*_chartView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@end

@implementation TBNewRule_goMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titleStr;
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    totalQKeyArr = [[NSMutableArray alloc]init];
    totalQValueArr =[[NSMutableArray alloc]init];
    dateSqrCount = [[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_dateSqrCount] intValue];
    
    if([_titleStr isEqualToString:@"连日结果"]){
        dateSqrCount = [[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_dateDaySqrCount] intValue];
    }
    [self getKeyAndValue];
    [self initChartView];
    _mainScrollview.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-30);
    
    // Do any additional setup after loading the view.
}
-(void)getKeyAndValue{
    float tvalue = 0;
    for (int i=0; i<_totalDayKeyArr.count; i++) {
        tvalue+=[_totalDayValueArr[i] floatValue];
        if (i<=dateSqrCount-1) {
            if (i==dateSqrCount-1) {
                [totalQKeyArr addObject:_totalDayKeyArr[i]];
                [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/dateSqrCount]]];
            }
        } else {
            tvalue -= [_totalDayValueArr[i-dateSqrCount] floatValue];
            [totalQKeyArr addObject:_totalDayKeyArr[i]];
            [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/dateSqrCount]]];
        }
    }
    
}
//-(void)getKeyAndValue1{
//    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy.MM"];
//
//    NSArray * beginArr =[_totalDayKeyArr[0] componentsSeparatedByString:@"."];
//    NSArray * endArr =[[_totalDayKeyArr lastObject] componentsSeparatedByString:@"."];
//    NSDate * beginDate =[formater dateFromString:[NSString stringWithFormat:@"%@.%d",beginArr[0],[beginArr[1] intValue]]];
//    NSString* endMonStr = [NSString stringWithFormat:@"%@.%d",endArr[0],[endArr[1] intValue]];
//    NSDate * endDate =[formater dateFromString:endMonStr];
//    int gcount = 0;
//    int indexp = 0;
////    float tvalue = 0;
//    NSMutableArray *TArr =[[NSMutableArray alloc]init];
//    while ([self compareDate:beginDate endDate:endDate]) {
//        NSInteger monthCount = [[Utils sharedInstance] getAllDayFromDate:beginDate];
//        for (int i=gcount==0?[beginArr[2] intValue]-1:0; i<monthCount; i++) {
//            float value = 0;
//            NSString *keyStr = [NSString stringWithFormat:@"%@.%d",[formater stringFromDate:beginDate],i+1];
//            if (indexp < _totalDayKeyArr.count&&[_totalDayKeyArr[indexp] isEqualToString:keyStr]) {
//
//                value = [_totalDayValueArr[indexp] floatValue];
//                indexp++;
//            }
//            [TArr addObject:[NSString stringWithFormat:@"%0.3f",value]];
//            tvalue+=value;
//            if (gcount==0&&i<dateSqrCount+[beginArr[2] intValue]-1) {
//                if (i==dateSqrCount-1+[beginArr[2] intValue]-1) {
//                    [totalQKeyArr addObject:keyStr];
//                    [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/dateSqrCount]]];
//                }
//            } else {
//                tvalue -= [TArr[0] floatValue];
//                [TArr removeObjectAtIndex:0];
//                [totalQKeyArr addObject:keyStr];
//                [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/dateSqrCount]]];
//            }
//            if (indexp == _totalDayKeyArr.count && [[formater stringFromDate:beginDate] isEqualToString:endMonStr]) {
//                return;
//            }
//        }
//        gcount++;
//        beginDate = [self monthAddOneMonth:beginDate];
//
//    }
//    NSLog(@"yxy");
//
//
//
//}
-(NSDate*)monthAddOneMonth:(NSDate*)currentDate{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy.MM"];
    NSString*date = [formater stringFromDate:currentDate];
    NSArray*arr = [date componentsSeparatedByString:@"."];
    int year = [arr[0] intValue];
    int month = [arr[1] intValue];
    if (month<12) {
        month++;
    } else {
        year++;
    }
    return [formater dateFromString:[NSString stringWithFormat:@"%d.%d",year,month]];
}
-(BOOL)compareDate:(NSDate*)beginDate endDate:(NSDate*)endDate{
    NSComparisonResult result = [beginDate compare:endDate];
    switch (result) {
        case NSOrderedAscending:
            return  YES;
            break;
        case NSOrderedSame:
            return  YES;
            break;
        case NSOrderedDescending:
            return  NO;
            break;
            
        default:
            break;
    }
}

- (void)exportAction {
    // 创建存放XLS文件数据的数组
    NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
    // 第一行内容
    [xlsDataMuArr addObject:@"日期"];
    [xlsDataMuArr addObject:@"结果"];
    // 100行数据
    for (int i = 0; i < _totalDayKeyArr.count; i ++) {
        NSString*dateStr =[NSString stringWithFormat:@"%@日",_totalDayKeyArr[i]];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"." withString:@"月"];
        [xlsDataMuArr addObject:dateStr];
        [xlsDataMuArr addObject:_totalDayValueArr[i]];
    }
    // 把数组拼接成字符串，连接符是 \t（功能同键盘上的tab键）
    NSString *fileContent = [xlsDataMuArr componentsJoinedByString:@"\t"];
    // 字符串转换为可变字符串，方便改变某些字符
    NSMutableString *muStr = [fileContent mutableCopy];
    // 新建一个可变数组，存储每行最后一个\t的下标（以便改为\n）
    NSMutableArray *subMuArr = [NSMutableArray array];
    for (int i = 0; i < muStr.length; i ++) {
        NSRange range = [muStr rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(i, 1)];
        if (range.length == 1) {
            [subMuArr addObject:@(range.location)];
        }
    }
    // 替换末尾\t
    for (NSUInteger i = 0; i < subMuArr.count; i ++) {
#warning  下面的6是列数，根据需求修改
        if ( i > 0 && (i%2 == 0) ) {
            [muStr replaceCharactersInRange:NSMakeRange([[subMuArr objectAtIndex:i-1] intValue], 1) withString:@"\n"];
        }
    }
    // 文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSData *fileData = [muStr dataUsingEncoding:NSUTF16StringEncoding];
    NSString *path = NSHomeDirectory();
    NSArray*nameArr=[_titleStr componentsSeparatedByString:@"-"];
    
    NSString*createPath = [NSString stringWithFormat:@"%@/Documents/%@",path,SAVE_EXPORT_FILENAME];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xls",nameArr[0]]];
    NSLog(@"文件路径：\n%@",filePath);
    
    
    
    BOOL issuccess = [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    if(issuccess){
        [self.view makeToast:@"导出成功" duration:3.0f position:CSToastPositionCenter];
    } else {
        [self.view makeToast:@"导出失败" duration:3.0f position:CSToastPositionCenter];
    }
}


-(void)initChartView{
    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-30)];
    _chartView.backgroundColor=TBLineGaryColor;
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
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
    [_mainScrollview addSubview:_chartView];
}
-(void)setDta{
    
    //横轴数据
    NSMutableArray *xValues1 = [NSMutableArray array];
    for (int i = 0; i < _totalDayKeyArr.count; i ++) {
        [xValues1 addObject:_totalDayKeyArr[i]];
    }
    //设置横轴数据给chartview
    _chartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues1];
    //纵轴数据
    NSMutableArray *yValues1 = [NSMutableArray array];
    for (int i = 0; i <_totalDayValueArr.count; i ++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[_totalDayValueArr[i] floatValue]];
        [yValues1 addObject:entry];
    }
    
    NSArray*titArr = [_titleStr componentsSeparatedByString:@"-"];
    //创建LineChartDataSet对象
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:yValues1 label:titArr.count>1?titArr[1]:_titleStr];
    set1.drawIconsEnabled = NO;
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.orangeColor];
    [set1 setCircleColor:UIColor.orangeColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
//    _chartView.scaleYEnabled = NO;//取消Y轴缩放
    set1.valueFont = [UIFont systemFontOfSize:8.f];
    set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;
    
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    //    if(![_titleStr isEqualToString:@"连日结果"]){
    //横轴数据
    NSMutableArray *xValues2 = [NSMutableArray array];
    for (int i = 0; i < totalQKeyArr.count; i ++) {
        [xValues2 addObject:totalQKeyArr[i]];
    }
    //纵轴数据
    NSMutableArray *yValues2 = [NSMutableArray array];
    for (int i = 0; i <totalQValueArr.count; i ++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i+dateSqrCount-1 y:[totalQValueArr[i] floatValue]];
        [yValues2 addObject:entry];
    }
    //创建LineChartDataSet对象
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithValues:yValues2 label:[NSString stringWithFormat:@"均线%@",titArr.count>1? titArr[1]:_titleStr]];
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
    //    }
    
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    _chartView.data = data;
    //    }
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
