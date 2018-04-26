//
//  TBNewRule_goNewsMonthViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 2018/4/26.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "TBNewRule_goNewsMonthViewController.h"
#import "ZXAssemblyView.h"
#import "Masonry.h"
@interface TBNewRule_goNewsMonthViewController ()<AssemblyViewDelegate,ZXSocketDataReformerDelegate>
/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *kDataArr;
@end

@implementation TBNewRule_goNewsMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titleStr;
    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [self.view addSubview:self.assenblyView];
    [self addConstrains];
    if([_titleStr containsString:@"连日结果"]){
        
        [self dealData];
        
    } else {
      
        [self configureData];
    }
   
    // Do any additional setup after loading the view.
}
-(void)dealData{
     [self showProgress:YES];
    NSMutableArray*tepKlineArr = [NSMutableArray arrayWithArray:_klineArr];
    NSArray*tepMonthKeyArray=[[Utils sharedInstance] orderArr:[_houseMonthDic allKeys] isArc:YES];
    int totalP = 0;
    for (int p=0; p<tepMonthKeyArray.count; p++) {
        
        NSString*key=tepMonthKeyArray[p];
        NSDictionary*daysDic=_houseMonthDic[key];
      
        
      
        NSArray*tepDayKeyArray=[[Utils sharedInstance] orderArr:[daysDic allKeys] isArc:YES];
        for (int k=0; k<tepDayKeyArray.count; k++) {
            
            NSDictionary*dic=daysDic[tepDayKeyArray[k]];
            //月里的日长连次
            NSMutableArray*xkeyArray=[[NSMutableArray alloc]initWithArray:[dic allKeys]];
            [xkeyArray removeObject:@"daycount"];
            NSArray*xtimeArr=[[Utils sharedInstance] orderArr:xkeyArray isArc:YES];
            for (int j=0; j<xtimeArr.count; j++)
            {
                NSArray*tparray=dic[xtimeArr[j]];
                // k线
                NSMutableArray*fiveArr=[[NSMutableArray alloc] initWithArray:tparray[14]];
                //                @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
                [fiveArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",totalP]];
                [fiveArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[3] intValue]]];
                [fiveArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d",totalP+[fiveArr[4] intValue]]];
                totalP += [fiveArr[1] intValue];
                [fiveArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",totalP]];
                [tepKlineArr addObject: [fiveArr componentsJoinedByString:@","]];
            }
        }
    }
     [self hidenProgress];
    _klineArr = tepKlineArr;
     [self configureData];
    
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
    NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:_klineArr currentRequestType:@"M1"];
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
        
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
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
