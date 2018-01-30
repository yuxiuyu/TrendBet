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
    //    int dateSqrCount;
    //    NSMutableArray * totalQKeyArr;
    //    NSMutableArray * totalQValueArr;
    LineChartView*_chartView;
    NSMutableArray*lineArr;
    NSArray*upperDataArray;
    int currentP;
    NSArray*allMonthNameArr;

    NSMutableDictionary*goAllMonthDic;
    NSInteger addCount;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@end

@implementation TBNewRule_goMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titleStr;

    goAllMonthDic = [[NSMutableDictionary alloc]init];
    currentP = [_selectP intValue];
    addCount = 0;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportAction)];
    UIBarButtonItem*dataitem=[[UIBarButtonItem alloc]initWithTitle:@"统计结果" style:UIBarButtonItemStylePlain target:self action:@selector(resultDataACtion)];
    self.navigationItem.rightBarButtonItems=@[item,dataitem];
    
    lineArr = [[NSMutableArray alloc]init];
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    
    
    if([_titleStr containsString:@"连日结果"]){

        allMonthNameArr=[[Utils sharedInstance] orderArr:[_allmonthDic allKeys] isArc:YES];
        [self getMonthKeyAndValue:currentP];

        UIButton*leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2.0-40,40 , 40)];
        [leftBtn setTitle:@"上个月" forState:UIControlStateNormal];
        leftBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [leftBtn addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        float a = SCREEN_WIDTH;
        UIButton*rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(a-50, SCREEN_HEIGHT/2.0-40,40 , 40)];
        [rightBtn setTitle:@"下个月" forState:UIControlStateNormal];
        rightBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [_mainScrollview addSubview:leftBtn];
        [_mainScrollview addSubview:rightBtn];
        _mainScrollview.contentSize=CGSizeMake(SCREEN_WIDTH-100, SCREEN_HEIGHT-30);
    } else {
        int dateSqrCount = [[defs objectForKey:SAVE_dateSqrCount] intValue];
        [lineArr addObject: [self getKeyAndValue:dateSqrCount  color:UIColor.greenColor p:0]];
        NSString * line1 = [defs objectForKey:SAVE_dateSqrCount_1];
        NSString * line2 = [defs objectForKey:SAVE_dateSqrCount_2];
        if (line1.length>0) {
            [lineArr addObject: [self getKeyAndValue:[line1 intValue]  color:UIColor.redColor p:0]]; ;
        }
        if (line2.length>0) {
            [lineArr addObject: [self getKeyAndValue:[line2 intValue]  color:UIColor.blueColor p:0]]; ;
        }
        upperDataArray = [self getComputerResult:_totalDayValueArr tsqrArr:lineArr p:0];
        [self initChartView];
        _mainScrollview.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-30);
    }
    

}
-(void)leftBtn{
    if (currentP>0) {
        currentP--;
        [self getMonthKeyAndValue:currentP];
    } else {
        [self.view makeToast:@"没有更多数据了" duration:3.0f position:CSToastPositionCenter];
    }
}
-(void)rightBtn{
    if (currentP<allMonthNameArr.count-1) {
        currentP++;
        [self getMonthKeyAndValue:currentP];
    } else {
        [self.view makeToast:@"没有更多数据了" duration:3.0f position:CSToastPositionCenter];
    }
}
/*
 获取月的结果
 */
-(void)getMonthKeyAndValue:(int)p{
    NSString * keyStr = allMonthNameArr[p];
    self.title = [NSString stringWithFormat:@"%@连日结果",keyStr];


    if (goAllMonthDic[keyStr]) {
        NSArray*tepArr = goAllMonthDic[keyStr];
        _totalDayKeyArr = tepArr[0];
        _totalDayValueArr = tepArr[1];
    } else {
        NSDictionary*monthdic=_allmonthDic[keyStr];
        NSMutableArray*totalTimeKeyArr;//所有日连此
        NSMutableArray*totalTimeValueArr;//所有日连次结果相加
        totalTimeKeyArr=[[NSMutableArray alloc]init];
        totalTimeValueArr=[[NSMutableArray alloc]init];
        if (p>0) {
            NSString * str = allMonthNameArr[p-1];
            NSArray*tepArr = goAllMonthDic[str];
            [totalTimeKeyArr addObject: [tepArr[0] lastObject]];
            [totalTimeValueArr addObject: [tepArr[1] lastObject]];
        }
        NSArray*tepArray=[monthdic allKeys];

        NSArray*xArray=[[Utils sharedInstance] orderArr:tepArray isArc:YES];
        NSMutableArray*vArray=[[NSMutableArray alloc]init];
        NSMutableArray*totalvArray=[[NSMutableArray alloc]init];
        for (int i=0; i<xArray.count; i++)
        {
            NSDictionary*dic=monthdic[xArray[i]];
            NSArray*dataarray=dic[@"daycount"];
            [vArray addObject:[[Utils sharedInstance]removeFloatAllZero:dataarray[5]]];
            float a= [dataarray[5] floatValue]+[[totalvArray lastObject] floatValue];
            [totalvArray addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];

            //月里的日长连次
            NSMutableArray*xkeyArray=[[NSMutableArray alloc]initWithArray:[dic allKeys]];
            [xkeyArray removeObject:@"daycount"];
            NSArray*xtimeArr=[[Utils sharedInstance] orderArr:xkeyArray isArc:YES];
            for (int k=0; k<xtimeArr.count; k++)
            {
                NSArray*tparray=dic[xtimeArr[k]];

                float a=[tparray[5] floatValue]+[[totalTimeValueArr lastObject] floatValue];
                [totalTimeKeyArr addObject:[NSString stringWithFormat:@"%@.%d",xArray[i],k+1]];
                [totalTimeValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];
            }//
        }
        _totalDayKeyArr = totalTimeKeyArr;
        _totalDayValueArr = totalTimeValueArr;
        [goAllMonthDic setObject:@[_totalDayKeyArr,_totalDayValueArr] forKey:keyStr];
    }
    
    ////
    lineArr = [[NSMutableArray alloc]init];
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    //1
    int dateSqrCount = [[defs objectForKey:SAVE_dateDaySqrCount] intValue];
    [lineArr addObject: [self getKeyAndValue:dateSqrCount color:UIColor.greenColor p:p]];
    //2
    NSString * line1 = [defs objectForKey:SAVE_dateDaySqrCount_1];
    if (line1.length>0) {
        [lineArr addObject: [self getKeyAndValue:[line1 intValue] color:UIColor.redColor p:p]]; ;
    }
    //3
    NSString * line2 = [defs objectForKey:SAVE_dateDaySqrCount_2];
    if (line2.length>0) {
        [lineArr addObject: [self getKeyAndValue:[line2 intValue]  color:UIColor.blueColor p:p]]; ;
    }
    upperDataArray = [self getComputerResult:_totalDayValueArr tsqrArr:lineArr p:p]; //在曲线上的点
    [self initChartView];
}
-(NSArray*)getKeyAndValue:(int)dateSqrCount color:(UIColor*)color p:(int)p{

    NSMutableArray * keyArr ;
    NSMutableArray * valueArr ;
    NSMutableArray * totalQKeyArr = [[NSMutableArray alloc]init];
    NSMutableArray * totalQValueArr =[[NSMutableArray alloc]init];
    addCount = 0;
    if (p>0) {
        NSString * str = allMonthNameArr[p-1];
        NSArray*tepArr = goAllMonthDic[str];
        NSArray*lastKeyArr = tepArr[0];
        NSArray*lastValueArr = tepArr[1];
        NSInteger beginp = lastKeyArr.count-dateSqrCount;
        NSInteger splength = dateSqrCount-1;
        if (beginp<0) {
            beginp = 0;
            splength = lastKeyArr.count-1;
        }
        NSArray*needKeyArr = [lastKeyArr subarrayWithRange:NSMakeRange(beginp,splength)];
        NSArray*needValueArr = [lastValueArr subarrayWithRange:NSMakeRange(beginp, splength)];
        keyArr = [NSMutableArray arrayWithArray:needKeyArr];
        valueArr = [NSMutableArray arrayWithArray:needValueArr];
        addCount = keyArr.count+1;
        [keyArr addObjectsFromArray:_totalDayKeyArr];
        [valueArr addObjectsFromArray:_totalDayValueArr];
    } else {
        keyArr = [NSMutableArray arrayWithArray:_totalDayKeyArr];
        valueArr = [NSMutableArray arrayWithArray:_totalDayValueArr];
    }
    float tvalue = 0;
    for (int i=0; i<keyArr.count; i++) {
        tvalue+=[valueArr[i] floatValue];
        if (i<=dateSqrCount-1) {
            if (i==dateSqrCount-1) {
                [totalQKeyArr addObject:keyArr[i]];
                [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/dateSqrCount]]];
            }
        } else {
            tvalue -= [valueArr[i-dateSqrCount] floatValue];
            [totalQKeyArr addObject:keyArr[i]];
            [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/dateSqrCount]]];
        }
    }
    return @[totalQKeyArr,totalQValueArr,@(dateSqrCount),color];
}
/*
 *计算在均线曲线上的点
 */
-(NSArray*)getComputerResult:(NSArray*)lineArr tsqrArr:(NSArray*)tsqrArr p:(int)p{
    NSMutableArray*tresultArr=[[NSMutableArray alloc]init];
    for (int j=0; j<tsqrArr.count; j++) {
        
        NSArray*sqrArr=tsqrArr[j][1];
        int sqrCount = [tsqrArr[j][2] intValue]-1;
        if (p>0) {
            sqrCount=sqrCount-addCount+1;
        }
        NSMutableArray*resultArr=[[NSMutableArray alloc]init];
        BOOL isgo = NO;
        float beginData = 0.0;
        float endData = 0.0;
        for (int i=1; i<sqrArr.count; i++) {
            if (isgo==NO&&[lineArr[i-1+sqrCount] floatValue]<[sqrArr[i-1] floatValue]&&[lineArr[i+sqrCount] floatValue]>[sqrArr[i] floatValue]&&[sqrArr[i-1] floatValue]<[sqrArr[i] floatValue]) {
                isgo = YES;
                beginData = [lineArr[i+sqrCount] floatValue];
            }
            if (isgo&&[lineArr[i+sqrCount] floatValue]<[sqrArr[i] floatValue]) {
                isgo=NO;
                endData = [lineArr[i+sqrCount] floatValue];
                [resultArr addObject:[NSString stringWithFormat:@"%0.2f",endData-beginData]];
            }
        }
        //最大回撤金额  和 比
        NSArray*tep = [self getMaxBackMoneyAndlv:lineArr];
        [resultArr addObjectsFromArray:tep];
        //
        [tresultArr addObject:resultArr];
    }
    return tresultArr;
}
-(NSArray*)getMaxBackMoneyAndlv:(NSArray*)lineArr{
    float maxBackMoney = -1111; //最大回撤金额
    float minMoney = 0;
    BOOL isfind =NO;
    for (int i=1; i<lineArr.count-2; i++) {
        if ([lineArr[i-1] floatValue]<[lineArr[i] floatValue]&&[lineArr[i] floatValue]>[lineArr[i+1] floatValue])//中间的最大
        {
            if (maxBackMoney==-1111||maxBackMoney<[lineArr[i] floatValue])
            {
                maxBackMoney=[lineArr[i] floatValue];
                isfind=YES;
            }
        }
        if (isfind&&[lineArr[i-1] floatValue]>[lineArr[i] floatValue]&&[lineArr[i] floatValue]<[lineArr[i+1] floatValue]) {
            isfind=NO;
            minMoney =[lineArr[i] floatValue];
        }
    }
    float a = maxBackMoney - minMoney;
    return @[[NSString stringWithFormat:@"%0.2f",a],
            [NSString stringWithFormat:@"%0.2f",maxBackMoney!=0?a/maxBackMoney:0] //
            ];
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
//-(NSDate*)monthAddOneMonth:(NSDate*)currentDate{
//    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy.MM"];
//    NSString*date = [formater stringFromDate:currentDate];
//    NSArray*arr = [date componentsSeparatedByString:@"."];
//    int year = [arr[0] intValue];
//    int month = [arr[1] intValue];
//    if (month<12) {
//        month++;
//    } else {
//        year++;
//    }
//    return [formater dateFromString:[NSString stringWithFormat:@"%d.%d",year,month]];
//}
//-(BOOL)compareDate:(NSDate*)beginDate endDate:(NSDate*)endDate{
//    NSComparisonResult result = [beginDate compare:endDate];
//    switch (result) {
//        case NSOrderedAscending:
//            return  YES;
//            break;
//        case NSOrderedSame:
//            return  YES;
//            break;
//        case NSOrderedDescending:
//            return  NO;
//            break;
//
//        default:
//            break;
//    }
//}

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
    int intx = 0;
    int screenw=SCREEN_WIDTH;
    if ([self.title containsString:@"连日"]) {
        intx = 50;
        screenw=screenw-intx*2;
    }
    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(intx, 0,screenw, SCREEN_HEIGHT-30)];
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
    //    set1.lineDashLengths = @[@5.f, @2.5f];
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
    [self addOtherSet:dataSets];
    //    [dataSets addObjectsFromArray:tepArr];
    
    
    
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#0.00"];
    
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc]initWithFormatter:formatter]];
    
    _chartView.data = data;
    //    }
}
-(NSArray*)addOtherSet:(NSMutableArray*)dataSets{
    NSArray*titArr = [_titleStr componentsSeparatedByString:@"-"];
    //yxy 2018 0102 add
    //横轴数据
    for (int k=0; k<lineArr.count; k++) {
        NSArray*tempArr =lineArr[k];
        int dateSqrCount =[tempArr[2] intValue]-1;
        if(currentP>0){
            dateSqrCount = dateSqrCount - addCount+1;
        }
        NSMutableArray *xValues2 = [NSMutableArray array];
        for (int i = 0; i < [tempArr[0] count]; i ++) {
            [xValues2 addObject:tempArr[0][i]];
        }
        //纵轴数据
        NSMutableArray *yValues2 = [NSMutableArray array];
        for (int i = 0; i <[tempArr[1] count]; i ++) {
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i+dateSqrCount y:[tempArr[1][i] floatValue]];
            [yValues2 addObject:entry];
        }
        //创建LineChartDataSet对象
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yValues2 label:[NSString stringWithFormat:@"均线%@%d",titArr.count>1? titArr[1]:_titleStr,k+1]];
        set.drawIconsEnabled = NO;
        //    set2.lineDashLengths = @[@5.f, @2.5f];
        set.highlightLineDashLengths = @[@5.f, @2.5f];
        [set setColor:tempArr[3]];
        [set setCircleColor:tempArr[3]];
        set.lineWidth = 1.0;
        set.circleRadius = 3.0;
        set.drawCircleHoleEnabled = NO;
        set.valueFont = [UIFont systemFontOfSize:8.f];
        set.formLineDashLengths = @[@5.f, @2.5f];
        set.formLineWidth = 1.0;
        set.formSize = 15.0;
        [dataSets addObject:set];
    }
    return dataSets;
}

-(void)resultDataACtion{
    [self performSegueWithIdentifier:@"show_upperVC" sender:@{@"dataArray":upperDataArray}];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController*vc=[segue destinationViewController];
    [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    
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
