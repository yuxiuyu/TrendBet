//
//  TBTimeKline_RMDetailViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 2018/3/17.
//  Copyright © 2018年 yxy. All rights reserved.
//
#import "Masonry.h"
#import "TBTimeKline_RMDetailViewController.h"
#import "ZXAssemblyView.h"
@interface TBTimeKline_RMDetailViewController ()<AssemblyViewDelegate,ZXSocketDataReformerDelegate>
{
    NSMutableDictionary * houseMonthDic;
    NSMutableArray*allDayArr;
    NSArray*monthsArr;
    NSInteger indexp;
    NSMutableArray*allResultArr; //所有的计算出来的数据结果 几根K线 亏损 洗吗
}
/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation TBTimeKline_RMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@_局线K线图",_selectedTitle];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"结果" style:UIBarButtonItemStylePlain target:self action:@selector(showResultView)];
    self.navigationItem.rightBarButtonItems=@[item];
    
    //背景色
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [self.view addSubview:self.assenblyView];
    [self addConstrains];
    //    [self configureData];
    
    //这句话必须要,否则拖动到两端会出现白屏
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    monthsArr=[[Utils sharedInstance] getAllFileName:_selectedTitle];////房间里的所有月份数据
    monthsArr = [[Utils sharedInstance] orderArr:monthsArr isArc:YES];
    indexp = monthsArr.count-1;
    allDayArr =[[NSMutableArray alloc]init];
    [allDayArr addObjectsFromArray:[self getLocalData:monthsArr[indexp]]];
    [self performSelectorOnMainThread:@selector(configureData) withObject:nil waitUntilDone:YES];
    [self dealDayData];
}
-(void)dealDayData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //1、收盘价 2、开盘价 3、最高价 4、最低价
        allResultArr=[[NSMutableArray alloc]init];
        NSMutableDictionary*time_dic;
        int max= 0;
        BOOL isBegin = NO;
        int go_time = 0; // 连续几次
        int b_count = 0; //闲的个数
        for (int i=1; i<allDayArr.count-1; i++) {
            NSArray * current_arr = [allDayArr[i] componentsSeparatedByString:@","];
            NSArray * next_arr = [allDayArr[i+1] componentsSeparatedByString:@","];
            NSArray * last_arr = [allDayArr[i-1] componentsSeparatedByString:@","];
            if (isBegin==NO) {
                
                if ([last_arr[3] intValue]<[current_arr[3] intValue] &&[current_arr[3] intValue]>[next_arr[3] intValue]) {
                    if (max<[current_arr[3] intValue]) {
                        max = [current_arr[3] intValue];
                        isBegin =YES;
                        time_dic = [[NSMutableDictionary alloc]init];
                        go_time = 0;
                        b_count = 0;
                        [time_dic setValue:@(max-[next_arr[1] intValue]) forKey:@"failMoney"]; //亏损
                    }
                }
            } else {
                if (!time_dic[@"date"]) {
                    [time_dic setValue:[self getCurrentDate:next_arr[0]] forKey:@"date"]; //日期
                }
                if (max>=[next_arr[3] intValue]) {
                    go_time++;
                    b_count+=[next_arr[5] intValue];
                } else {
                    //盘中停止
                    b_count+=[self getBcount:max-[next_arr[2] intValue] timeArr:next_arr];
                    [time_dic setValue:@(go_time) forKey:@"time"]; //几根K线
                    [time_dic setValue:[NSString stringWithFormat:@"%0.3f",b_count*0.008] forKey:@"bcount"]; //洗吗
                    [allResultArr addObject:time_dic];
                    isBegin =NO;
                }
            }
        }
        
    });
}
-(NSString*)getCurrentDate:(NSString*)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-d-H"];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}
-(int)getBcount:(int)max timeArr:(NSArray*)timeArr {
    NSString*monthStr=[self getCurrentDate:timeArr[0]];
    NSArray*monArr=[monthStr componentsSeparatedByString:@"-"];
    NSString*filename=[NSString stringWithFormat:@"%@/%@-%@/%@",_selectedTitle,monArr[0],monArr[1],monArr[2]];
    int a =[[Utils sharedInstance] getStopKlineData:filename needValue:max indexp:[monArr[3] intValue]];
    return a;
}

#pragma mark - Private Methods
- (void)addConstrains
{
    
    //初始为横屏
    //    self.navigationController.navigationBar.hidden = YES;
    [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
        
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
    NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:allDayArr currentRequestType:@"M1"];
    [self.dataArray addObjectsFromArray:transformedDataArray];
    
    
    
    
    //====绘制k线图
    [self.assenblyView drawHistoryCandleWithDataArr:self.dataArray precision:0 stackName:@"股票名" needDrawQuota:@""];
    
    //如若有socket实时绘制的需求，需要实现下面的方法
    //socket
    //定时器不再沿用
    [ZXSocketDataReformer sharedInstance].delegate = self;
    
}

-(NSArray*)getLocalData:(NSString*)monthstr{
    
    [self showProgress:YES];
    int totalP = 0;
    NSMutableArray* tempallDayArr =[[NSMutableArray alloc]init];
    
    NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",_selectedTitle,monthstr];
    NSArray*daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
    daysArr=[[Utils sharedInstance] orderArr:daysArr isArc:YES];
    for (NSString*dayStr in daysArr)
    {
        NSArray*array=[dayStr componentsSeparatedByString:@"."];
        NSDictionary*tepDic=[[Utils sharedInstance] getKlineData:monthFileNameStr dayStr:array[0] isNeedTotal:NO];
        NSArray*nowTepArr=tepDic[@"totalDayArr"];////1、收盘价 2、开盘价 3、最高价 4、最低价
        for (int i=0; i<nowTepArr.count; i++) {
            NSMutableArray*fiveArr=[[NSMutableArray alloc] initWithArray:nowTepArr[i]];
            
            [fiveArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",totalP]];
            [fiveArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[3] intValue]]];
            [fiveArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[4] intValue]]];
            totalP += [fiveArr[1] intValue];
            [fiveArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",totalP]];
            [tempallDayArr addObject: [fiveArr componentsJoinedByString:@","]];
        }
        
    }
    indexp--;
    [self hidenProgress];
    return tempallDayArr;
    
}
-(void)showResultView{
    [self performSegueWithIdentifier:@"TBKline_detailResVC" sender:@{@"dataArr":allResultArr}];
}
#pragma mark - ZXSocketDataReformerDelegate
- (void)bulidSuccessWithNewKlineModel:(KlineModel *)newKlineModel
{
    //维护控制器数据源
    if (newKlineModel.isNew) {
        
        [self.dataArray addObject:newKlineModel];
        [[ZXQuotaDataReformer sharedInstance] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
    }else{
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
        [[ZXQuotaDataReformer alloc] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
    }
    //绘制最后一个蜡烛
    [self.assenblyView drawLastKlineWithNewKlineModel:newKlineModel];
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark -  计算精度
- (NSInteger)calculatePrecisionWithOriginalDataArray:(NSArray *)dataArray
{
    NSString *dataString = dataArray.lastObject;
    NSArray *strArr = [dataString componentsSeparatedByString:@","];
    //取的最高值
    NSInteger maxPrecision = [self calculatePrecisionWithPrice:strArr[3]];
    return maxPrecision;
}
- (NSInteger)calculatePrecisionWithPrice:(NSString *)price
{
    //计算精度
    NSInteger dig = 0;
    if ([price containsString:@"."]) {
        NSArray *com = [price componentsSeparatedByString:@"."];
        dig = ((NSString *)com.lastObject).length;
    }
    return dig;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //    if ([segue.identifier isEqualToString:@"showNewRuleRoomVC"])
    //    {
    UIViewController*vc=[segue destinationViewController];
    [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    //    }
}
/**
 * @brief 请求更多的历史数据
 * @param succ block回调请求的数据
 */
- (void)shouldToRequestMoreHistoryKlineDataArr:(SuccessBlock)succ
{
    NSArray *tempArr =@[];
    if (indexp>=0) {
        //        tempArr= [self getLocalData:monthsArr[indexp]];
        tempArr= [self continueArr:[self getLocalData:monthsArr[indexp]]];
        
    }
    
    tempArr =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:tempArr currentRequestType:@"M1"];
    succ(RequestMoreResultTypeSuccess,tempArr);
}
-(NSArray*)continueArr:(NSArray*)temArr {
    ////1、收盘价 2、开盘价 3、最高价 4、最低价
    NSMutableArray *allResArr=[NSMutableArray arrayWithArray:temArr];
    NSArray*last = [[temArr lastObject] componentsSeparatedByString:@","];
    int total_one = [last[1] intValue];
    for (int i=0; i<allDayArr.count-1; i++) {
        NSMutableArray*current=[NSMutableArray arrayWithArray:[allDayArr[i] componentsSeparatedByString:@","]];
        [current replaceObjectAtIndex:1 withObject:@([current[1] intValue]+[last[1] intValue])];
        [current replaceObjectAtIndex:2 withObject:@(total_one)];
        total_one = [current[1] intValue]; //第二天的开盘价为第一天的收盘价
       
//        [current replaceObjectAtIndex:2 withObject:@([current[2] intValue]+[last[2] intValue])];
        [current replaceObjectAtIndex:3 withObject:@([current[3] intValue]+[last[1] intValue])];
        [current replaceObjectAtIndex:4 withObject:@([current[4] intValue]+[last[1] intValue])];
        [allResArr addObject:[current componentsJoinedByString:@","]];
    }
    [allDayArr removeAllObjects];
    [allDayArr addObjectsFromArray:allResArr];
    [self dealDayData];
    return allResArr;
}
@end

