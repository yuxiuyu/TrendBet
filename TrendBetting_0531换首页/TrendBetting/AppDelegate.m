//
//  AppDelegate.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 16/12/28.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()

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
    ////区域选择
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_AREASELECT])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1|1|1|1" forKey:SAVE_AREASELECT];
    }
    ////下注提示选择
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RBSELECT])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"RB" forKey:SAVE_RBSELECT];
    }
    ////正向反向
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_REVERSESELECT])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:SAVE_REVERSESELECT];
    }
    ////返利基数
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_BackMoney])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:SAVE_BackMoney];
    }
    /////长跳
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GotwoCount])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:SAVE_GotwoCount];
    }
    /////长连
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GoCount])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:SAVE_GoCount];
    }
     /////小二路
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GoXiaoCount])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:SAVE_GoXiaoCount];
    }
    ////只看大路
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isbigRoad])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:SAVE_isbigRoad];
    }
    ////把把庄闲选择
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:SAVE_isOnlyRBSelect];
    }
    ////
    [self initKeyBoard];


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
