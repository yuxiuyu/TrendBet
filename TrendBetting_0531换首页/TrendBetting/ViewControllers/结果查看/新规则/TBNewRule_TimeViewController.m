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
#define resultView_height 280
#define collectionView_height SCREEN_HEIGHT-44-40
@interface TBNewRule_TimeViewController ()
{
    NSArray*countResult;
    NSArray*xArray;
    NSDictionary*changeDic;
    NSDictionary*changeTotalDic;
    NSMutableArray*fristPartArray;//1
    NSMutableArray*thirdPartArray;//3
    NSMutableArray*forthPartArray;//4
    NSMutableArray*fivePartArray;//5
    
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
    changeDic=_dataArray[_dataArray.count-2];
    changeTotalDic=[_dataArray lastObject];
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
    
    NSMutableArray*VArray=[[NSMutableArray alloc]init];
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
        [self showFirstAndFouthQuardrant:xArray vArray:VArray];
        _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, collectionView_height+collectionView_height+300);
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
    
    
    
    
    
    
    //    //第一部分数据
    //    view1.itemArray=[self ThirdPartData:fristPartArray];
    //    //第三部分数据
    //    view3.itemArray=[self ThirdPartData:thirdPartArray];
    //    //第四部分数据
    //    view4.itemArray=[self ThirdPartData:forthPartArray];
    //    //第五部分数据
    //    view5.itemArray=[self ThirdPartData:fivePartArray];
    //    //
    
    
    
    
    
    
    
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
    cell.moneyLab.text=changeDic[[NSString stringWithFormat:@"%ld",indexPath.item]];
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREEN_HEIGHT-44-40)/6.0, (SCREEN_HEIGHT-44-40)/6.0);
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//第一四象限
- (void)showFirstAndFouthQuardrant:(NSArray*)xarray vArray:(NSArray*)vArray
{
    
    JHLineChart*lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-44-40)*2, SCREEN_WIDTH-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
