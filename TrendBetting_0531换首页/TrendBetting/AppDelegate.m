//
//  AppDelegate.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 16/12/28.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "AFNetworkReachabilityManager.h"
@interface AppDelegate ()
{
    NSUserDefaults*defaults;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    //获取资金策略数组
    [self initMoneyRule];
    //获取规则数组
    [self initRule];
    //获取组数组
    [self initGroupRule];
    //获取套利规则
    [self initArbitrageRule];
    defaults=[NSUserDefaults standardUserDefaults];
    ////区域选择
    if (![defaults objectForKey:SAVE_AREASELECT])
    {
        [defaults setObject:@"1|1|1|1" forKey:SAVE_AREASELECT];
    }
    ////下注提示选择
    if (![defaults objectForKey:SAVE_RBSELECT])
    {
        [defaults setObject:@"RB" forKey:SAVE_RBSELECT];
    }
    ////正向反向
//    if (![defaults objectForKey:SAVE_REVERSESELECT])
//    {
//        [defaults setObject:@"NO" forKey:SAVE_REVERSESELECT];
//    }
    ////返利基数
    if (![defaults objectForKey:SAVE_BackMoney])
    {
        [defaults setObject:@"8" forKey:SAVE_BackMoney];
    }
    /////长跳
    if (![defaults objectForKey:SAVE_GotwoCount])
    {
        [defaults setObject:@"4" forKey:SAVE_GotwoCount];
    }
    /////长连
    if (![defaults objectForKey:SAVE_GoCount])
    {
        [defaults setObject:@"4" forKey:SAVE_GoCount];
    }
     /////小二路
    if (![defaults objectForKey:SAVE_GoXiaoCount])
    {
        [defaults setObject:@"2" forKey:SAVE_GoXiaoCount];
    }
    /////文字长跳
    if (![defaults objectForKey:SAVE_wordGotwoCount])
    {
        [defaults setObject:@"3" forKey:SAVE_wordGotwoCount];
    }
    /////文字长连
    if (![defaults objectForKey:SAVE_wordGoCount])
    {
        [defaults setObject:@"3" forKey:SAVE_wordGoCount];
    }
    /////连月均线
    if (![defaults objectForKey:SAVE_dateSqrCount])
    {
        [defaults setObject:@"7" forKey:SAVE_dateSqrCount];
    }
    if (![defaults objectForKey:SAVE_dateSqrCount_1])
    {
        [defaults setObject:@"" forKey:SAVE_dateSqrCount_1];
    }
    if (![defaults objectForKey:SAVE_dateSqrCount_2])
    {
        [defaults setObject:@"" forKey:SAVE_dateSqrCount_2];
    }
    /////连日均线
    if (![defaults objectForKey:SAVE_dateDaySqrCount])
    {
        [defaults setObject:@"112" forKey:SAVE_dateDaySqrCount];
    }
    if (![defaults objectForKey:SAVE_dateDaySqrCount_1])
    {
        [defaults setObject:@"" forKey:SAVE_dateDaySqrCount_1];
    }
    if (![defaults objectForKey:SAVE_dateDaySqrCount_2])
    {
        [defaults setObject:@"" forKey:SAVE_dateDaySqrCount_2];
    }
    /////连句均线
    if (![defaults objectForKey:SAVE_dateTimeSqrCount])
    {
        [defaults setObject:@"784" forKey:SAVE_dateTimeSqrCount]; 
    }

    ////只看大路
    if (![defaults objectForKey:SAVE_isbigRoad])
    {
        [defaults setObject:@"0" forKey:SAVE_isbigRoad];
    }
    ////把把庄闲选择
    if (![defaults objectForKey:SAVE_isOnlyRBSelect])
    {
        [defaults setObject:@"0" forKey:SAVE_isOnlyRBSelect];
    }
    
    
    /////////////
    if (![defaults objectForKey:SAVE_TenBlodRule])
    {
        tenRuleModel*tenM=[[tenRuleModel alloc]init];
        [tenM initWithYes];
        NSData*data=[NSKeyedArchiver archivedDataWithRootObject:tenM];
        [defaults setObject:data forKey:SAVE_TenBlodRule];
    }
//    ////设置中可关闭／开启长跳的规则
//    if (![defaults objectForKey:SAVE_gotwoRule])
//    {
//       [defaults setObject:@"YES" forKey:SAVE_gotwoRule];
//    }
//    ////设置中可关闭／开启长连的规则
//    if (![defaults objectForKey:SAVE_goRule])
//    {
//       [defaults setObject:@"YES" forKey:SAVE_goRule];
//    }
//    ////设置中可关闭／开启小二路的规则
//    if (![defaults objectForKey:SAVE_xiaoRule])
//    {
//       [defaults setObject:@"YES" forKey:SAVE_xiaoRule];
//    }
//    ////设置中可关闭/开启一带不规则
//    if (![defaults objectForKey:SAVE_oneNORule])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_oneNORule];
//    }
//    ////设置中可关闭/开启不规则带一
//    if (![defaults objectForKey:SAVE_noRuleOne])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_noRuleOne];
//    }
//    ////设置中可关闭/开启一带规则
//    if (![defaults objectForKey:SAVE_oneRule])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_oneRule];
//    }
//    ////设置中可关闭／开启规则带一
//    if (![defaults objectForKey:SAVE_ruleOne])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_ruleOne];
//    }
//    ////设置中可关闭／开启平头规则
//    if (![defaults objectForKey:SAVE_sameRule])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_sameRule];
//    }
//    ////设置中可关闭／开启文字区域的规则
//    if (![defaults objectForKey:SAVE_wordRule])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_wordRule];
//    }
//    ////设置中可关闭／开启和暂停的规则
//    if (![defaults objectForKey:SAVE_TRule])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_TRule];
//    }
    
    
    ////设置中可关闭／开启 大路规则一列还是两列
//    if (![defaults objectForKey:SAVE_oneList])
//    {
        [defaults setObject:@"NO" forKey:SAVE_oneList];
//    }
//    ////设置中可关闭／开启正确的一带规则
//    if (![defaults objectForKey:SAVE_trueOneRule])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_trueOneRule];
//    }
//    ////设置中可关闭／开启正确的一带不规则
//    if (![defaults objectForKey:SAVE_trueOneNORule])
//    {
//        [defaults setObject:@"YES" forKey:SAVE_trueOneNORule];
//    }
    ////
    [self initKeyBoard];
    [self monitorNetworking];


    return YES;
}
//获取资金策略数组
-(void)initMoneyRule
{
    [Utils sharedInstance].moneyRuleArray=[[NSMutableArray alloc]initWithArray:[[Utils sharedInstance] readMoneyData:SAVE_MONEY_TXT]];
    if ([Utils sharedInstance].moneyRuleArray.count<=0)
    {
        NSDictionary*dic=@{@"number":@"1",
                           @"name":@"平倍数列",
                           @"moneyRule":@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"],//默认数组
                           @"isselected":@"YES"
                           };
        [[Utils sharedInstance].moneyRuleArray addObject:dic];
        [[Utils sharedInstance] saveData:nil saveArray:[Utils sharedInstance].moneyRuleArray filePathStr:SAVE_MONEY_TXT];
        [Utils sharedInstance].moneySelectedArray =dic[@"moneyRule"];
    }
    else
    {
        [[Utils sharedInstance] getSelectedMoneyArr];
    }

}
//获取规则数组
-(void)initRule
{
    [Utils sharedInstance].ruleArray=[[NSMutableArray alloc]initWithArray:[[Utils sharedInstance] readMoneyData:SAVE_RULE_TXT]];
    if ([Utils sharedInstance].ruleArray.count<=0)
    {
        NSDictionary*dic=@{@"number":@"1",
                           @"name":@"长连数列",
                           @"rule":@{@"BBB":@"BBBB"},//默认数据
                           @"selected":@"0123",
                           @"isCycle":@"YES"
                           };
        [[Utils sharedInstance].ruleArray addObject:dic];
        [[Utils sharedInstance] saveData:nil saveArray:[Utils sharedInstance].ruleArray filePathStr:SAVE_RULE_TXT];

    }


}
-(void)initGroupRule
{
    [Utils sharedInstance].groupArray=[[NSMutableArray alloc]initWithArray:[[Utils sharedInstance] readMoneyData:SAVE_Group_TXT]];
    if ([Utils sharedInstance].groupArray.count<=0)
    {
        NSDictionary*dic=@{ @"number":@"1",
                           @"name":@"长连数组",
                           @"rule":@[@{@"BBB":@"BBBB",@"isCycle":@"YES"}],//默认数据
                           @"selected":@"YES",//YES选中 NO  没选中
                           @"rbSelect":@"RB",
                           @"reverseSelect":@"YES"
                         };
        [[Utils sharedInstance].groupArray addObject:dic];
        [[Utils sharedInstance] saveData:nil saveArray:[Utils sharedInstance].groupArray filePathStr:SAVE_Group_TXT];
       
    }
}
-(void)initArbitrageRule
{
    [Utils sharedInstance].arbitrageRuleArray=[[NSMutableArray alloc]initWithArray:[[Utils sharedInstance] readMoneyData:SAVE_arbitrageRule]];
    [[Utils sharedInstance] getSelectarbitrageRuleArray];
//    if ([Utils sharedInstance].arbitrageRuleArray.count<=0)
//    {
//        NSDictionary*dic=@{ @"number":@"1",
//                            @"name":@"长连数组",
//                            @"rule":@[@{@"BBB":@"BBBB",@"isCycle":@"YES"}],//默认数据
//                            @"selected":@"YES",//YES选中 NO  没选中
//                            @"rbSelect":@"RB",
//                            @"reverseSelect":@"YES"
//                            };
//        [[Utils sharedInstance].groupArray addObject:dic];
//        [[Utils sharedInstance] saveData:nil saveArray:[Utils sharedInstance].groupArray filePathStr:SAVE_Group_TXT];
//
//    }
}
-(void)initKeyBoard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.preventShowingBottomBlankSpace = NO;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.shouldPlayInputClicks = YES;
    manager.shouldShowTextFieldPlaceholder = YES;
    manager.enableAutoToolbar = YES;
    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
    //    manager.shouldShowTextFieldPlaceholder = YES;
    //    manager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    
}
#pragma mark - ------------- 监测网络状态 -------------
- (void)monitorNetworking
{
    [Utils sharedInstance].isNetwork = YES;
    [Utils sharedInstance].isWifi = NO;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                 [Utils sharedInstance].isNetwork = YES;
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                 [Utils sharedInstance].isNetwork = NO;
                break;
            case 1:
            {
                 [Utils sharedInstance].isNetwork = YES;
                NSLog(@"GPRS网络");
                //发通知，带头搞事
                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"1" userInfo:nil];
            }
                break;
            case 2:
            {
                 [Utils sharedInstance].isNetwork = YES;
                 [Utils sharedInstance].isWifi = YES;
                NSLog(@"wifi网络");
                //发通知，搞事情
                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"2" userInfo:nil];
            }
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
             [Utils sharedInstance].isNetwork = YES;
            NSLog(@"有网");
            
        }else{
            [Utils sharedInstance].isNetwork = NO;
            NSLog(@"没网");
        }
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
