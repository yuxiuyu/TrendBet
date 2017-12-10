//
//  TBNewRule_goMonthViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/6.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_goMonthViewController.h"
#import "JHChart.h"
#import "JHLineChart.h"
#define yxy 5
@interface TBNewRule_goMonthViewController ()<UIScrollViewDelegate>
{
    int keyWidth1;
    int keyWidth2;
    NSMutableArray * totalQKeyArr;
    NSMutableArray * totalQValueArr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@end

@implementation TBNewRule_goMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titleStr;
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportAction)];
    self.navigationItem.rightBarButtonItem=item;
    keyWidth1=_totalDayKeyArr.count>200?45:55;
    
    totalQKeyArr = [[NSMutableArray alloc]init];
    totalQValueArr =[[NSMutableArray alloc]init];
    
    [self showFirstAndFouthQuardrant:_totalDayKeyArr vArray:_totalDayValueArr];
   
    [self getKeyAndValue];
    keyWidth2=totalQKeyArr.count+yxy>200?45:55;
    [self showFirstAndFouthQuardrant2:totalQKeyArr vArray:totalQValueArr];
    _mainScrollview.contentSize=CGSizeMake(keyWidth2*(_totalDayValueArr.count>totalQKeyArr.count?_totalDayValueArr.count:totalQValueArr.count), SCREEN_HEIGHT-30+SCREEN_HEIGHT);
   
    // Do any additional setup after loading the view.
}
-(void)getKeyAndValue{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy.MM"];
    
    NSArray * beginArr =[_totalDayKeyArr[0] componentsSeparatedByString:@"."];
    NSArray * endArr =[[_totalDayKeyArr lastObject] componentsSeparatedByString:@"."];
    NSDate * beginDate =[formater dateFromString:[NSString stringWithFormat:@"%@.%d",beginArr[0],[beginArr[1] intValue]]];
    NSString* endMonStr = [NSString stringWithFormat:@"%@.%d",endArr[0],[endArr[1] intValue]];
    NSDate * endDate =[formater dateFromString:endMonStr];
    int gcount = 0;
    int indexp = 0;
    float tvalue = 0;
    NSMutableArray *TArr =[[NSMutableArray alloc]init];
    while ([self compareDate:beginDate endDate:endDate]) {
        NSInteger monthCount = [[Utils sharedInstance] getAllDayFromDate:beginDate];
        for (int i=0; i<monthCount; i++) {
            float value = 0;
            NSString *keyStr = [NSString stringWithFormat:@"%@.%d",[formater stringFromDate:beginDate],i+1];
            if (indexp < _totalDayKeyArr.count&&[_totalDayKeyArr[indexp] isEqualToString:keyStr]) {
                
                value = [_totalDayValueArr[indexp] floatValue];
                indexp++;
            }
            [TArr addObject:[NSString stringWithFormat:@"%0.3f",value]];
            tvalue+=value;
            if (gcount==0&&i<yxy) {
                if (i==yxy-1) {
                    [totalQKeyArr addObject:keyStr];
                    [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/5.0]]];
                }
            } else {
                tvalue -= [TArr[0] floatValue];
                [TArr removeObjectAtIndex:0];
                [totalQKeyArr addObject:keyStr];
                [totalQValueArr addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",tvalue/5.0]]];
            }
            if (indexp == _totalDayKeyArr.count && [[formater stringFromDate:beginDate] isEqualToString:endMonStr]) {
                return;
            }
        }
        gcount++;
        beginDate = [self monthAddOneMonth:beginDate];

    }
    NSLog(@"yxy");
   
    
    
}
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
//第一四象限
- (void)showFirstAndFouthQuardrant:(NSArray*)xarray vArray:(NSArray*)vArray
{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 0, keyWidth1*_totalDayValueArr.count, SCREEN_HEIGHT-30) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = xarray;
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    lineChart.valueArr = @[vArray];
    lineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
    lineChart.valueFontSize = 9.0;
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /*        是否展示Y轴分层线条 默认否        */
    lineChart.showYLevelLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = YES;
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor darkGrayColor];
    lineChart.backgroundColor = [UIColor whiteColor];
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    
    lineChart.contentFill = YES;
    
    lineChart.pathCurve = YES;
    
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
    [_mainScrollview addSubview:lineChart];
    [lineChart showAnimation];
}
//第一四象限
- (void)showFirstAndFouthQuardrant2:(NSArray*)xarray vArray:(NSArray*)vArray
{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, keyWidth2*totalQValueArr.count, SCREEN_HEIGHT-30) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = xarray;
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    lineChart.valueArr = @[vArray];
    lineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
    lineChart.valueFontSize = 9.0;
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /*        是否展示Y轴分层线条 默认否        */
    lineChart.showYLevelLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = YES;
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor darkGrayColor];
    lineChart.backgroundColor = [UIColor whiteColor];
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    
    lineChart.contentFill = YES;
    
    lineChart.pathCurve = YES;
    
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
    [_mainScrollview addSubview:lineChart];
    [lineChart showAnimation];
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
