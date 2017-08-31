//
//  TBGroup_DayViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBGroup_DayViewController.h"
#import "JHLineChart.h"
@interface TBGroup_DayViewController ()
{
    NSArray*dataArray;
    NSMutableArray*totalYArr;
    NSMutableArray*showTotalYArr;
    NSMutableArray*nameArr;
    NSMutableArray*showNameArr;
    NSArray*colorArray;
    NSString*ruleStr;
    CGFloat sHeight;
    NSMutableArray* totalNArr;
}
@end
@implementation groupDayCollectionViewCell

@end
@implementation TBGroup_DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=_selectedTitle;
    
    colorArray=@[UIColorFromRGB(0x000000),UIColorFromRGB(0x6A5AC),UIColorFromRGB(0x4169E),UIColorFromRGB(0x385E0),UIColorFromRGB(0x228B2),UIColorFromRGB(0x8A2bE2),UIColorFromRGB(0x5E2612),UIColorFromRGB(0xB22222),UIColorFromRGB(0x734A12),UIColorFromRGB(0x082E5)];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"数据结果" style:UIBarButtonItemStylePlain target:self action:@selector(resultBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    ruleStr=@"";
    nameArr=[[NSMutableArray alloc]init];
    for(int i=0;i<[Utils sharedInstance].groupSelectedArr.count;i++)
    {
        ruleStr=[NSString stringWithFormat:@"%@%d",ruleStr,i];
        NSDictionary*dic=[Utils sharedInstance].groupSelectedArr[i];
        [nameArr addObject:dic[@"name"]];
        sHeight=((i+1)/7+(i+1)%7>0?1:0)*30+10;
    }
    showNameArr=[[NSMutableArray alloc]initWithArray:nameArr];


    [self initData];
    
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot1"];

    
    

    
    
    // Do any additional setup after loading the view.
}
-(void)initData
{
    dataArray=[[NSMutableArray alloc]init];
    totalYArr=[[NSMutableArray alloc]init];
    totalNArr=[[NSMutableArray alloc]init];
    
    NSMutableArray*array=[[NSMutableArray alloc]initWithArray:[_dayDic allKeys]];
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
    
    for (int p=0; p<4; p++)
    {
        NSMutableArray*tempR=[[NSMutableArray alloc]init];
        NSMutableArray*tempN=[[NSMutableArray alloc]init];
        for (int i=0; i<[Utils sharedInstance].groupSelectedArr.count; i++)
        {
            NSMutableArray*areaArr=[[NSMutableArray alloc]init];
            NSMutableArray*tempnumberArr=[[NSMutableArray alloc]init];
            float total=0;
            for (int j=0 ; j<dataArray.count; j++)
            {
                NSArray*dayArr=_dayDic[dataArray[j]];
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
                        NSString*myStr=[NSString stringWithFormat:@"%0.3f|%0.3f",[sepB[0] floatValue]+[sepA[0] floatValue],[sepB[1] floatValue]+[sepA[1] floatValue]];
                        [tempnumberArr replaceObjectAtIndex:n withObject:myStr];
                    }
                    else
                    {
                        [tempnumberArr addObject:numA[n]];
                    }
                }

                NSString*tstr=[NSString stringWithFormat:@"%0.3f",total];
                [areaArr addObject:[[Utils sharedInstance]removeFloatAllZero:tstr]];
            }
            [tempR addObject:areaArr];
            [tempN addObject:tempnumberArr];
        }
        [totalYArr addObject:tempR];
        [totalNArr addObject:tempN];
    }
     showTotalYArr=[[NSMutableArray alloc]initWithArray:totalYArr];
    
}
-(void)addTypeBtnresView:(UICollectionReusableView*)resView
{
    for(int i=0;i<[Utils sharedInstance].groupSelectedArr.count;i++)
    {
        NSDictionary*dic=[Utils sharedInstance].groupSelectedArr[i];
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(15+((SCREEN_WIDTH-7*15)/6.0+15)*(i%7), 5+35*(i/7), (SCREEN_WIDTH-7*15)/7.0, 30)];
        [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        if ([ruleStr containsString:[NSString stringWithFormat:@"%d",i]])
        {
            [btn setBackgroundColor:[UIColor greenColor]];
        }
        else
        {
            [btn setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        
        [btn circle:5];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(addOrDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [resView addSubview:btn];
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    groupDayCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"groupDayCollectionIdentifier" forIndexPath:indexPath];
    
    cell.qtyLab.text=[NSString stringWithFormat:@"%@局",dataArray[indexPath.item]];
  
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray*array=_dayDic[dataArray[indexPath.item]];
    [self performSegueWithIdentifier:@"show_groupTimeVC" sender:@{@"dataArray":array,@"selectedTitle":[NSString stringWithFormat:@"第%ld局",indexPath.item+1]}];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView*resView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot1" forIndexPath:indexPath];
    if (dataArray.count>1)
    {
        [self addTypeBtnresView:resView];
        for (int i=0; i<4;i++)
        {
            [self showFirstAndFouthQuardrant:i resView:resView];
        }

    }
    return resView;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (dataArray.count>1)
    {
        return CGSizeMake(SCREEN_WIDTH, 330*4+sHeight);
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
    
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    
}
//第一四象限
- (void)showFirstAndFouthQuardrant:(int)thd resView:(UICollectionReusableView*)resView
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
    lineChart.xLineDataArr = dataArray;
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
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
    [ssView addSubview:lineChart];
    [resView addSubview:ssView];
    [lineChart showAnimation];
    
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
    
    [_collectionView reloadData];
    
}
#pragma mark--resultBtnAction
-(void)resultBtnAction
{
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *inputDate = [formatter dateFromString:self.title];
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:inputDate];
    NSString*str=[formatter stringFromDate:nextDate];
    [self performSegueWithIdentifier:@"show_dayResultVC" sender:@{@"dataArray":totalNArr,@"dateStr":[NSString stringWithFormat:@"%@ %@房间",str,_houseStr]}];
    //    @{@"dataArray":_dataArray}
}


@end
