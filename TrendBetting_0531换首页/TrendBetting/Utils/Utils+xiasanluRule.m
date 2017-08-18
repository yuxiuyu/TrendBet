//
//  Utils+xiasanluRule.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/6/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+xiasanluRule.h"
#import "Utils+newRules.h"
@implementation Utils (xiasanluRule)
-(NSArray*)getNewFristArray:(NSArray*)listArray

{
    int TSumCount=0;
    int RSumCount=0;
    int BSumCount=0;
    NSMutableArray*newListArray=[[NSMutableArray alloc]init];
    
    NSMutableArray*secondPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*thirdPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*forthPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*fivePartArray=[[NSMutableArray alloc]init];
    //
    
    NSMutableArray*guessFristPartArray=[[NSMutableArray alloc]init];//文字
    NSMutableArray*guessSecondPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*guessThirdPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*guessForthPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*guessFivePartArray=[[NSMutableArray alloc]init];
    
    NSMutableArray*arrGuessSecondPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*allGuessArray=[[NSMutableArray alloc]init];
    
    
    for (int i=0; i<listArray.count; i++)
    {
        NSString*resultStr=[NSString stringWithFormat:@"%@",listArray[i]];
        if ([resultStr intValue]==12||[resultStr isEqualToString:@"T"])//和
        {
            resultStr=@"T";
            TSumCount++;
        }
        else
        {
            if ([resultStr intValue]==10||[resultStr isEqualToString:@"R"])
            {//庄
                resultStr=@"R";
                RSumCount++;
            }
            else if ([resultStr intValue]==11||[resultStr isEqualToString:@"B"])
            {//闲
                resultStr=@"B";
                BSumCount++;
            }
            
            ////////////////////
            if(secondPartArray.count>0)
            {
                
                NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[secondPartArray lastObject]];
                NSString*str=[NSString stringWithFormat:@"%@",[tempArray lastObject]];
                if ([str isEqualToString:resultStr])
                {
                    [tempArray addObject:resultStr];
                    [secondPartArray replaceObjectAtIndex:secondPartArray.count-1 withObject:tempArray];/////接着追加
                }
                else
                {
                    tempArray=[[NSMutableArray alloc]init];
                    [tempArray addObject:resultStr];
                    [secondPartArray addObject:tempArray];
                }
            }
            else
            {
                NSMutableArray*tempArray=[[NSMutableArray alloc]init];
                [tempArray addObject:resultStr];
                [secondPartArray addObject:tempArray];
            }
            
            /////
            thirdPartArray=[self setNewData:secondPartArray startCount:1 dataArray:thirdPartArray];
            forthPartArray=[self setNewData:secondPartArray startCount:2 dataArray:forthPartArray];
            fivePartArray=[self  setNewData:secondPartArray startCount:3 dataArray:fivePartArray];
            
            ////////////猜的数据
            
            [arrGuessSecondPartArray addObject:[self seacherNewsRule:secondPartArray arrGuessPartArray:arrGuessSecondPartArray.count>0?[arrGuessSecondPartArray lastObject]:nil]];
            [guessThirdPartArray addObject:[self seacherSpecRule:thirdPartArray resultArray:[guessThirdPartArray lastObject] secondPartArray:secondPartArray myTag:1]];
            [guessForthPartArray addObject:[self seacherSpecRule:forthPartArray resultArray:[guessForthPartArray lastObject] secondPartArray:secondPartArray myTag:2]];
            [guessFivePartArray addObject:[self seacherSpecRule:fivePartArray resultArray:[guessFivePartArray lastObject] secondPartArray:secondPartArray myTag:3]];
            
            [guessSecondPartArray addObject: [[Utils sharedInstance] getGuessValue:[arrGuessSecondPartArray lastObject] partArray:secondPartArray fristPartArray:secondPartArray myTag:0]];
            
        }
        
        [newListArray addObject:resultStr];
        [guessFristPartArray addObject:[[Utils sharedInstance] searchFirstRule:newListArray]];
        
        
        
        //
        NSString*str=@"";
        //yxy add 2017/07/17 新加把把下庄闲
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect] intValue]==1) {
            str=@"R";
            [allGuessArray addObject:str];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect] intValue]==2) {
            str=@"B";
            [allGuessArray addObject:str];
        }
        //yxy add 2017/07/17
        else
        {
            NSString*secGuessLastStr=[guessSecondPartArray lastObject];
            if([[newListArray lastObject] isEqualToString:@"T"]&&secGuessLastStr.length>0){
                [guessSecondPartArray replaceObjectAtIndex:guessSecondPartArray.count-1 withObject:@"stop"];
            }
            else{
                secGuessLastStr=[guessSecondPartArray lastObject];
                if (secGuessLastStr.length>0)
                {
                    NSString*guessStr2=[[guessThirdPartArray lastObject] lastObject];
                    NSString*guessStr3=[[guessForthPartArray lastObject] lastObject];
                    NSString*guessStr4=[[guessFivePartArray lastObject] lastObject];
                    
                    NSMutableArray*guessArr=[[NSMutableArray alloc]initWithArray:@[[[guessFristPartArray lastObject] lastObject],secGuessLastStr,guessStr2,guessStr3,guessStr4]];
                    str=[[Utils sharedInstance] setGuessValue:guessArr isLength:NO];
                }
            }
            [allGuessArray addObject:str];
        }
        
        
    }
    ///////判断猜对猜错的个数  和收益
    NSArray* resultArray;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isbigRoad] intValue]==1)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect] intValue]==0)
        {
            NSMutableArray*tepguessSecondPartArray=[[NSMutableArray alloc]initWithArray:guessSecondPartArray];
            for (int i=0; i<tepguessSecondPartArray.count; i++) {
                if ([tepguessSecondPartArray[i] isEqualToString:@"stop"])
                {
                    [tepguessSecondPartArray replaceObjectAtIndex:i withObject:@""];
                }
            }
            
            resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:newListArray allGuessArray:tepguessSecondPartArray];
        }
        else
        {
            resultArray=[[Utils sharedInstance] xiasanluJudgeGuessRightandWrong:newListArray allGuessArray:allGuessArray];
        }
        
    }
    else
    {
        resultArray=[[Utils sharedInstance]xiasanluJudgeGuessRightandWrong:newListArray allGuessArray:allGuessArray];
    }
    
    //    NSArray*resultArray=[self xiasanluJudgeGuessRightandWrong:newListArray allGuessArray:allGuessArray];
    NSArray*array= @[[NSString stringWithFormat:@"%d",RSumCount],//R总数
                     [NSString stringWithFormat:@"%d",BSumCount],//B总数
                     [NSString stringWithFormat:@"%d",TSumCount],//T总数
                     [NSString stringWithFormat:@"%@",resultArray[0]],//1、猜错的数量
                     [NSString stringWithFormat:@"%@",resultArray[1]],//2、猜对的数量
                     [NSString stringWithFormat:@"%@",resultArray[2]],//3、收益
                     [NSString stringWithFormat:@"%ld",newListArray.count],//
                     [NSString stringWithFormat:@"%@",resultArray[6]],//下一局下注的钱
                     [NSString stringWithFormat:@"%@",resultArray[7]],//抽水的钱
                     newListArray,//r总数
                     resultArray[3],//每一局赢或输钱的变动
                     resultArray[4]//每一局总的钱的变动
                     ];
    
    return array;
}

#pragma mark------搜索（ 三 四 五）区域  个数 区域的趋势
-(NSArray*)seacherSpecRule:(NSArray*)fristPartArray  resultArray:(NSArray*)resultArray secondPartArray:(NSArray*)secondPartArray myTag:(NSInteger)myTag{
    //    NSInteger thdCount=0;
    NSString*guessStr=@"";
    NSString*backguessStr=@"";
    NSString*nameStr=@"";
    NSInteger allcount = fristPartArray.count;
    NSArray*lastArray=[fristPartArray lastObject];
    if (resultArray&&[resultArray[0] length]>0)
    {
        NSString*lastGuessStr=resultArray[1];
        if ([lastGuessStr isEqualToString:[lastArray lastObject]]
            
            
            ||(([[[resultArray firstObject] substringToIndex:2] isEqualToString:@"规则"]
                ||[[[resultArray firstObject] substringToIndex:3] isEqualToString:@"一带规"])
               &&![lastGuessStr isEqualToString:[lastArray lastObject]]
               &&lastArray.count>1
               &&[fristPartArray[allcount-2] count]==1)
            
            ||(([[[resultArray firstObject] substringToIndex:3] isEqualToString:@"一带不"]
                ||[[[resultArray firstObject] substringToIndex:3] isEqualToString:@"不规则"])
               &&![lastGuessStr isEqualToString:[lastArray lastObject]]
               &&lastArray.count==1
               &&[fristPartArray[allcount-2] count]>1))
        {
            nameStr=[resultArray firstObject];
            if ([nameStr containsString:@"长连"])
            {
                if (fristPartArray.count>1&&lastArray.count!=[fristPartArray[allcount-2] count]) {//判断可能存在小几路
                    guessStr=resultArray[1];
                    nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:2],[[nameStr substringFromIndex:2] intValue]+1];
                    backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                    return @[nameStr,guessStr,backguessStr];
                }
            }
            else if([nameStr containsString:@"小"])
            {
                NSArray*lastSecArray=fristPartArray[allcount-2];
                NSLog(@"%ld  %@",[nameStr rangeOfString:@"路"].location,[nameStr substringToIndex:[nameStr rangeOfString:@"路"].location+1]);
                nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:[nameStr rangeOfString:@"路"].location+1],[[nameStr substringFromIndex:[nameStr rangeOfString:@"路"].location+1] intValue]+1];
                guessStr=resultArray[1];
                if (lastArray.count==lastSecArray.count)
                {
                    guessStr=[lastSecArray lastObject];
                }
                backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                return @[nameStr,guessStr,backguessStr];
            }
            else if([nameStr containsString:@"长跳"])
            {
                NSArray*lastSecArray=fristPartArray[allcount-2];
                nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:2],[[nameStr substringFromIndex:2] intValue]+1];
                guessStr=resultArray[1];
                if (lastArray.count==lastSecArray.count)
                {
                    guessStr=[lastSecArray lastObject];
                }
                backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                return @[nameStr,guessStr,backguessStr];
            }
            else if([[nameStr substringToIndex:3] isEqualToString:@"规则带"]||[[nameStr substringToIndex:3] isEqualToString:@"一带规"])
            {
                //yxy add
                int a=[[nameStr substringFromIndex:4] intValue]+1;
                NSInteger b=[fristPartArray[allcount-1] count]+[fristPartArray[allcount-2] count]+[fristPartArray[allcount-3] count]+[fristPartArray[allcount-4] count];
                if (a>b) {
                    ///yxy add
                    NSArray*lastSecArray=fristPartArray[allcount-2];
                    NSArray*lastThirdArray=fristPartArray[allcount-3];
                    nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:4],a];
                    guessStr=resultArray[1];
                    if (lastArray.count==lastThirdArray.count)
                    {
                        guessStr=[lastSecArray lastObject];
                    }
                    else if (lastArray.count>[fristPartArray[allcount-3] count])
                    {
                        nameStr=[nameStr stringByReplacingOccurrencesOfString:@"规则" withString:@"不规则"];
                        guessStr=[lastArray lastObject];
                    }
                    backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                    return @[nameStr,guessStr,backguessStr];
                }//yxy add
               
            }
            else
            {
                
                NSArray*lastSecArray=fristPartArray[allcount-2];
                guessStr=resultArray[1];
                nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:5],[[nameStr substringFromIndex:5] intValue]+1];
                if (lastSecArray.count>1)
                {
                    
                    guessStr=[lastSecArray lastObject];
                    
                }
                backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                return @[nameStr,guessStr,backguessStr];
                
                
            }
        }
    }
    
    /////
    NSMutableArray*yarray=[[NSMutableArray alloc] initWithArray:[self duodai:fristPartArray]];
    backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:[yarray lastObject] myTag:myTag];
    [yarray addObject:backguessStr];
    return yarray;
}
-(NSArray*)duodai:(NSArray*)fristPartArray{
    NSString*guessStr=@"";
    NSString*nameStr=@"";
    NSInteger allCount = fristPartArray.count-1;
    NSArray*lastArray=[fristPartArray lastObject];
    if(fristPartArray.count>=4)
    {
        NSArray*array=[self noRule:fristPartArray];
        if ([array[0] length]>0) {
            return array;
        }
    }
    if(fristPartArray.count>=2)
    {
        NSInteger same=1;
        NSInteger sumcount=lastArray.count;
        for (NSInteger i=allCount-1; i>=0; i--)
        {
            if([fristPartArray[i] count]==lastArray.count)//相等
            {
                same++;
                sumcount=sumcount+[fristPartArray[i] count];
            }
            else////相等中断
            {
                break;
            }
        }
        NSArray*lastSecArray=fristPartArray[allCount-1];
        if (lastArray.count==1&&same>=[[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GotwoCount] intValue])
        {
            guessStr=[lastSecArray lastObject];
            nameStr=[NSString stringWithFormat:@"长跳%ld",sumcount];
        }
        else if(lastArray.count>=2&&same>=2)
        {
            if (lastArray.count==2)
            {
                if (same>=[[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GoXiaoCount] intValue]) {
                    guessStr=[lastSecArray lastObject];
                    nameStr=[NSString stringWithFormat:@"小%ld路%ld",lastArray.count,sumcount];
                }
            }
            else
            {
                NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
                if ([[defaults objectForKey:SAVE_sameRule] isEqualToString:@"YES"]) {
                    guessStr=[lastSecArray lastObject];
                    nameStr=[NSString stringWithFormat:@"小%ld路%ld",lastArray.count,sumcount];
                }
            }
        }
    }
    if (fristPartArray.count>=1&&nameStr.length<=0&&lastArray.count>=[[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GoCount] intValue])
    {
        nameStr=[NSString stringWithFormat:@"长连%ld",lastArray.count];
        guessStr=[lastArray lastObject];
    }
    return @[nameStr,guessStr];
}
-(NSArray*)noRule:(NSArray*)fristPartArray
{
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    NSString*guessStr=@"";
    NSString*nameStr=@"";
    NSInteger allCount = fristPartArray.count-1;

    NSInteger a=[fristPartArray[allCount] count]+[fristPartArray[allCount-1] count]+[fristPartArray[allCount-2] count]+[fristPartArray[allCount-3] count];
    if ([fristPartArray[allCount] count]>=2&&[fristPartArray[allCount-1] count]==1&&[fristPartArray[allCount-2] count]>=2&&[fristPartArray[allCount-3] count]==1)
    {
//        nameStr=@"一带不规则";
//        guessStr=[fristPartArray[allCount] lastObject];
         if ([[defaults objectForKey:SAVE_oneRule] isEqualToString:@"YES"]) {
            if ([fristPartArray[allCount] count]==[fristPartArray[allCount-2] count])
            {
                nameStr=@"一带规则";
                guessStr=[fristPartArray[allCount-1] lastObject];
                nameStr=[NSString stringWithFormat:@"%@%ld",nameStr,a];
                return @[nameStr,guessStr];
            }
         }
//        nameStr=[NSString stringWithFormat:@"%@%ld",nameStr,a];
//        return @[nameStr,guessStr];
    }
    else if ([fristPartArray[allCount] count]==1&&[fristPartArray[allCount-1] count]>=2&&[fristPartArray[allCount-2] count]==1&&[fristPartArray[allCount-3] count]>=2)
    {
         if ([[defaults objectForKey:SAVE_noRuleOne] isEqualToString:@"YES"]) {
            nameStr=@"不规则带一";
            guessStr=[fristPartArray[allCount-1] lastObject];
           
         }
        if ([fristPartArray[allCount-1] count]==[fristPartArray[allCount-3] count])
        {
             if ([[defaults objectForKey:SAVE_ruleOne] isEqualToString:@"YES"]) {
                nameStr=@"规则带一";
                guessStr=[fristPartArray[allCount-1] lastObject];
             }
        }
        // yxy add
        if (fristPartArray.count>4&&[fristPartArray[allCount-4] count]==1)
        {
            if ([[defaults objectForKey:SAVE_oneNORule] isEqualToString:@"YES"]) {
                nameStr=@"一带不规则";
                guessStr=[fristPartArray[allCount] lastObject];
                a=a+1;
            }
        }
        if (nameStr.length>0)
        {
            nameStr=[NSString stringWithFormat:@"%@%ld",nameStr,a];
            return @[nameStr,guessStr];
        }
      
        //yxy add
      
    }
    
    return @[nameStr,guessStr];
    
}
//-(NSArray*)noRule:(NSArray*)fristPartArray  resultArray:(NSArray*)resultArray isyxy:(BOOL)isyxy
//{
//    //不规则
//    NSString*guessStr=@"";
//    NSString*nameStr=@"";
//    NSInteger allCount = fristPartArray.count-1;
//    NSArray*lastArray=[fristPartArray lastObject];
//
//    int compare=4;
//    if(allCount<3)
//    {
//        return @[guessStr,nameStr];
//    }
//    NSInteger tepC=allCount;
//    int same=1;
//    NSInteger sumcount=lastArray.count;
//    NSArray*lastSecArray=fristPartArray[allCount-1];
//    //
//    if(lastArray.count==1)
//    {
//        same++;
//        sumcount++;
//        tepC--;
//        compare--;
//        if(lastSecArray.count==1)
//        {
//            tepC--;
//            same++;
//            sumcount++;
//            tepC--;
//            compare=5;
//        }
//    }
//
//    for (NSInteger i=tepC; i>=0; i--)
//    {
//
//            if(i%2==tepC%2)
//            {
//                if([fristPartArray[i] count]>1)
//                {
//                     same++;
//                     sumcount=sumcount+[fristPartArray[i] count];
//                }
//                else
//                {
//                    if (same>=compare)
//                    {
//                        guessStr=[lastSecArray lastObject];
//                        nameStr=[NSString stringWithFormat:@"一带不规则%ld",sumcount];
//                    }
//                   break;
//
//                }
//            }
//            else
//            {
//                if([fristPartArray[i] count]==1)
//                {
//                     same++;
//                     sumcount=sumcount+[fristPartArray[i] count];
//                }
//                else
//                {
//                    if (same>=compare)
//                    {
//                        guessStr=[lastSecArray lastObject];
//                        nameStr=[NSString stringWithFormat:@"一带不规则%ld",sumcount];
//                    }
//                    break;
//
//                }
//
//            }
//        }
//    return @[guessStr,nameStr];
//
//}
//搜索第一区域的规则
-(NSArray*)searchFirstRule:(NSArray*)listArray
{
    NSString*guessStr=@"";
    NSString*nameStr=@"";
    NSInteger allCount=listArray.count;
    if (allCount>17)
    {
        
        
        NSInteger thd=allCount%6;
        NSUInteger columThd=allCount/6;
        NSString*lastStr=listArray[6*(columThd-1)+thd];
        NSString*secLastStr=listArray[6*(columThd-2)+thd];
        if (![lastStr isEqualToString:@"T"]&&![secLastStr isEqualToString:@"T"])
        {
            NSInteger goCount=2;
            BOOL isGO=NO;//长跳
            guessStr=secLastStr;
            if ([lastStr isEqualToString:secLastStr])
            {
                isGO=YES;//长联
            }
            for (NSInteger i=columThd-3; i>-1; i--)
            {
                NSString*tepStr=listArray[6*i+thd];
                if (isGO)
                {
                    if([guessStr isEqualToString:tepStr])
                    {
                        goCount++;
                    }
                    else
                    {
                        break;
                    }
                }
                else
                {
                    if (![guessStr isEqualToString:tepStr]&&![tepStr isEqualToString:@"T"])
                    {
                        goCount++;
                        guessStr=tepStr;
                    }
                    else
                    {
                        break;
                    }
                }
            }
            guessStr=@"";
            if (goCount>=3)
            {
                guessStr=secLastStr;
                nameStr=[NSString stringWithFormat:@"%@%ld",isGO?@"长连":@"长跳",goCount];
            }
            
        }
        
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_wordRule] isEqualToString:@"NO"])
    {
        return @[@"",@""];
    }
    
    return @[nameStr,guessStr];
}


/*
 return Array
 1、猜错的数量
 2、猜对的数量
 3、收益
 4、每一局赢或输钱的变动
 5、每一局总的钱的变动
 6、下一局下注的钱
 7、抽水的钱
 */
-(NSArray*)xiasanluJudgeGuessRightandWrong:(NSArray*)listArray allGuessArray:(NSArray*)allGuessArray
{
    //    NSArray*moneyArr=@[@"1",@"5",@"2"];
    NSInteger guessNo=0;//猜错的总数
    NSInteger guessYes=0;//猜对的总数
    NSInteger goGuessYes=0;//连续猜对的次数
    float totalMoney=0;
    NSInteger Tcount=0;
    float reduceMoney=0.0;//抽水的钱
    float backMoney=0.0;//返利的钱
    float nextMoney=[[Utils sharedInstance].moneySelectedArray[0] floatValue];//下一次下注的钱
    NSMutableDictionary*changeDic=[[NSMutableDictionary alloc]init];
    NSMutableDictionary*changeTotalDic=[[NSMutableDictionary alloc]init];
    for (int i=0; i<listArray.count; i++)
    {
        NSString*str=listArray[i];
        if (![str isEqualToString:@"T"])
        {
            //            if (i-Tcount>2) //yxy add 2017/07/17 新加把把下庄闲
            if (i-Tcount>0)
            {
                NSString*guessStr=allGuessArray[i-1];
                if (guessStr.length>0)
                {
                    NSInteger thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    nextMoney = [[Utils sharedInstance].moneySelectedArray[thd] floatValue];
                    backMoney=backMoney+nextMoney*([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_BackMoney] intValue]/1000.0);
                    if ([str isEqualToString:guessStr])
                    {
                        totalMoney=[guessStr isEqualToString:@"R"]?totalMoney+(1-Reduce_Money)*nextMoney:totalMoney+nextMoney ;
                        guessYes++;
                        goGuessYes++;
                        
                        reduceMoney+=[guessStr isEqualToString:@"R"]?Reduce_Money*nextMoney:0;
                        [changeDic setObject:[guessStr isEqualToString:@"R"]?[NSString stringWithFormat:@"+%0.2f",(1-Reduce_Money)*nextMoney]:[NSString stringWithFormat:@"+%0.2f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                        
                    }
                    else
                    {
                        goGuessYes=0;
                        totalMoney=totalMoney-nextMoney;
                        guessNo++;
                        
                        [changeDic setObject:[NSString stringWithFormat:@"-%0.2f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                        
                    }
                    thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    nextMoney=[[Utils sharedInstance].moneySelectedArray[thd] floatValue];
                    
                    [changeTotalDic setObject:[NSString stringWithFormat:@"%0.2f",totalMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                }
                else
                {
                    goGuessYes=0;//连续猜对的次数
                    NSInteger thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    nextMoney=[[Utils sharedInstance].moneySelectedArray[thd] floatValue];
                }
                
            }
            
        }
        else
        {
            Tcount++;
        }
    }
    return @[[NSString stringWithFormat:@"%ld",guessNo],
             [NSString stringWithFormat:@"%ld",guessYes],
             [NSString stringWithFormat:@"%0.2f",totalMoney],
             changeDic,
             changeTotalDic,
             [NSString stringWithFormat:@"%0.2f",nextMoney],
             [NSString stringWithFormat:@"%0.2f",reduceMoney],
             [NSString stringWithFormat:@"%0.3f",backMoney],
             [NSString stringWithFormat:@"%ld",goGuessYes]
             ];
    
}

@end
