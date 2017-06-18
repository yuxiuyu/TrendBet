//
//  Utils+xiasanluRule.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/6/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+xiasanluRule.h"

@implementation Utils (xiasanluRule)
#pragma mark------搜索（一 三 四 五）区域  个数 区域的趋势
-(NSArray*)seacherSpecRule:(NSArray*)fristPartArray  resultArray:(NSArray*)resultArray{
//    NSInteger thdCount=0;
    NSString*guessStr=@"";
    NSString*nameStr=@"";
    NSInteger allcount = fristPartArray.count;
    NSArray*lastArray=[fristPartArray lastObject];
    if (resultArray&&[resultArray[0] length]>0)
    {
        
        if ([[resultArray lastObject] isEqualToString:[lastArray lastObject]]||[[resultArray lastObject] isEqualToString:@""])
        {
            nameStr=[resultArray firstObject];
            if ([nameStr containsString:@"长连"])
            {
                guessStr=[resultArray lastObject];
                nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:2],[[nameStr substringFromIndex:2] intValue]+1];
                return @[nameStr,guessStr];
                
            }
            else if([nameStr containsString:@"小"])
            {
                NSArray*lastSecArray=fristPartArray[allcount-2];
                NSLog(@"%ld  %@",[nameStr rangeOfString:@"路"].location,[nameStr substringToIndex:[nameStr rangeOfString:@"路"].location+1]);
                 nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:[nameStr rangeOfString:@"路"].location+1],[[nameStr substringFromIndex:[nameStr rangeOfString:@"路"].location+1] intValue]+1];
                 guessStr=[resultArray lastObject];
                if (lastArray.count==lastSecArray.count)
                {
                    guessStr=[lastSecArray lastObject];
                }
                 return @[nameStr,guessStr];
            }
            else if([nameStr containsString:@"长跳"])
            {
                NSArray*lastSecArray=fristPartArray[allcount-2];
                nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:2],[[nameStr substringFromIndex:2] intValue]+1];
                guessStr=[resultArray lastObject];
                if (lastArray.count==lastSecArray.count)
                {
                    guessStr=[lastSecArray lastObject];
                }
                return @[nameStr,guessStr];
            }
            else
            {
                if (lastArray.count==1)
                {
                    NSArray*lastSecArray=fristPartArray[allcount-2];
                     guessStr=[resultArray lastObject];
                     nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:4],[[nameStr substringFromIndex:4] intValue]+1];
                    if (lastSecArray.count>1)
                    {
                       
                        guessStr=[lastSecArray lastObject];
                        
                    }
                    return @[nameStr,guessStr];
                    
                }
                else if(lastArray.count>2)
                {
                    nameStr=[NSString stringWithFormat:@"%@%d",[nameStr substringToIndex:4],[[nameStr substringFromIndex:4] intValue]+1];
                    guessStr=@"";
                    return @[nameStr,guessStr];
                }
            }
        }
    }

    /////
        NSInteger thdCount=0;
        if (lastArray.count==1&&fristPartArray.count>=4)//最后一个等于1
        {
            NSInteger yxyTag=0;//0 长跳 1多带
            bool isLast=YES;
            for (NSInteger i=allcount-2; i>=allcount-4; i--)
            {
                NSArray*array=fristPartArray[i];
                if (i==allcount-2)
                {
                    yxyTag=array.count==1?0:1;
                }
                else
                {
                    if (yxyTag==0)
                    {
                        if (array.count!=1)
                        {
                            isLast=NO;
                        }
                    }
                    else
                    {
                        if ((i==allcount-3&&array.count!=1)||(i==allcount-4&&array.count<2))
                        {
                            isLast=NO;
                        }
                    }
                }
            }
        
            if (isLast)
            {
                guessStr=[fristPartArray[allcount-2] lastObject];
                nameStr=yxyTag==0?@"长跳":@"不规则带一";
                thdCount=allcount-4;
                guessStr=[fristPartArray[allcount-2] lastObject];
                if (yxyTag==1&&fristPartArray.count>4&&[fristPartArray[allcount-5] count]==1)
                {
                    nameStr=@"一带不规则";
                    thdCount=allcount-5;
                }
                
            }
        }
        else if(lastArray.count==2&&fristPartArray.count>=2)//最后一个等于2
        {
            NSArray*lastSecArray=fristPartArray[allcount-2];
            if (lastSecArray.count==2)
            {
                guessStr=[lastSecArray lastObject];
                nameStr=[NSString stringWithFormat:@"小%ld路",lastSecArray.count];
                thdCount=allcount-2;

            }
            
        }
        else if(lastArray.count>2)
        {
            if (lastArray.count>3)
            {
                 guessStr=[lastArray lastObject];
                 nameStr=@"长连";
                 thdCount=allcount-1;
            }
            
            
            if(fristPartArray.count>1)
            {
                NSArray*lastSecArray=fristPartArray[allcount-2];
                if (lastSecArray.count==lastArray.count)
                {
                    guessStr=[lastSecArray lastObject];
                    nameStr=[NSString stringWithFormat:@"小%ld路",lastSecArray.count];
                    thdCount=allcount-2;
                }

            }
        }
//    }

    
    
//        if (myTag>0&&guessStr.length>0)
//        {
//            guessStr=[self backRuleSeacher:jiafristPartArray ruleStr:guessStr myTag:myTag];
//        }
        NSInteger a=0;
        if (guessStr.length>0)
        {
            for (NSInteger i=thdCount; i<allcount; i++)
            {
                a=a+[fristPartArray[i] count];
            }
            nameStr=[NSString stringWithFormat:@"%@%ld",nameStr,a];
        }
    

    return @[nameStr,guessStr];
}
//搜索第一区域的规则
-(NSArray*)searchFirstRule:(NSArray*)listArray
{
    NSString*guessStr=@"";
    NSString*nameStr=@"";
    NSInteger allCount=listArray.count;
    if (allCount>17)
    {
       
        NSInteger goCount=2;
        NSInteger thd=allCount%6;
        NSUInteger columThd=allCount/6;
        NSString*lastStr=listArray[6*(columThd-1)+thd];
        NSString*secLastStr=listArray[6*(columThd-2)+thd];
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
                if (![guessStr isEqualToString:tepStr])
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
        if (goCount>=3&&![guessStr isEqualToString:@"T"])
        {
            guessStr=secLastStr;
            nameStr=[NSString stringWithFormat:@"%@%ld",isGO?@"长连":@"长跳",goCount];
        }
        else
        {
            guessStr=@"";
            nameStr=@"";
        }
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
    NSArray*moneyArr=@[@"1",@"5",@"2"];
    NSInteger guessNo=0;//猜错的总数
    NSInteger guessYes=0;//猜对的总数
    NSInteger goGuessYes=0;//连续猜对的次数
    float totalMoney=0;
    NSInteger Tcount=0;
    float reduceMoney=0.0;//抽水的钱
    float backMoney=0.0;//返利的钱
    float nextMoney=[moneyArr[0] floatValue];//下一次下注的钱
    NSMutableDictionary*changeDic=[[NSMutableDictionary alloc]init];
    NSMutableDictionary*changeTotalDic=[[NSMutableDictionary alloc]init];
    for (int i=0; i<listArray.count; i++)
    {
        NSString*str=listArray[i];
        if (![str isEqualToString:@"T"])
        {
            if (i-Tcount>2)
            {
                NSString*guessStr=allGuessArray[i-Tcount-1];
                if (guessStr.length>0)
                {
//                    nextMoney = [moneyArr[goGuessYes%moneyArr.count] floatValue];
                     NSInteger thd=goGuessYes>moneyArr.count-1?moneyArr.count-1:goGuessYes%moneyArr.count;
                     nextMoney = [moneyArr[thd] floatValue];
                    backMoney=backMoney+nextMoney*([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_BackMoney] intValue]/1000.0);
                    if ([str isEqualToString:guessStr])
                    {
                        totalMoney=[guessStr isEqualToString:@"R"]?totalMoney+(1-Reduce_Money)*nextMoney:totalMoney+nextMoney ;
                        guessYes++;
                        goGuessYes++;
                        
                        reduceMoney+=[guessStr isEqualToString:@"R"]?Reduce_Money*nextMoney:0;
                        [changeDic setObject:[guessStr isEqualToString:@"R"]?[NSString stringWithFormat:@"+%0.2f",(1-Reduce_Money)*nextMoney]:[NSString stringWithFormat:@"+%0.2f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
//                        nextMoney=[[Utils sharedInstance].moneySelectedArray[goGuessYes%moneyArr.count] floatValue];
                    }
                    else
                    {
                        goGuessYes=0;
                        totalMoney=totalMoney-nextMoney;
                        guessNo++;
                        
                        [changeDic setObject:[NSString stringWithFormat:@"-%0.2f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
//                        nextMoney=[[Utils sharedInstance].moneySelectedArray[goGuessYes%moneyArr.count] floatValue];
                    }
                    thd=goGuessYes>moneyArr.count-1?moneyArr.count-1:goGuessYes%moneyArr.count;
                    nextMoney = [moneyArr[thd] floatValue];
                    
                    [changeTotalDic setObject:[NSString stringWithFormat:@"%0.2f",totalMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                }
                else
                {
                    goGuessYes=0;//连续猜对的次数
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
             [NSString stringWithFormat:@"%0.3f",backMoney]
             ];
    
}

@end
