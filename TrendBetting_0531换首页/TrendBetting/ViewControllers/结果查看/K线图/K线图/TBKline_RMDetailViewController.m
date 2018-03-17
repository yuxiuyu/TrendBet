//
//  TBKline_RMDetailViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2018/3/16.
//  Copyright © 2018年 yxy. All rights reserved.
//
#import "Masonry.h"
#import "TBKline_RMDetailViewController.h"
#import "ZXAssemblyView.h"
@interface TBKline_RMDetailViewController ()<AssemblyViewDelegate,ZXSocketDataReformerDelegate>
{
    NSMutableDictionary * houseMonthDic;
    NSMutableArray*allDayArr;
    NSArray*monthsArr;
    NSInteger indexp;
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

@implementation TBKline_RMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_selectedTitle;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"局线的K线图" style:UIBarButtonItemStylePlain target:self action:@selector(kTimeBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    //背景色
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [self.view addSubview:self.assenblyView];
    [self addConstrains];
//    [self configureData];
    
    //这句话必须要,否则拖动到两端会出现白屏
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    monthsArr=[[Utils sharedInstance] getAllFileName:_selectedTitle];////房间里的数据
    monthsArr = [[Utils sharedInstance] orderArr:monthsArr isArc:YES];
    indexp = monthsArr.count-1;
    allDayArr=[[NSMutableArray alloc]init];
    [allDayArr addObjectsFromArray:[self getLocalData]];
     [self performSelectorOnMainThread:@selector(dealData) withObject:nil waitUntilDone:YES];
    
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
- (void)configureData:(NSArray*)kDataArr
{
    
    //=数据获取
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"kData" ofType:@"plist"];
//    NSArray *kDataArr = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i<kDataArr.count; i++) {
        [tempArray addObject:kDataArr[i]];
    }
    
    
    
    
    //==精度计算
    NSInteger precision = [self calculatePrecisionWithOriginalDataArray:kDataArr];
    
    
    
    
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
    NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:tempArray currentRequestType:@"M1"];
    [self.dataArray addObjectsFromArray:transformedDataArray];
    
    
    
    
    //====绘制k线图
    [self.assenblyView drawHistoryCandleWithDataArr:self.dataArray precision:(int)precision stackName:@"股票名" needDrawQuota:@""];
    
    //如若有socket实时绘制的需求，需要实现下面的方法
    //socket
    //定时器不再沿用
    [ZXSocketDataReformer sharedInstance].delegate = self;
    
}

-(NSArray*)getLocalData{
   
        [self showProgress:YES];

        NSMutableArray*tepallDayArr =[[NSMutableArray alloc]init];
        int totalP = 0;
    
    for (int i=indexp-5;i<=indexp;i++)
        {
            if (i>=0) {
                NSString*monthstr = monthsArr[i];
                NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",_selectedTitle,monthstr];
                NSArray*daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
                
                daysArr=[[Utils sharedInstance] orderArr:daysArr isArc:YES];
                for (NSString*dayStr in daysArr)
                {
                    NSArray*array=[dayStr componentsSeparatedByString:@"."];
                    NSDictionary*tepDic=[[Utils sharedInstance] getKlineData:monthFileNameStr dayStr:array[0] isNeedTotal:YES];
                    NSMutableArray*fiveArr=[[NSMutableArray alloc] initWithArray:tepDic[@"daycount"]];
                   
                    [fiveArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[2] intValue]]];
                    [fiveArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[3] intValue]]];
                    [fiveArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[4] intValue]]];
                    totalP += [fiveArr[1] intValue];
                    [fiveArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",totalP]];
        
                    [tepallDayArr addObject: [fiveArr componentsJoinedByString:@","]];
                }
            }
           
        }
       indexp-=6;
       [self hidenProgress];
       return tepallDayArr;
    
}
-(void)dealData{
    
     [self configureData:allDayArr];
}
-(void)kTimeBtnAction{
     [self performSegueWithIdentifier:@"showTimeKlineRuleRoomVC" sender:@{@"selectedTitle":self.title}];
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
        tempArr= [self getLocalData];
    }
    tempArr =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:tempArr currentRequestType:@"M1"];
    succ(RequestMoreResultTypeSuccess,tempArr);
}
@end
