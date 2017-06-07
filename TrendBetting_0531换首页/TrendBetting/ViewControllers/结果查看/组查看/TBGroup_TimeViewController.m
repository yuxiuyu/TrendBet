//
//  TBGroup_TimeViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBGroup_TimeViewController.h"
#import "JHLineChart.h"
@interface TBGroup_TimeViewController ()
{
    CGFloat sHeight;
    NSMutableArray*allXArr;
    NSMutableArray*allYArr;
    NSMutableArray*showAllYArr;
    NSMutableArray*allnameArr;
    NSMutableArray*nameArr;
    NSString*ruleStr;
    NSArray*colorArray;
    
}
@end

@implementation TBGroup_TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=_selectedTitle;
   
    
    
     colorArray=@[UIColorFromRGB(0x000000),UIColorFromRGB(0x6A5AC),UIColorFromRGB(0x4169E),UIColorFromRGB(0x385E0),UIColorFromRGB(0x228B2),UIColorFromRGB(0x8A2bE2),UIColorFromRGB(0x5E2612),UIColorFromRGB(0xB22222),UIColorFromRGB(0x734A12),UIColorFromRGB(0x082E5)];
    ruleStr=@"";
    nameArr=[[NSMutableArray alloc]init];
    allnameArr=[[NSMutableArray alloc]init];
    for(int i=0;i<[Utils sharedInstance].groupSelectedArr.count;i++)
    {
        ruleStr=[NSString stringWithFormat:@"%@%d",ruleStr,i];
        NSDictionary*dic=[Utils sharedInstance].groupSelectedArr[i];
        [nameArr addObject:dic[@"name"]];
        [allnameArr addObject:dic[@"name"]];
        
    }
    [self addTypeBtn];
    [self initXYArray];
    for (int i=0; i<allXArr.count;i++)
    {
         [self showFirstAndFouthQuardrant:i];
    }
    _mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, sHeight+330*4);
   
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)addTypeBtn
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
        [_mainScrollView addSubview:btn];
        sHeight=btn.frame.size.height+btn.frame.origin.y+10;
    }

}
-(void)initXYArray
{
    allXArr=[[NSMutableArray alloc]init];
    allYArr=[[NSMutableArray alloc]init];
    showAllYArr=[[NSMutableArray alloc]init];
    for (int i=0; i<_dataArray.count; i++)
    {
        NSMutableSet*tempXset=[[NSMutableSet alloc]init];
        NSMutableArray*tempYArr=[[NSMutableArray alloc]init];
       
        NSArray*temArr=_dataArray[i][0];
        for (int j=0; j<temArr.count; j++)
        {
            NSDictionary*dic=temArr[j];
            [tempXset addObjectsFromArray:[dic allKeys]];
        }
       
//        tempXArr=[NSMutableArray arrayWithArray:[myenumer allObjects]];
        NSArray*resultXArr=[[tempXset allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
        for (int j=0; j<temArr.count; j++)
        {
            NSDictionary*dic=temArr[j];
            
            NSMutableArray*yArray=[[NSMutableArray alloc]init];
            for (int k=0; k<resultXArr.count; k++)
            {
                [yArray addObject:[[Utils sharedInstance]removeFloatAllZero:dic[resultXArr[k]]]];
            }
           
            [tempYArr addObject:yArray];
            
        }
        [allXArr addObject:resultXArr];
        [allYArr addObject:tempYArr];
        [showAllYArr addObject:tempYArr];
    }

}



//第一四象限
- (void)showFirstAndFouthQuardrant:(int)thd
{
    NSArray*areaNameArr=@[@"大路",@"大眼仔路",@"小路",@"小强路"];
    UIView*v=[_mainScrollView viewWithTag:10000+thd];
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
    lineChart.xLineDataArr = allXArr[thd];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    lineChart.valueArr = showAllYArr[thd];
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
    [_mainScrollView addSubview:ssView];
    [lineChart showAnimation];
    
    //
   
    UIScrollView*scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(ssView.frame.size.width-105, 20, 105, ssView.frame.size.height-20)];
    
    for (int i=0; i<nameArr.count; i++)
    {
        UILabel*colorLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 30*i+10, 10, 10)];
        colorLab.backgroundColor=colorArray[i];
        [scrollview addSubview:colorLab];
        UILabel*nameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 30*i, 80, 30)];
        nameLab.text=nameArr[i];
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
    [showAllYArr removeAllObjects];
    [nameArr removeAllObjects];
 
    for (int i=0; i<allnameArr.count; i++)
    {
        NSString*ii=[NSString stringWithFormat:@"%d",i];
        if ([ruleStr containsString:ii])
        {
            [nameArr addObject:allnameArr[i]];
        }

    }
    for (int i=0; i<allYArr.count; i++)
    {
        NSArray*arr=allYArr[i];
        NSMutableArray*tempArr=[[NSMutableArray alloc]init];
        for (int j=0; j<arr.count; j++)
        {
             NSString*jj=[NSString stringWithFormat:@"%d",j];
            if ([ruleStr containsString:jj])
            {
                [tempArr addObject:arr[j]];
            }
        }
        [showAllYArr addObject:tempArr];
    }
    
    for (int i=0; i<allXArr.count;i++)
    {
        [self showFirstAndFouthQuardrant:i];
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
    if ([segue.identifier isEqualToString:@"show_timeResultVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}
@end
