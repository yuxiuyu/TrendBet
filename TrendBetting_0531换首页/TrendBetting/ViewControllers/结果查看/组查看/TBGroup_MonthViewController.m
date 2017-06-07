//
//  TBGroup_MonthViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBGroup_MonthViewController.h"
#import "MyCalendarItem.h"
#import "JHLineChart.h"
@interface TBGroup_MonthViewController ()
{
    NSMutableArray*daysNameArr;//有数据的天名
    NSMutableArray*totalYArr;
    NSMutableArray*showTotalYArr;
    
//    NSMutableArray*continueTotalYArr;
//    NSMutableArray*showContinueTotalYArr;
    
    NSMutableArray*totalNArr;
    NSMutableArray*nameArr;
    NSMutableArray*showNameArr;
    NSArray*colorArray;
    NSString*ruleStr;
    CGFloat sHeight;
    NSThread*thread;
    BOOL isrefresh;
//    BOOL iscontinue;
//    UIBarButtonItem*dayItem;
   
    
}
@property(nonatomic,strong)NSMutableDictionary*daysDic;
@property(nonatomic,strong)MyCalendarItem *myCalendarView;

@end

@implementation TBGroup_MonthViewController

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
//    iscontinue=NO;
    [self initDayNameArray];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"数据结果" style:UIBarButtonItemStylePlain target:self action:@selector(resultBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    UIBarButtonItem*ritem=[[UIBarButtonItem alloc]initWithTitle:@"资金策略" style:UIBarButtonItemStylePlain target:self action:@selector(moneyBtnAction)];
//    dayItem=[[UIBarButtonItem alloc]initWithTitle:@"天结果" style:UIBarButtonItemStylePlain target:self action:@selector(showDayResultBtnAction)];
    self.navigationItem.rightBarButtonItems=@[ritem,item];
    
    colorArray=@[UIColorFromRGB(0x000000),UIColorFromRGB(0x6A5AC),UIColorFromRGB(0x4169E),UIColorFromRGB(0x385E0),UIColorFromRGB(0x228B2),UIColorFromRGB(0x8A2bE2),UIColorFromRGB(0x5E2612),UIColorFromRGB(0xB22222),UIColorFromRGB(0x734A12),UIColorFromRGB(0x082E5)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"changeArea" object:nil];

    [_mainScrollView addSubview:self.myCalendarView];
    
  
    [self addTypeBtn];
    ////////

    
   

    thread=[[NSThread alloc] initWithTarget:self selector:@selector(getDataRead) object:nil];
    [thread start];
    

    
    

  
    
    // Do any additional setup after loading the view.
}
//-(void)showDayResultBtnAction
//{
//    iscontinue=!iscontinue;
//    dayItem.title=iscontinue?@"局结果":@"天结果";
//    for (int i=0; i<4;i++)
//    {
//        [self showFirstAndFouthQuardrant:i];
//    }
//    
//}
//天结果
//-(void)dayResultBtnAction
//{
//    
//    continueTotalYArr=[[NSMutableArray alloc]init];
//    for (int j=0;j<daysNameArr.count;j++)
//    {
//        NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",_roomStr,_selectedTitle];
//        NSDictionary*tepDic=[[Utils sharedInstance] getGroupDayData:monthFileNameStr dayStr:daysNameArr[j] isContinue:YES];
//        NSArray*valueA=[tepDic allValues][0];
//        for (int p=0; p<4; p++)
//        {
//            NSArray*kArr=valueA[p];
//            
//            for (int i=0; i<[Utils sharedInstance].groupSelectedArr.count; i++)
//            {
//                NSDictionary*medic=kArr[0][i];
//                NSNumber* max=[[medic allKeys] valueForKeyPath:@"@max.floatValue"];
//                NSString*keyStr=[NSString stringWithFormat:@"%@",max];
//                NSString*maxValue=medic[keyStr];
//                //
//                NSMutableArray*tempR=[[NSMutableArray alloc]init];
//                NSMutableArray*tempP=[[NSMutableArray alloc]init];
//                [tempR addObject:maxValue];
//                [tempP addObject:tempR];
//                if (continueTotalYArr.count>p)
//                {
//                    tempP=[[NSMutableArray alloc]initWithArray:continueTotalYArr[p]];
//                    if (tempP.count>i)
//                    {
//                         tempR=[[NSMutableArray alloc]initWithArray:continueTotalYArr[p][i]];
//                         [tempR addObject:maxValue];
//                         [tempP replaceObjectAtIndex:i withObject:tempR];
//                    }
//                    else
//                    {
//                        [tempP addObject:tempR];
//                    }
//                     [continueTotalYArr replaceObjectAtIndex:p withObject:tempP];
//                   
//                }
//                else
//                {
//                    [continueTotalYArr addObject:tempP];
//                }
//
//              
//            }
//        }
//       
//    }
//    
//    showContinueTotalYArr=[[NSMutableArray alloc]initWithArray:continueTotalYArr];
//    
//
//
//}
//资金策略改变的通知
-(void)getNotification:(NSNotification*)userInfo
{
    NSDictionary*dic=userInfo.userInfo;
    if ([dic[@"title"] isEqualToString:SAVE_MONEY_TXT])
    {
        isrefresh=YES;
    }
}
//如果资金策略改变 页面刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isrefresh)
    {
        [thread cancel];
        thread=nil;
        isrefresh=NO;
        thread=[[NSThread alloc] initWithTarget:self selector:@selector(getDataRead) object:nil];
        [thread start];
    }
    
}

-(void)getDataRead
{
    [self showProgress:YES];
     NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",_roomStr,_selectedTitle];
    _daysDic=[[NSMutableDictionary alloc]init];
    
    // paixu
    
    NSMutableArray*tempAllArr=[[NSMutableArray alloc]init];
    for (int i=0;i<daysNameArr.count;i++)
    {
        if ([[NSThread currentThread] isCancelled])
        {
            [self hidenProgress];
            [NSThread exit];
            return;
        }
        NSArray*array=[daysNameArr[i] componentsSeparatedByString:@"."];
        [daysNameArr replaceObjectAtIndex:i withObject:array[0]];
        NSDictionary*tepDic=[[Utils sharedInstance] getGroupDayData:monthFileNameStr dayStr:array[0] isContinue:NO];
        [tempAllArr addObject: [self getData:tepDic]];
        [_daysDic setObject:tepDic forKey:array[0]];
    }
    [self addAllData:tempAllArr];
    [self performSelectorOnMainThread:@selector(runMainThread) withObject:nil waitUntilDone:YES];
    
}

-(void)runMainThread
{
    [self hidenProgress];
    [self initCancaler];
    
    for (int i=0; i<4;i++)
    {
        [self showFirstAndFouthQuardrant:i];
    }
    _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, sHeight+330*4);
//    [self dayResultBtnAction];
}

-(void)initCancaler
{
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    self.myCalendarView.fileDateDic=_daysDic;
    self.myCalendarView.date=[formatter dateFromString:_selectedTitle];
    __weak typeof(self)weakself= self;
    self.myCalendarView.calendarBlock=^(NSInteger day, NSInteger month, NSInteger year)
    {
        NSString*dayStr=[NSString stringWithFormat:@"%ld",day];
        if (weakself.daysDic[dayStr])
        {
            
            [weakself performSegueWithIdentifier:@"show_groupDayVC" sender:@{@"selectedTitle":[NSString stringWithFormat:@"%@-%@",weakself.selectedTitle,dayStr],@"houseStr":weakself.roomStr,@"dayDic":weakself.daysDic[dayStr]}];
        }
    };

}
-(void)addTypeBtn
{
    
    ////////
    ruleStr=@"";
    nameArr=[[NSMutableArray alloc]init];

  
    for(int i=0;i<[Utils sharedInstance].groupSelectedArr.count;i++)
    {
          ruleStr=[NSString stringWithFormat:@"%@%d",ruleStr,i];
        NSDictionary*dic=[Utils sharedInstance].groupSelectedArr[i];
         [nameArr addObject:dic[@"name"]];
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(15+((SCREEN_WIDTH-7*15)/6.0+15)*(i%7),5+35*(i/7)+SCREEN_HEIGHT-100, (SCREEN_WIDTH-7*15)/7.0, 30)];
        [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
       
        [btn setBackgroundColor:[UIColor greenColor]];
        
        
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        
        [btn circle:5];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(addOrDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:btn];
        sHeight=btn.frame.size.height+btn.frame.origin.y+10;
    }
      showNameArr=[[NSMutableArray alloc]initWithArray:nameArr];
    
}
-(void)addAllData:(NSMutableArray*)allTepData
{
    totalYArr=[[NSMutableArray alloc]init];
    totalNArr=[[NSMutableArray alloc]init];
    for (int p=0; p<4; p++)
    {
        NSMutableArray*tempR=[[NSMutableArray alloc]init];
         NSMutableArray*tempN=[[NSMutableArray alloc]init];
        for (int i=0; i<[Utils sharedInstance].groupSelectedArr.count; i++)
        {
            NSMutableArray*areaArr=[[NSMutableArray alloc]init];
            NSMutableArray*areaNumArr=[[NSMutableArray alloc]init];
            for (int j=0 ; j<daysNameArr.count; j++)
            {
                NSArray*dayArr=allTepData[j][0];
                NSArray*ruleArr=dayArr[p];
                float a=[ruleArr[i] floatValue];
                if (j>0)
                {
                    a=a+[areaArr[j-1] floatValue];
                }
                NSString*str=[NSString stringWithFormat:@"%0.3f",a];
                [areaArr addObject:[[Utils sharedInstance]removeFloatAllZero:str]];
                /////
                NSArray*dayNArr=allTepData[j][1];
                NSArray*numi=dayNArr[p];
                NSArray*numA=numi[i];
                for (int n=0; n<numA.count; n++)
                {
                    
                    NSArray*sepA=[numA[n] componentsSeparatedByString:@"|"];
                    if (areaNumArr.count>n)
                    {
                        NSArray*sepB=[areaNumArr[n] componentsSeparatedByString:@"|"];
                        NSString*myStr=[NSString stringWithFormat:@"%0.2f|%0.2f",[sepB[0] floatValue]+[sepA[0] floatValue],[sepB[1] floatValue]+[sepA[1] floatValue]];
                        [areaNumArr replaceObjectAtIndex:n withObject:myStr];
                    }
                    else
                    {
                        [areaNumArr addObject:numA[n]];
                    }
                }
            }
            [tempR addObject:areaArr];
            [tempN addObject:areaNumArr];
        }
        [totalYArr addObject:tempR];
        [totalNArr addObject:tempN];
    }
    
     showTotalYArr=[[NSMutableArray alloc]initWithArray:totalYArr];
}
-(NSArray*)getData:(NSDictionary*)oneDayDic
{
   NSMutableArray*oneTotalYArr=[[NSMutableArray alloc]init];//one
   NSMutableArray*oneNumberArr=[[NSMutableArray alloc]init];
   NSArray*oneVArray=[oneDayDic allKeys];
    for (int p=0; p<4; p++)
    {
        
        NSMutableArray*tempR=[[NSMutableArray alloc]init];//two
        NSMutableArray*tempN=[[NSMutableArray alloc]init];//two
        for (int i=0; i<[Utils sharedInstance].groupSelectedArr.count; i++)
        {

            float total=0;
            NSMutableArray*tempnumberArr=[[NSMutableArray alloc]init];
            for (int j=0 ; j<oneVArray.count; j++)
            {
                //qian
                NSArray*dayArr=oneDayDic[oneVArray[j]];
                NSArray*ruleArr=dayArr[p];
                NSDictionary*ruleDic=ruleArr[0][i];
                NSArray*valueA=[ruleDic allKeys];
                NSNumber* max=[valueA valueForKeyPath:@"@max.floatValue"];
                NSString*keyStr=[NSString stringWithFormat:@"%@",max];
                total=total+[ruleDic[keyStr] floatValue];
                //////
                NSArray*numA=ruleArr[1][i];
                for (int n=0; n<numA.count; n++)
                {
                    
                    NSArray*sepA=[numA[n] componentsSeparatedByString:@"|"];
                    if (tempnumberArr.count>n)
                    {
                        NSArray*sepB=[tempnumberArr[n] componentsSeparatedByString:@"|"];
                        NSString*myStr=[NSString stringWithFormat:@"%0.2f|%0.2f",[sepB[0] floatValue]+[sepA[0] floatValue],[sepB[1] floatValue]+[sepA[1] floatValue]];
                        [tempnumberArr replaceObjectAtIndex:n withObject:myStr];
                    }
                    else
                    {
                        [tempnumberArr addObject:numA[n]];
                    }
                }

            }

            NSString*tstr=[NSString stringWithFormat:@"%0.3f",total];
            [tempR addObject:[[Utils sharedInstance]removeFloatAllZero:tstr]];
            [tempN addObject:tempnumberArr];
            
        }
        [oneTotalYArr addObject:tempR];
        [oneNumberArr addObject:tempN];
    }
    return @[oneTotalYArr,oneNumberArr];
    
}
//资金策略
-(void)moneyBtnAction
{
    [self performSegueWithIdentifier:@"show_month_moneyVC" sender:nil];
}
-(void)initDayNameArray
{
    
    NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",_roomStr,_selectedTitle];
    NSArray*daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
    NSArray*tnameArr=[daysArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 intValue]>[obj2 intValue])
        {
            return NSOrderedDescending;
        }
        else if ([obj1 intValue]<[obj2 intValue])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedSame;
        }
        
    }];
    daysNameArr=[[NSMutableArray alloc]initWithArray:tnameArr];
    
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
//    if ([segue.identifier isEqualToString:@"show_groupDayVC"])
//    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
//    }
}
//第一四象限
- (void)showFirstAndFouthQuardrant:(int)thd
{
    NSArray*areaNameArr=@[@"大路",@"大眼仔路",@"小路",@"小强路"];
    UIView*v=[self.view viewWithTag:10000+thd];
    if (v)
    {
        [v removeFromSuperview];
    }
    UIView*ssView=[[UIView alloc]initWithFrame:CGRectMake(10, sHeight+330*(thd), SCREEN_WIDTH-20, 320)];
    ssView.tag=10000+thd;
    [ssView border:1.5];
    //
    UILabel*areaLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ssView.frame.size.width, 20)];
    areaLab.backgroundColor=TBLineColor;
    areaLab.textColor=[UIColor whiteColor];
    areaLab.font=[UIFont systemFontOfSize:15.0];
    areaLab.text=areaNameArr[thd];
    areaLab.textAlignment=NSTextAlignmentCenter;
    [ssView addSubview:areaLab];
    //
    JHLineChart*lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 20, ssView.frame.size.width-110, 300) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = daysNameArr;
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
//    lineChart.valueArr = iscontinue?showContinueTotalYArr[thd]:showTotalYArr[thd];
    lineChart.valueArr = showTotalYArr[thd];
    lineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
    lineChart.valueFontSize = 9.0;
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =colorArray;
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = colorArray;
    lineChart.pointNumberColorArr=colorArray;
    
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
    
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
     [lineChart showAnimation];
    [ssView addSubview:lineChart];
  
    
    //
    
    UIScrollView*scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(ssView.frame.size.width-105, 20, 105, ssView.frame.size.height-20)];
    scrollview.backgroundColor=TBLineColor;
    for (int i=0; i<showNameArr.count; i++)
    {
        UILabel*colorLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 30*i+10, 10, 10)];
        colorLab.backgroundColor=colorArray[i];
        [scrollview addSubview:colorLab];
        UILabel*nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 30*i, 75, 30)];
        nameLab.text=showNameArr[i];
        nameLab.textColor=[UIColor whiteColor];
        nameLab.font=[UIFont systemFontOfSize:13];
        [scrollview addSubview:nameLab];
        
    }
    [ssView addSubview:scrollview];
    [_mainScrollView addSubview:ssView];
   
    
    
}
-(void)addOrDeleteBtnAction:(UIButton*)sender
{
    NSString*str=[NSString stringWithFormat:@"%ld",sender.tag-100];
    if ([ruleStr containsString:str])
    {
        if(ruleStr.length>1)
        {
            ruleStr=[ruleStr stringByReplacingOccurrencesOfString:str withString:@""];
            [sender setBackgroundColor:[UIColor lightGrayColor]];
        }
        else
        {
            return;
        }
    }
    else
    {
        ruleStr=[NSString stringWithFormat:@"%@%@",ruleStr,str];
        [sender setBackgroundColor:[UIColor greenColor]];
    }
    [showTotalYArr removeAllObjects];
    [showNameArr removeAllObjects];
    
    for (int i=0; i<nameArr.count; i++)
    {
        NSString*ii=[NSString stringWithFormat:@"%d",i];
        if ([ruleStr containsString:ii])
        {
            [showNameArr addObject:nameArr[i]];
        }
        
    }
    for (int i=0; i<totalYArr.count; i++)
    {
        NSArray*arr=totalYArr[i];
        NSMutableArray*tempArr=[[NSMutableArray alloc]init];
        for (int j=0; j<arr.count; j++)
        {
            NSString*jj=[NSString stringWithFormat:@"%d",j];
            if ([ruleStr containsString:jj])
            {
                [tempArr addObject:arr[j]];
            }
        }
        [showTotalYArr addObject:tempArr];
    }
    
    for (int i=0; i<4;i++)
    {
        [self showFirstAndFouthQuardrant:i];
    }

    
}

#pragma mark--resultBtnAction
-(void)resultBtnAction
{
    [self performSegueWithIdentifier:@"show_monthResultVC" sender:@{@"dataArray":totalNArr}];

}
@end
