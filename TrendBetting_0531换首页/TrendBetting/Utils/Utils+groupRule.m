//
//  Utils+groupRule.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+groupRule.h"

@implementation Utils (groupRule)





-(NSArray*)getGroupFristArray:(NSArray*)listArray
{
    int TSumCount=0;
    int RSumCount=0;
    int BSumCount=0;
    NSMutableArray*newListArray=[[NSMutableArray alloc]init];
    
    NSMutableArray*fristPartArray=[[NSMutableArray alloc]init];

    //
    NSString*listFristStr=@"";
    NSString*listThirdStr=@"";
    NSString*listForthStr=@"";
    NSString*listFiveStr =@"";
    //
    NSMutableArray*guessFristPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*guessThirdPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*guessForthPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*guessFivePartArray =[[NSMutableArray alloc]init];
    
    for (int i=0; i<listArray.count; i++)
    {
        NSString*resultStr=listArray[i];
        if ([resultStr intValue]==12)//和
        {
            resultStr=@"T";
            TSumCount++;
        }
        else
        {
            if ([resultStr intValue]==10)
            {//庄
                resultStr=@"R";
                RSumCount++;
            }
            else if ([resultStr intValue]==11)
            {//闲
                resultStr=@"B";
                BSumCount++;
            }
           
           ////////////////////
            if(fristPartArray.count>0)
            {
                
                NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[fristPartArray lastObject]];
                NSString*str=[NSString stringWithFormat:@"%@",[tempArray lastObject]];
                if ([str isEqualToString:resultStr])
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
            
            /////
            listFristStr=[NSString stringWithFormat:@"%@%@",listFristStr,resultStr];
            listThirdStr=[self addListPartData:fristPartArray startCount:1 listDataStr:listThirdStr];
            listForthStr=[self addListPartData:fristPartArray startCount:2 listDataStr:listForthStr];
            listFiveStr =[self addListPartData:fristPartArray startCount:3 listDataStr:listFiveStr];
            
            ////////////猜的数据
            [guessFristPartArray addObject:[self seacherGroupRule:fristPartArray listStr:listFristStr myTag:0]];
            [guessThirdPartArray addObject:[self seacherGroupRule:fristPartArray listStr:listThirdStr myTag:1]];
            [guessForthPartArray addObject:[self seacherGroupRule:fristPartArray listStr:listForthStr myTag:2]];
            [guessFivePartArray  addObject:[self seacherGroupRule:fristPartArray listStr:listFiveStr myTag:3]];

        }
         [newListArray addObject:resultStr];

    }
       ///////判断猜对猜错的个数  和收益
       NSArray*resultArray1=[self judgeGroupGuessRightandWrong:newListArray allGuessArray:guessFristPartArray];
       NSArray*resultArray2=[self judgeGroupGuessRightandWrong:newListArray allGuessArray:guessThirdPartArray];
       NSArray*resultArray3=[self judgeGroupGuessRightandWrong:newListArray allGuessArray:guessForthPartArray];
       NSArray*resultArray4=[self judgeGroupGuessRightandWrong:newListArray allGuessArray:guessFivePartArray];
       NSArray*array= @[
                     resultArray1,//每一局总的钱的变动
                     resultArray2,
                     resultArray3,
                     resultArray4
                     ];

    return array;
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
-(NSArray*)judgeGroupGuessRightandWrong:(NSArray*)listArray allGuessArray:(NSArray*)allGuessArray
{
    NSMutableArray*returnArray=[[NSMutableArray alloc]init];
    NSMutableArray*numberArray=[[NSMutableArray alloc]init];
    NSArray*yarray=allGuessArray[0];
    for (int j=0; j<yarray.count; j++)
    {
        NSInteger goGuessYes=0;//连续猜对的次数
        float totalMoney=0;
        NSInteger Tcount=0;
        float nextMoney=[[Utils sharedInstance].moneySelectedArray[0] floatValue];//下一次下注的钱
        NSMutableDictionary*changeTotalDic=[[NSMutableDictionary alloc]init];
        NSMutableArray*numberArr=[[NSMutableArray alloc]init];
        for (int i=0; i<listArray.count; i++)
        {
            NSString*str=listArray[i];
            if (![str isEqualToString:@"T"])
            {
                if (i-Tcount>2)
                {
                    NSString*guessStr=allGuessArray[i-Tcount-1][j];
                    if (guessStr.length>0)
                    {
                        nextMoney = [[Utils sharedInstance].moneySelectedArray[goGuessYes%[Utils sharedInstance].moneySelectedArray.count] floatValue];
                        if ([str isEqualToString:guessStr])
                        {
                            totalMoney=[guessStr isEqualToString:@"R"]?totalMoney+(1-Reduce_Money)*nextMoney:totalMoney+nextMoney ;
                           
                            if (goGuessYes>=numberArr.count)
                            {
                                [numberArr addObject: [NSString stringWithFormat:@"%0.2f|0",nextMoney]];
                            }
                            else
                            {
                                NSString*str=numberArr[goGuessYes];
                                NSArray*money=[str componentsSeparatedByString:@"|"];
                                [numberArr replaceObjectAtIndex:goGuessYes withObject:[NSString stringWithFormat:@"%0.2f|%@",nextMoney+[money[0] floatValue],money[1]]];
                            }
                             goGuessYes++;
                             nextMoney=[[Utils sharedInstance].moneySelectedArray[goGuessYes%[Utils sharedInstance].moneySelectedArray.count] floatValue];
                        }
                        else
                        {
                            if (goGuessYes>=numberArr.count)
                            {
                                [numberArr addObject: [NSString stringWithFormat:@"0|%0.2f",-nextMoney]];
                            }
                            else
                            {
                                NSString*str=numberArr[goGuessYes];
                                NSArray*money=[str componentsSeparatedByString:@"|"];
                                [numberArr replaceObjectAtIndex:goGuessYes withObject:[NSString stringWithFormat:@"%@|%0.2f",money[0],[money[1] floatValue]-nextMoney]];
                            }

                             goGuessYes=0;
                             totalMoney=totalMoney-nextMoney;
                             nextMoney=[[Utils sharedInstance].moneySelectedArray[goGuessYes%[Utils sharedInstance].moneySelectedArray.count] floatValue];
                            
                        }
                        
                        [changeTotalDic setObject:[NSString stringWithFormat:@"%0.2f",totalMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                    }
                }
                
            }
            else
            {
                Tcount++;
            }
        }
        [returnArray addObject:changeTotalDic];
        [numberArray addObject:numberArr];
    }

    return @[returnArray,numberArray];
    
}




#pragma mark------搜索（一 三 四 五）区域  个数 区域的趋势
-(NSArray*)seacherGroupRule:(NSArray*)fristPartArray listStr:(NSString*)listStr myTag:(NSInteger)myTag
{
    if (listStr.length>0)
    {
        listStr=[NSString stringWithFormat:@"%@%@",[self backString:[listStr substringToIndex:1]],listStr];
    }
    [[Utils sharedInstance] getSelectedGroupArr];
    
    NSMutableArray*answerArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[Utils sharedInstance].groupSelectedArr.count; i++)
    {
         NSDictionary*groupDic=[Utils sharedInstance].groupSelectedArr[i];
         NSArray*tepRuleArr=groupDic[@"rule"];
         NSString* totalGuessStr=@"";//所有规则猜出的字段
        for (int j=0; j<tepRuleArr.count; j++)
        {
            NSString*guessStr=@"";
            NSDictionary*oneruledic=tepRuleArr[j];
            NSMutableArray*yarr=[[NSMutableArray alloc]initWithArray: [oneruledic allKeys]];
            [yarr removeObject:@"isCycle"];
            NSString*keyStr=yarr[0];
            NSString*valueStr=oneruledic[keyStr];
            NSString*isCycle=oneruledic[@"isCycle"];
            keyStr=[NSString stringWithFormat:@"%@%@",[self backString:[keyStr substringToIndex:1]],keyStr];
            NSArray*valueArray=[listStr componentsSeparatedByString:keyStr];
            if (valueArray.count>1)
            {
                NSString*lastStr=[valueArray lastObject];//切割的最后一段字段
                NSInteger a=lastStr.length/valueStr.length;
                NSInteger b=lastStr.length%valueStr.length;
                NSString*newLastStr=@"";
                for (int j=0; j<a; j++)
                {
                    newLastStr=[NSString stringWithFormat:@"%@%@",newLastStr,valueStr];
                }
                newLastStr=[NSString stringWithFormat:@"%@%@",newLastStr,[valueStr substringToIndex:b]];
                if ([lastStr isEqualToString:newLastStr])//切割的最后一段字段和newLastStr对比
                {
                    guessStr=[valueStr substringWithRange:NSMakeRange(b, 1)];;
                }
                //是否循环的判断
                if ([isCycle isEqualToString:@"NO"])
                {
                    if (lastStr.length>=valueStr.length)
                    {
                        guessStr=@"";
                    }
                }
                /*************/
                if (guessStr.length>0)
                {
                    ////////////
                    if (totalGuessStr.length<=0)
                    {
                        totalGuessStr=guessStr;
                    }
                    else
                    {
                        if (![totalGuessStr containsString:guessStr])
                        {
                            totalGuessStr=@"";
                        }
                    }
                    
                }
                /*************/
            }
            
        }
       
        if (myTag>0&&totalGuessStr.length>0)
        {
            totalGuessStr=[self backRuleSeacher:fristPartArray ruleStr:totalGuessStr myTag:myTag];
        }
        totalGuessStr=[self getReverseStr:totalGuessStr reverseStr:groupDic[@"reverseSelect"]];
        totalGuessStr=[self getRBSelected:totalGuessStr rbStr:groupDic[@"rbSelect"]];
        [answerArray addObject:totalGuessStr];
    }
    
    
    return answerArray;
    
}




//反向
-(NSString*)getReverseStr:(NSString*)resultStr reverseStr:(NSString*)reverseStr
{
    ////反向
//    NSString*reverseStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_REVERSESELECT];
    if ([reverseStr isEqualToString:@"YES"]&&resultStr.length>0)
    {
       resultStr=[self backString:resultStr];
    }
    return resultStr;

}
//取反
-(NSString*)backString:(NSString*)str
{
    return [str isEqualToString:@"B"]?@"R":@"B";
}
 /*****庄闲选择******/
-(NSString*)getRBSelected:(NSString*)resultStr rbStr:(NSString*)rbStr
{
//    NSString*rbStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RBSELECT];
    if (![rbStr containsString:resultStr])
    {
        resultStr = @"";
    }
    return resultStr;
}

@end
