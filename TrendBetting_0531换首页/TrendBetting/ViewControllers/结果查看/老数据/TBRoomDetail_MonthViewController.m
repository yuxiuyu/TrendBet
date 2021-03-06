//
//  TBResultRoomDetail_MonthViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBRoomDetail_MonthViewController.h"
#import "MyCalendarItem.h"
#import "JHChart.h"
#import "JHLineChart.h"
@interface TBRoomDetail_MonthViewController ()
{
   NSMutableArray * dataArray;
//   NSMutableArray*winCountArray;
}
@property(nonatomic,strong)MyCalendarItem *myCalendarView;
@end

@implementation TBRoomDetail_MonthViewController

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
    self.title=_selectedTitle;

    _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",_winCountArray[0],_winCountArray[1],_winCountArray[2]];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:_winCountArray[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:_winCountArray[8]];
    _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",_winCountArray[4],_winCountArray[3],[[Utils sharedInstance] removeFloatAllZero:_winCountArray[5]],reduceStr,backmoneyStr];
    _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVBAR_HEIGHT-20);
    [_mainScrollView addSubview:self.myCalendarView];
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    
    self.myCalendarView.fileDateDic=[Utils sharedInstance].housesDic[_roomStr][_selectedTitle];
    self.myCalendarView.date=[formatter dateFromString:_selectedTitle];
    __weak typeof(self)weakself= self;
    self.myCalendarView.calendarBlock=^(NSInteger day, NSInteger month, NSInteger year)
    {
        
        NSString*dayStr=[NSString stringWithFormat:@"%ld",day];
        if ([Utils sharedInstance].housesDic[weakself.roomStr][weakself.selectedTitle][dayStr])
        {
              [weakself performSegueWithIdentifier:@"showRoomDetail_DayVC" sender:@{@"selectedTitle":[NSString stringWithFormat:@"%@-%@",weakself.selectedTitle,dayStr],@"dayDic":[Utils sharedInstance].housesDic[weakself.roomStr][weakself.selectedTitle][dayStr]}];
        }
      
    };
    NSArray*tepArray=[self.myCalendarView.fileDateDic allKeys];
    NSArray*xArray=[tepArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 intValue]>[obj2 intValue])
        {
            return NSOrderedDescending;
        }
        else if ([obj1 intValue]>[obj2 intValue])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
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
         [self showFirstAndFouthQuardrant:xArray vArray:vArray count:0];
         [self showFirstAndFouthQuardrant:xArray vArray:totalvArray count:1];
        _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVBAR_HEIGHT-20+600);
    }
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//第一四象限
- (void)showFirstAndFouthQuardrant:(NSArray*)xarray vArray:(NSArray*)vArray count:(int)acount
{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-NAVBAR_HEIGHT-20+300*acount, SCREEN_WIDTH-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
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
    [_mainScrollView addSubview:lineChart];
    [lineChart showAnimation];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showRoomDetail_DayVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}


@end
