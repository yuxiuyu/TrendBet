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
/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic,strong) NSTimer  *timer;

@end

@implementation TBKline_RMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_selectedTitle;
    //背景色
    self.view.backgroundColor = [UIColor lightGrayColor];

    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [self.view addSubview:self.assenblyView];
    [self addConstrains];
    [self configureData];

    //这句话必须要,否则拖动到两端会出现白屏
    self.automaticallyAdjustsScrollViewInsets = NO;
    //

    //socket请求
    //    [self useSocketIO];


    //soclet数据暂时用假数据替代
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(creatFakeSocketData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}

#pragma mark - Private Methods
- (void)addConstrains
{

    //初始为横屏
    self.navigationController.navigationBar.hidden = YES;
    [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);

    }];

}
- (void)configureData
{

    //=数据获取
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kData" ofType:@"plist"];
    NSArray *kDataArr = [NSArray arrayWithContentsOfFile:path];

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



#pragma mark - Socket请求
//- (void)useSocketIO
//{
//    [SIOSocket socketWithHost:@"socket地址" response:^(SIOSocket *socket) {
//        NSDictionary *dic = @{};//配置信息
//        [socket emit:@"login" args:@[dic]];
//        socket.onConnect = ^{
//
//            NSLog(@"连接成功");
//        };
//        [socket on:@"quote" callback:^(SIOParameterArray *args) {
//
//            //必须在主线程执行
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                NSArray *strArr = [args[0] componentsSeparatedByString:@","];
//                NSString *timestamp = strArr[1];
//                double newPrice = [strArr[2] doubleValue]/100000.0;
//                //socket数据处理
//                [[ZXSocketDataReformer sharedInstance] bulidNewKlineModelWithNewPrice:newPrice timestamp:[timestamp integerValue] volumn:@(100) dataArray:self.dataArray isFakeData:NO];
//                NSLog(@"socketData=%@",args);
//            });
//
//        }];
//    }];
//}
//socket 假数据
- (void)creatFakeSocketData
{
    KlineModel *model = self.dataArray[self.dataArray.count-2];
    int32_t highestPrice = model.highestPrice*100000;
    int32_t lowestPrice = model.lowestPrice*100000;
    CGFloat newPrice = (arc4random_uniform(highestPrice-lowestPrice)+lowestPrice)/100000.0;
    NSLog(@"%f",newPrice);
    NSInteger volumn = arc4random_uniform(100);
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    //socket数据处理
    [[ZXSocketDataReformer sharedInstance] bulidNewKlineModelWithNewPrice:newPrice timestamp:timestamp volumn:@(volumn) dataArray:self.dataArray isFakeData:NO];
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
        _assenblyView = [[ZXAssemblyView alloc] initWithDrawJustKline:YES];
        //带指标的初始化
        //        _assenblyView = [[ZXAssemblyView alloc] init];
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
@end
