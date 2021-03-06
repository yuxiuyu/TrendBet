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
//    LineChartView*_chartView1;
//    LineChartView*_chartView2;
//    LineChartView*_chartView3;
    NSMutableArray*lineArr;
    NSArray*upperDataArray;//符合规则在均线曲线上的点（结果）
    NSArray*upperProgressArray;//符合规则在均线曲线上的点（过程）
    NSArray*backupperDataArray; //返利的值

    int currentP;
    NSArray*allMonthNameArr;

    NSMutableDictionary*goAllMonthDic;
//    NSInteger addCount; //从上个月带过来的数据
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@end

@implementation TBNewRule_goMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titleStr;

    goAllMonthDic = [[NSMutableDictionary alloc]init];
    currentP = [_selectP intValue];

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

    } else { //连月结果
        int dateSqrCount = [[defs objectForKey:SAVE_dateSqrCount] intValue];
        [lineArr addObject: [self getKeyAndValue:dateSqrCount  color:UIColor.greenColor p:0]];
        NSString * line1 = [defs objectForKey:SAVE_dateSqrCount_1];
        NSString * line2 = [defs objectForKey:SAVE_dateSqrCount_2];
        if (line1.length>0) {
            [lineArr addObject: [self getKeyAndValue:[line1 intValue]  color:UIColor.greenColor p:0]]; ;
        }
        if (line2.length>0) {
            [lineArr addObject: [self getKeyAndValue:[line2 intValue]  color:UIColor.greenColor p:0]]; ;
        }
        NSArray*resArr = [self getComputerResult:_totalDayValueArr tsqrArr:lineArr p:0];
        upperDataArray = resArr[0];
        backupperDataArray = resArr[1];
        upperProgressArray = resArr[2];
        [self initChartView];
        _mainScrollview.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*lineArr.count-30);
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
 获取一个月的连日结果
 */
-(void)getMonthKeyAndValue:(int)p{
    NSString * keyStr = allMonthNameArr[p];
    self.title = [NSString stringWithFormat:@"%@连日结果",keyStr];


    if (goAllMonthDic[keyStr]) {
        NSArray*tepArr = goAllMonthDic[keyStr];
        _totalDayKeyArr = tepArr[0];
        _totalDayValueArr = tepArr[1];
        _totalDayBackMoneyArr = tepArr[2];
    } else {
        NSDictionary*monthdic=_allmonthDic[keyStr];
        NSMutableArray*totalTimeKeyArr=[[NSMutableArray alloc]init];//所有日连此
        NSMutableArray*totalTimeValueArr=[[NSMutableArray alloc]init];//所有日连次结果相加
        NSMutableArray*backtotalTimeValueArr=[[NSMutableArray alloc]init];//所有返利日连次结果相加

        if (p>0) {
            NSString * str = allMonthNameArr[p-1];
            NSArray*tepArr = goAllMonthDic[str];
            [totalTimeKeyArr addObject: [tepArr[0] lastObject]];
            [totalTimeValueArr addObject: [tepArr[1] lastObject]];
            [backtotalTimeValueArr addObject: [tepArr[2] lastObject]];
        }
        NSArray*tepArray=[monthdic allKeys];

        NSArray*dayxArray=[[Utils sharedInstance] orderArr:tepArray isArc:YES];
        for (int i=0; i<dayxArray.count; i++)
        {
            NSDictionary*dic=monthdic[dayxArray[i]];

            //月里的日长连次
            NSMutableArray*xkeyArray=[[NSMutableArray alloc]initWithArray:[dic allKeys]];
            [xkeyArray removeObject:@"daycount"];
            NSArray*xtimeArr=[[Utils sharedInstance] orderArr:xkeyArray isArc:YES];
            for (int k=0; k<xtimeArr.count; k++)
            {
                NSArray*tparray=dic[xtimeArr[k]];
                float a=[tparray[5] floatValue]+[[totalTimeValueArr lastObject] floatValue];
                float b=[tparray[8] floatValue]+[[backtotalTimeValueArr lastObject] floatValue];
                [totalTimeKeyArr addObject:[NSString stringWithFormat:@"%@.%d",dayxArray[i],k+1]];
                [totalTimeValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];
                [backtotalTimeValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",b]]];
            }
        }
        _totalDayKeyArr = totalTimeKeyArr;
        _totalDayValueArr = totalTimeValueArr;
        _totalDayBackMoneyArr = backtotalTimeValueArr;
        [goAllMonthDic setObject:@[_totalDayKeyArr,_totalDayValueArr,_totalDayBackMoneyArr] forKey:keyStr];
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
        [lineArr addObject: [self getKeyAndValue:[line1 intValue] color:UIColor.greenColor p:p]]; ;
    }
    //3
    NSString * line2 = [defs objectForKey:SAVE_dateDaySqrCount_2];
    if (line2.length>0) {
        [lineArr addObject: [self getKeyAndValue:[line2 intValue]  color:UIColor.greenColor p:p]]; ;
    }
    NSArray*resArr = [self getComputerResult:_totalDayValueArr tsqrArr:lineArr p:p];
    upperDataArray = resArr[0]; //在曲线上的点
    backupperDataArray = resArr[1];
    upperProgressArray = resArr[2];
    [self initChartView];
    _mainScrollview.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*lineArr.count-30);
}
/*
 *获取几日（dateSqrCount）均值 p第几个月
 */
-(NSArray*)getKeyAndValue:(int)dateSqrCount color:(UIColor*)color p:(int)p{

    NSMutableArray * keyArr ;
    NSMutableArray * valueArr ;
    NSMutableArray * totalQKeyArr = [[NSMutableArray alloc]init];
    NSMutableArray * totalQValueArr =[[NSMutableArray alloc]init];
   int addCount = 0;
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
    return @[totalQKeyArr,totalQValueArr,@(dateSqrCount),color,@(addCount)];
}
/*
 *计算在 均线曲线上的点 和 返利的钱
 */
-(NSArray*)getComputerResult:(NSArray*)lineArr tsqrArr:(NSArray*)tsqrArr p:(int)p{
    NSMutableArray*tresultArr=[[NSMutableArray alloc]init];// 在均线曲线上的点
    NSMutableArray*backtresultArr=[[NSMutableArray alloc]init]; //返利的钱
    NSMutableArray*upResArr = [[NSMutableArray alloc]init]; //记录符合规则均线曲线上的点

    
    for (int j=0; j<tsqrArr.count; j++) {
        
        NSArray*sqrArr=tsqrArr[j][1];
        NSInteger sqrCount = [tsqrArr[j][2] intValue]-1;
        int addCount = [tsqrArr[j][4] intValue];
        if (p>0) {
            sqrCount=sqrCount-addCount+1;
        }

        NSMutableArray*resultArr=[[NSMutableArray alloc]init];
        NSMutableArray*backresultArr=[[NSMutableArray alloc]init];
        NSMutableArray*upresultArr=[[NSMutableArray alloc]init];
        for (int y=0; y<lineArr.count; y++) {
            [upresultArr addObject:@""];
        }
        BOOL isgo = NO;

        int beginP;
        for (int i=1; i<sqrArr.count; i++) {
            if (isgo==NO&&[lineArr[i-1+sqrCount] floatValue]<[sqrArr[i-1] floatValue]&&[lineArr[i+sqrCount] floatValue]>[sqrArr[i] floatValue]&&[sqrArr[i-1] floatValue]<[sqrArr[i] floatValue]) {
                isgo = YES;
                beginP = i;

            }
            if (isgo)
            {
                [upresultArr replaceObjectAtIndex:i+sqrCount withObject:lineArr[i+sqrCount]];
            } else {
                [upresultArr replaceObjectAtIndex:i+sqrCount withObject:upresultArr[i+sqrCount-1]];
            }
            if (isgo&&[lineArr[i+sqrCount] floatValue]<[sqrArr[i] floatValue]) {
                isgo=NO;
                float  beginData = [lineArr[beginP+sqrCount] floatValue];
                float endData = [lineArr[i+sqrCount] floatValue];
                
                float  backbeginData = [_totalDayBackMoneyArr[beginP+sqrCount] floatValue];
                float backendData = [_totalDayBackMoneyArr[i+sqrCount] floatValue];
                
                [resultArr addObject:[NSString stringWithFormat:@"%0.2f",endData-beginData]];
                [backresultArr addObject:[NSString stringWithFormat:@"%0.2f",backendData-backbeginData]];
            }
        }
        //最大回撤金额  和 比
        NSArray*tep = [self getMaxBackMoneyAndlv:lineArr];
        [resultArr addObjectsFromArray:tep];
        //
        [tresultArr addObject:resultArr];
        [backtresultArr addObject:backresultArr];
        [upResArr addObject:upresultArr];
    }
    return @[tresultArr,backtresultArr,upResArr];
}
/*
 *获取最大回撤金额和回撤金额百分比
 */
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





-(void)initChartView{
    int intx = 0;
    int screenw=SCREEN_WIDTH;
    if ([self.title containsString:@"连日"]) {
        intx = 50;
        screenw=screenw-intx*2;
    }
    for (int k=0; k<lineArr.count; k++) {
        LineChartView*chartView = [[LineChartView alloc]initWithFrame:CGRectMake(intx, SCREEN_HEIGHT*k,screenw, SCREEN_HEIGHT-30)];
        chartView.backgroundColor=TBLineGaryColor;
        chartView.delegate = self;
        chartView.chartDescription.enabled = NO;
        chartView.dragEnabled = YES;
        [chartView setScaleEnabled:YES];
        chartView.pinchZoomEnabled = YES;
        chartView.xAxis.labelPosition = XAxisLabelPositionBottomInside;// X轴的位置

        //
        //
        chartView.xAxis.gridLineDashLengths = @[@5.0, @10.0];

        chartView.drawGridBackgroundEnabled = NO;

        ChartYAxis *leftAxis = chartView.leftAxis;
        [leftAxis removeAllLimitLines];
        leftAxis.gridLineDashLengths = @[@5.f, @5.f];
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.drawLimitLinesBehindDataEnabled = YES;

        chartView.rightAxis.enabled = NO;
        [self setDta:chartView k:k];
        [chartView animateWithXAxisDuration:2.5];
        [_mainScrollview addSubview:chartView];
    }
}

-(void)setDta:(LineChartView*)chartView k:(int)k{
    
    //横轴数据
    NSMutableArray *xValues1 = [NSMutableArray array];
    for (int i = 0; i < _totalDayKeyArr.count; i ++) {
        [xValues1 addObject:_totalDayKeyArr[i]];
    }
    //设置横轴数据给chartview
    chartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues1];
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
    [self addOtherSet:dataSets k:k];

    
    
    
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#0.00"];
    
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc]initWithFormatter:formatter]];
    
    chartView.data = data;

}
-(NSArray*)addOtherSet:(NSMutableArray*)dataSets k:(int)k{
    NSArray*titArr = [_titleStr componentsSeparatedByString:@"-"];
    //yxy 2018 0102 add
    //横轴数据
    NSArray*tempArr =lineArr[k];
    int dateSqrCount =[tempArr[2] intValue]-1;
    int addCount = [tempArr[4] intValue];
    if(currentP>0){
        dateSqrCount = dateSqrCount - addCount+1;
    }
    //纵轴数据
    NSMutableArray *yValues1 = [NSMutableArray array];
    for (int i = 0; i <[tempArr[1] count]; i ++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i+dateSqrCount y:[tempArr[1][i] floatValue]];
        [yValues1 addObject:entry];
    }
    //创建LineChartDataSet对象
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yValues1 label:[NSString stringWithFormat:@"均线%@%d",titArr.count>1? titArr[1]:_titleStr,k+1]];
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




    //纵轴数据
    NSMutableArray *yValues2 = [NSMutableArray array];
    NSArray*progressArr = upperProgressArray[k];
    for (int i = 0; i <progressArr.count; i++) {
        if ([progressArr[i] length]>0) {
            ChartDataEntry * entry = [[ChartDataEntry alloc] initWithX:i y:[progressArr[i] floatValue]];
            [yValues2 addObject:entry];
        }

    }
    //创建LineChartDataSet对象
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:yValues2 label:[NSString stringWithFormat:@"统计结果过程%d",k+1]];
    set1.drawIconsEnabled = NO;
    //    set2.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:[UIColor redColor]];
    [set1 setCircleColor:[UIColor redColor]];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:8.f];
    set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;
    [dataSets addObject:set1];

    return dataSets;
}

-(void)resultDataACtion{
    [self performSegueWithIdentifier:@"show_upperVC" sender:@{@"dataArray":upperDataArray,@"backdataArray":backupperDataArray}];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
