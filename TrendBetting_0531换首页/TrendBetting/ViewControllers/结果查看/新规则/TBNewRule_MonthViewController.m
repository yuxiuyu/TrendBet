//
//  TBNewRule_MonthViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//
#import "Masonry.h"
#import "TBNewRule_MonthViewController.h"
#import "MyCalendarItem.h"
//#import "JHChart.h"
//#import "JHLineChart.h"
#import "ZXAssemblyView.h"
@interface TBNewRule_MonthViewController ()<AssemblyViewDelegate,ZXSocketDataReformerDelegate>
{
    NSMutableArray*daysNameArr;//有数据的天名
    NSMutableArray*totalYArr;
    NSMutableArray*showTotalYArr;

    NSMutableArray*totalNArr;
//    NSMutableArray*nameArr;
//    NSMutableArray*showNameArr;
//    NSArray*colorArray;
    NSMutableArray*kArr; //k线
    NSString*ruleStr;
    CGFloat sHeight;
    NSThread*thread;
  

 
   

    
    
}
/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *kDataArr;
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
    _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVBAR_HEIGHT-20+TotalHeight);
    [_mainScrollView addSubview:self.myCalendarView];
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    

    kArr = [[NSMutableArray alloc]init];
    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [_mainScrollView addSubview:self.assenblyView];
    [self addConstrains];

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
    int totalP = 0;
    for (int i=0; i<xArray.count; i++)
    {
        NSDictionary*dic=self.myCalendarView.fileDateDic[xArray[i]];
        NSArray*daycountarray=dic[@"daycount"];

        NSMutableArray*fiveArr=[[NSMutableArray alloc] initWithArray:daycountarray[11]];
        //                @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
//        [fiveArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",totalP]];
//        [fiveArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[3] intValue]]];
//        [fiveArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[4] intValue]]];
//        totalP += [fiveArr[1] intValue];
//        [fiveArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",totalP]];
        
        [kArr addObject: [fiveArr componentsJoinedByString:@","]];
    }
     [self performSelectorOnMainThread:@selector(configureData) withObject:nil waitUntilDone:YES];
    if (xArray.count>1)
    {
//        [self initChartView:xArray yarray1:vArray yarray2:totalvArray];
        _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVBAR_HEIGHT-20+TotalHeight);
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


- (void)configureData
{
    
    //将请求到的数据数组传递过去，并且精度也是需要你自己传;
    /*
     数组中数据格式:@[@"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"...",
     @"..."];
     */
    /*如果的数据格式和此demo中不同，那么你需要点进去看看，并且修改响应的取值为你的数据格式;
     修改数据格式→  ↓↓↓↓↓↓↓点它↓↓↓↓↓↓↓↓↓  ←
     */
    //===数据处理
    NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:kArr currentRequestType:@"M1"];
    [self.kDataArr addObjectsFromArray:transformedDataArray];
    
    
    
    
    //====绘制k线图
    [self.assenblyView drawHistoryCandleWithDataArr:self.kDataArr precision:0 stackName:@"股票名" needDrawQuota:@""];
    
    //如若有socket实时绘制的需求，需要实现下面的方法
    //socket
    //定时器不再沿用
    [ZXSocketDataReformer sharedInstance].delegate = self;
    
}

#pragma mark - ZXSocketDataReformerDelegate
- (void)bulidSuccessWithNewKlineModel:(KlineModel *)newKlineModel
{
    //维护控制器数据源
    if (newKlineModel.isNew) {
        
        [self.kDataArr addObject:newKlineModel];
        [[ZXQuotaDataReformer sharedInstance] handleQuotaDataWithDataArr:self.kDataArr model:newKlineModel index:self.kDataArr.count-1];
        [self.kDataArr replaceObjectAtIndex:self.kDataArr.count-1 withObject:newKlineModel];
        
    }else{
        [self.kDataArr replaceObjectAtIndex:self.kDataArr.count-1 withObject:newKlineModel];
        
        [[ZXQuotaDataReformer alloc] handleQuotaDataWithDataArr:self.kDataArr model:newKlineModel index:self.kDataArr.count-1];
        
        [self.kDataArr replaceObjectAtIndex:self.kDataArr.count-1 withObject:newKlineModel];
    }
    //绘制最后一个蜡烛
    [self.assenblyView drawLastKlineWithNewKlineModel:newKlineModel];
}

#pragma mark - Private Methods
- (void)addConstrains
{
    
    //初始为横屏
    //    self.navigationController.navigationBar.hidden = YES;
    [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(SCREEN_HEIGHT-NAVBAR_HEIGHT-20);
        make.left.mas_equalTo(self.mainScrollView);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
        
    }];
}
#pragma mark - Getters & Setters
- (ZXAssemblyView *)assenblyView
{
    if (!_assenblyView) {
        //仅仅只有k线的初始化方法
        //        _assenblyView = [[ZXAssemblyView alloc] initWithDrawJustKline:YES];
        //带指标的初始化
        _assenblyView = [[ZXAssemblyView alloc] init];
        _assenblyView.delegate = self;
    }
    return _assenblyView;
}
- (NSMutableArray *)kDataArr
{
    if (!_kDataArr) {
        _kDataArr = [NSMutableArray array];
    }
    return _kDataArr;
}

@end
