//
//  TBNewRule_TimeViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_TimeViewController.h"
#import "TBFileRoomResult_dataArr.h"
#import "JHLineChart.h"
#import "chartImageView.h"
#import "WSLineChartView.h"
#import "Charts-Swift.h"

#define resultView_height 280
#define collectionView_height SCREEN_HEIGHT-44-40
@interface TBNewRule_TimeViewController ()<ChartViewDelegate>
{
    NSArray*countResult;
    NSArray*xArray;
    NSMutableArray*VArray;
    NSDictionary*changeDic;
    NSDictionary*changeTotalDic;
    NSMutableArray*fristPartArray;//1
    NSMutableArray*thirdPartArray;//3
    NSMutableArray*forthPartArray;//4
    NSMutableArray*fivePartArray;//5
    
    LineChartView*_chartView;
    
}
@end
@implementation newRuleTimeUICollectionViewCell
@end
@implementation TBNewRule_TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=_selectedTitle;
    
    countResult=_dataArray[9];
    [self setData];
    changeDic=_dataArray[10];
    changeTotalDic=_dataArray[11];
    NSMutableArray*keyArr=[[NSMutableArray alloc ]initWithArray:[changeTotalDic allKeys]];
    xArray=[keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    
    VArray=[[NSMutableArray alloc]init];
    for (int i=0; i<xArray.count; i++)
    {
        [VArray addObject:[[Utils sharedInstance]removeFloatAllZero:changeTotalDic[xArray[i]]]];
    }
    _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",_dataArray[0],_dataArray[1],_dataArray[2]];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:_dataArray[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:_dataArray[8]];
    _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",_dataArray[4],_dataArray[3],[[Utils sharedInstance]removeFloatAllZero:_dataArray[5]],reduceStr,backmoneyStr];
    _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, collectionView_height+collectionView_height);
    
    
    //    [self initChartImageView];
    
    
    _collectionview.frame=CGRectMake(0, collectionView_height, SCREEN_WIDTH, collectionView_height);
    [_collectionview border:0.5f];
    [_mainScrollView addSubview:_resultView];
    [_mainScrollView addSubview:_collectionview];
    if (xArray.count>1)
    {
        [self initChartView];
        _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, collectionView_height+collectionView_height+340);
       
    }
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initChartImageView];
}
-(void)setData
{
    fristPartArray=[[NSMutableArray alloc]init];
    thirdPartArray=[[NSMutableArray alloc]init];
    forthPartArray=[[NSMutableArray alloc]init];
    fivePartArray=[[NSMutableArray alloc]init];
    for (NSString*resultStr in countResult)
    {
        if ([resultStr isEqualToString:@"T"])
        {
            continue;
        }
        if(fristPartArray.count>0)
        {
            
            NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[fristPartArray lastObject]];
            if ([[tempArray lastObject] isEqualToString:resultStr])
            {
                [tempArray addObject:resultStr];
                [fristPartArray replaceObjectAtIndex:fristPartArray.count-1 withObject:tempArray];/////接着追加
            }
            else
            {
                tempArray=[[NSMutableArray alloc]init];
                [tempArray addObject:resultStr];
                [fristPartArray addObject:tempArray];
            }
        }
        else
        {
            NSMutableArray*tempArray=[[NSMutableArray alloc]init];
            [tempArray addObject:resultStr];
            [fristPartArray addObject:tempArray];
        }
        thirdPartArray=[[Utils sharedInstance] setNewData:fristPartArray startCount:1 dataArray:thirdPartArray];
        forthPartArray=[[Utils sharedInstance] setNewData:fristPartArray startCount:2 dataArray:forthPartArray];
        fivePartArray=[[Utils sharedInstance]  setNewData:fristPartArray startCount:3 dataArray:fivePartArray];
        
    }
    
    
 
    
    
    
    
    
    
    
}
-(void)initChartImageView
{
    _resultView.frame=CGRectMake(0, 0, SCREEN_WIDTH, resultView_height);
    for (int i=0; i<5; i++)
    {
        UIView*colView=[_resultView viewWithTag:100+i];
        chartImageView *view=[[chartImageView alloc]initWithFrame:CGRectMake(0, 0, colView.frame.size.width, colView.frame.size.height-(i>1?1:0))];
        view.myType=i+1;
        switch (i){
            case 0:
                view.itemArray= [[Utils sharedInstance] ThirdPartData:fristPartArray];
                break;
            case 1:
                view.itemArray=countResult;
                break;
            case 2:
                view.itemArray=[[Utils sharedInstance] ThirdPartData:thirdPartArray];
                break;
            case 3:
                view.itemArray=[[Utils sharedInstance] ThirdPartData:forthPartArray];
                break;
            case 4:
                view.itemArray=[[Utils sharedInstance] ThirdPartData:fivePartArray];
                break;
                
            default:
                break;
        }
        
        [colView addSubview:view];
    }
}
#pragma mark---------collectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return countResult.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    newRuleTimeUICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"newRuleTimecollectionViewCell" forIndexPath:indexPath];
    
    NSString*str= countResult[indexPath.row];
    NSString*nameStr=@"和";
    if ([str isEqualToString:@"R"])
    {
        nameStr=@"庄";
    }
    else if ([str isEqualToString:@"B"])
    {
        nameStr=@"闲";
    }
    cell.resultLab.text=nameStr;
    cell.moneyLab.text= [[Utils sharedInstance]removeFloatAllZero:changeDic[[NSString stringWithFormat:@"%ld",indexPath.item]]];
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREEN_HEIGHT-44-40)/6.0, (SCREEN_HEIGHT-44-40)/6.0);
    
}
-(void)initChartView{
    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-44-40)*2+20, SCREEN_WIDTH, 300)];
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
    //    _chartView.xAxis.gridLineDashPhase = 0.f;
    
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    //    leftAxis.axisMaximum = 200.0;
    //    leftAxis.axisMinimum = -50.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    //        BalloonMarker *marker = [[BalloonMarker alloc]
    //                                 initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
    //                                 font: [UIFont systemFontOfSize:12.0]
    //                                 textColor: UIColor.whiteColor
    //                                 insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    //        marker.chartView = _chartView;
    //        marker.minimumSize = CGSizeMake(80.f, 40.f);
    //        _chartView.marker = marker;
    [self setDta];
    [_chartView animateWithXAxisDuration:2.5];
    [_mainScrollView addSubview:_chartView];
}
-(void)setDta{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < xArray.count; i++)
    {
        float x = [xArray[i] floatValue];
        float y = [[[Utils sharedInstance]removeFloatAllZero:VArray[i]] floatValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:x y:y]];
    }
    LineChartDataSet *set1 = nil;
    
    set1 = [[LineChartDataSet alloc] initWithValues:values label:@"把累加结果"];
    set1.drawIconsEnabled = NO;
//    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.orangeColor];
    [set1 setCircleColor:UIColor.orangeColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;
    
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#0.0"];
    
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc]initWithFormatter:formatter]];
    
    _chartView.data = data;
    //    }
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
