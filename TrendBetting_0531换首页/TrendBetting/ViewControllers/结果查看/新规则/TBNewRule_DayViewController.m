//
//  TBNewRule_DayViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//
#import "Masonry.h"
#import "TBNewRule_DayViewController.h"
#import "TBFileRoomResult_dataArr.h"
#import "ZXAssemblyView.h"
//#import "JHLineChart.h"
//#import "WSLineChartView.h"


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface TBNewRule_DayViewController ()<UICollectionViewDelegate,AssemblyViewDelegate,ZXSocketDataReformerDelegate>
{
    NSArray*dataArray;
//    JHLineChart *lineChart;
//    JHLineChart *totalLineChart;
//    NSMutableArray*answerArray;
//    NSMutableArray*totalAnswerArray;
    NSMutableArray*kArr;
    NSThread*thread;
//    LineChartView*_chartView;
    NSMutableArray*totalTimeKeyArr;//所有局连此
    NSMutableArray*totalTimeValueArr;//所有局连次结果相加
    
}
/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *kDataArr;
@end

@implementation newRuleDayCollectionViewCell
@end



@implementation TBNewRule_DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"连局结果" style:UIBarButtonItemStylePlain target:self action:@selector(goTimesresultBtnAction)];
    self.navigationItem.rightBarButtonItems=@[item];
    
    totalTimeKeyArr=[[NSMutableArray alloc]init];
    totalTimeValueArr=[[NSMutableArray alloc]init];
    
    
  
    if ([_isCurrentDay intValue]==1) {
        
        [self getDataRead];
    } else {
        self.title=_selectedTitle;
        [self updateView];
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [thread cancel];
    thread=nil;
}
-(void)goTimesresultBtnAction{
     [self performSegueWithIdentifier:@"show_goMonthTimeResultVC" sender:@{@"totalDayKeyArr":totalTimeKeyArr,@"totalDayValueArr":totalTimeValueArr,@"titleStr":@"连局结果"}];
}
-(void)getDataRead
{
    NSArray*curDay=[[Utils sharedInstance] getCurrentYearMonthDay];
    self.title=[NSString stringWithFormat:@"%@-%@-%@",curDay[0],curDay[1],curDay[2]];
    _dayDic=[[Utils sharedInstance] getNewRuleDayData:[NSString stringWithFormat:@"%@/%@-%02d",_selectedTitle,curDay[0],[curDay[1] intValue]] dayStr:curDay[2]];
    [self updateView];

}
-(void)updateView{
    
    dataArray=[[NSMutableArray alloc]init];
   
    NSArray*tempArr=_dayDic[@"daycount"];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:tempArr[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:tempArr[8]];
    _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",tempArr[0],tempArr[1],tempArr[2]];
    _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",tempArr[4],tempArr[3],[[Utils sharedInstance]removeFloatAllZero:tempArr[5]],reduceStr,backmoneyStr];
    
    
    NSMutableArray*array=[[NSMutableArray alloc]initWithArray:[_dayDic allKeys]];
    [array removeObject:@"daycount"];
    dataArray=[[Utils sharedInstance] orderArr:array isArc:YES];
    kArr = [[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++)
    {
        NSArray*tparray=_dayDic[dataArray[i]];
        NSArray*fiveArr = tparray[14];
        [kArr addObject: [fiveArr componentsJoinedByString:@","]];
      
        
    }
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot1"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    newRuleDayCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"newRuleDayCollectionIdentifier" forIndexPath:indexPath];
    
    cell.qtyLab.text=[NSString stringWithFormat:@"%@局",dataArray[indexPath.item]];
    NSArray*arr = [kArr[indexPath.item] componentsSeparatedByString:@","];
    cell.winLab.text=arr[1];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showNewRule_TimeVC" sender:@{@"dataArray":_dayDic[dataArray[indexPath.item]],@"selectedTitle":[NSString stringWithFormat:@"第%ld局",indexPath.item+1]}];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView*resView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot1" forIndexPath:indexPath];
    if (dataArray.count>1)
    {
        
//        [self showFirstAndFouthQuardrant:dataArray vArray:answerArray];
//        [resView addSubview:lineChart];
//
//        [self showFirstAndFouthQuardrant1:dataArray vArray:totalAnswerArray];
       
        [resView addSubview:self.assenblyView];
         [self addConstrains];
        [self configureData];
    }
    return resView;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (dataArray.count>1)
    {
        return CGSizeMake(SCREEN_WIDTH, TotalHeight);
    }
    else
    {
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
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
    if ([segue.identifier isEqualToString:@"showNewRule_TimeVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
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
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
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
