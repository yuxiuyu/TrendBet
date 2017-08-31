//
//  TBResultRoomDetail_DayViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBRoomDetail_DayViewController.h"
#import "TBFileRoomResult_dataArr.h"
#import "JHLineChart.h"
@interface TBRoomDetail_DayViewController ()<UICollectionViewDelegate>
{
    NSArray*dataArray;
    JHLineChart *lineChart;
    JHLineChart *totalLineChart;
    NSMutableArray*answerArray;
    NSMutableArray*totalAnswerArray;
    
}
@end

@implementation dayCollectionViewCell
@end
@implementation TBRoomDetail_DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=_selectedTitle;
    
    

        dataArray=[[NSMutableArray alloc]init];
        answerArray=[[NSMutableArray alloc]init];
        totalAnswerArray=[[NSMutableArray alloc]init];
        NSArray*tempArr=_dayDic[@"daycount"];
        NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:tempArr[7]];
        reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:tempArr[8]];
        _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",tempArr[0],tempArr[1],tempArr[2]];
        _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",tempArr[4],tempArr[3],[[Utils sharedInstance]removeFloatAllZero:tempArr[5]],reduceStr,backmoneyStr];


        NSMutableArray*array=[[NSMutableArray alloc]initWithArray:[_dayDic allKeys]];
        [array removeObject:@"daycount"];
        dataArray=[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
        for (int i=0; i<dataArray.count; i++)
        {
            NSArray*tparray=_dayDic[dataArray[i]];
            [answerArray addObject:[[Utils sharedInstance]removeFloatAllZero:tparray[5]]];
            float a=[tparray[5] floatValue]+[[totalAnswerArray lastObject] floatValue];
            [totalAnswerArray addObject:[[Utils sharedInstance]removeFloatAllZero:[NSString stringWithFormat:@"%0.3f",a]]];
            
        }
   
         [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot1"];
    
    
    // Do any additional setup after loading the view.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    dayCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"dayCollectionIdentifier" forIndexPath:indexPath];
   
    cell.qtyLab.text=[NSString stringWithFormat:@"%@局",dataArray[indexPath.item]];
    cell.winLab.text=answerArray[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showRoomDetail_TimeVC" sender:@{@"dataArray":_dayDic[dataArray[indexPath.item]],@"selectedTitle":[NSString stringWithFormat:@"第%ld局",indexPath.item+1]}];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView*resView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot1" forIndexPath:indexPath];
    if (dataArray.count>1)
    {
        [self showFirstAndFouthQuardrant:dataArray vArray:answerArray];
        [resView addSubview:lineChart];
        
        [self showFirstAndFouthQuardrant1:dataArray vArray:totalAnswerArray];
        [resView addSubview:totalLineChart];
    }
    return resView;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (dataArray.count>1)
    {
       return CGSizeMake(SCREEN_WIDTH, 600);
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
    if ([segue.identifier isEqualToString:@"showRoomDetail_TimeVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}

//第一四象限
- (void)showFirstAndFouthQuardrant:(NSArray*)xarray vArray:(NSArray*)vArray
{
    if (!lineChart)
    {
        lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
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
        [lineChart showAnimation];

    }
}

//第一四象限
- (void)showFirstAndFouthQuardrant1:(NSArray*)xarray vArray:(NSArray*)vArray
{
    if (!totalLineChart)
    {
        totalLineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 300, SCREEN_WIDTH-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
        totalLineChart.xLineDataArr = xarray;
        totalLineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
        totalLineChart.valueArr = @[vArray];
        totalLineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
        totalLineChart.valueFontSize = 9.0;
        /* 值折线的折线颜色 默认暗黑色*/
        totalLineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
        
        /* 值点的颜色 默认橘黄色*/
        totalLineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
        
        /*        是否展示Y轴分层线条 默认否        */
        totalLineChart.showYLevelLine = NO;
        totalLineChart.showValueLeadingLine = NO;
        totalLineChart.showYLevelLine = YES;
        totalLineChart.showYLine = YES;
        
        /* X和Y轴的颜色 默认暗黑色 */
        totalLineChart.xAndYLineColor = [UIColor darkGrayColor];
        totalLineChart.backgroundColor = [UIColor whiteColor];
        /* XY轴的刻度颜色 m */
        totalLineChart.xAndYNumberColor = [UIColor darkGrayColor];
        
        totalLineChart.contentFill = YES;
        
        totalLineChart.pathCurve = YES;
        
        totalLineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
        [totalLineChart showAnimation];
        
    }
}
@end
