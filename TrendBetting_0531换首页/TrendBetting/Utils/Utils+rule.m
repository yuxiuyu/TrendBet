//
//  Utils+rule.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+rule.h"

@implementation Utils (rule)





-(NSArray*)getFristArray:(NSArray*)listArray

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
    NSMutableArray*guessFivePartArray=[[NSMutableArray alloc]init];
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
            [guessFristPartArray addObject:[self seacherRule:fristPartArray listStr:listFristStr myTag:0]];
            [guessThirdPartArray addObject:[self seacherRule:fristPartArray listStr:listThirdStr myTag:1]];
            [guessForthPartArray addObject:[self seacherRule:fristPartArray listStr:listForthStr myTag:2]];
            [guessFivePartArray addObject: [self seacherRule:fristPartArray listStr:listFiveStr myTag:3]];
            NSArray*guessArr=@[[guessFristPartArray lastObject],[guessThirdPartArray lastObject],[guessForthPartArray lastObject],[guessFivePartArray lastObject]];
            if ([Utils sharedInstance].selectedTrendCode==TBLengthTrend)
            {
                [allGuessArray addObject:[self seacherLengthRule:[self changeArea:guessArr]]];
            }
            else
            {
                [allGuessArray addObject:[self setGuessValue:[self changeArea:guessArr] isLength:YES]];
            }
            
            
        }
        [newListArray addObject:resultStr];
        
    }
    ///////判断猜对猜错的个数  和收益
    NSArray*resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:newListArray allGuessArray:allGuessArray];
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
-(NSArray*)changeArea:(NSArray*)dataArray
{
    NSString*str=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_AREASELECT];
    NSArray*array=[NSArray arrayWithArray:[str componentsSeparatedByString:@"|"]];
    NSMutableArray*guessArr=[[NSMutableArray alloc]initWithArray:dataArray];
    
    int removeCount=0;
    for (int j=0; j<array.count; j++)
    {
        if ([array[j] intValue]==0)
        {
            [guessArr removeObjectAtIndex:j-removeCount];
            removeCount++;
        }
    }
    return guessArr;
}
-(NSString*)seacherLengthRule:(NSArray*)array
{
    NSString*maxStr=@"";
    //    if (countGuessFristPartArray.count>0)
    //    {
    
    NSMutableArray*sameArray=[[NSMutableArray alloc]init];
    
    maxStr=array[0];
    for (int i=1; i<array.count; i++)
    {
        if (maxStr.length<[array[i] length])
        {
            maxStr=array[i];
        }
    }
    if (maxStr.length>0)
    {
        for (int i=0; i<array.count; i++)
        {
            if (maxStr.length==[array[i] length])
            {
                [sameArray addObject:array[i]];
            }
        }
        maxStr=[[Utils sharedInstance] setGuessValue:sameArray isLength:YES];
    }
    
    //    }
    return maxStr;
    
}

-(NSMutableArray*)setNewData:(NSArray*)fristPartArray startCount:(int)startCount dataArray:(NSMutableArray*)dataArray
{
    NSInteger i=fristPartArray.count-1;
    if (i>=startCount)
    {
        NSArray*tempArray=[NSArray arrayWithArray:[fristPartArray lastObject]];
        NSInteger j=tempArray.count-1;
        if (i!=startCount||j!=0)
        {
            NSString*addStr=@"R";
            if (j==0)
            {
                if ([fristPartArray[i-startCount-1] count]!=[fristPartArray[i-1]  count])
                {
                    addStr=@"B";
                }
            }
            if ([fristPartArray[i-startCount] count]==j)
            {
                addStr=@"B";
            }
            ////////////
            
            
            ///////////////
            if(dataArray.count>0)
            {
                NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[dataArray lastObject]];
                if ([[tempArr lastObject] isEqualToString:addStr])
                {
                    [tempArr addObject:addStr];
                    [dataArray replaceObjectAtIndex:dataArray.count-1 withObject:tempArr];/////接着追加
                }
                else
                {
                    tempArr=[[NSMutableArray alloc]init];
                    [tempArr addObject:addStr];
                    [dataArray addObject:tempArr];
                }
            }
            else
            {
                
                NSMutableArray*tempArr=[[NSMutableArray alloc]init];
                [tempArr addObject:addStr];
                [dataArray addObject:tempArr];
            }
        }
    }
    return dataArray;
    
    
}
-(NSString*)addListPartData:(NSArray*)fristPartArray startCount:(int)startCount listDataStr:(NSString*)listDataStr
{
    NSInteger i=fristPartArray.count-1;
    if (i>=startCount)
    {
        NSArray*tempArray=[NSArray arrayWithArray:[fristPartArray lastObject]];
        NSInteger j=tempArray.count-1;
        if (i!=startCount||j!=0)
        {
            NSString*addStr=@"R";
            if (j==0)
            {
                if ([fristPartArray[i-startCount-1] count]!=[fristPartArray[i-1]  count])
                {
                    addStr=@"B";
                }
            }
            if ([fristPartArray[i-startCount] count]==j)
            {
                addStr=@"B";
            }
            listDataStr=[NSString stringWithFormat:@"%@%@",listDataStr,addStr];
            
            
        }
    }
    return listDataStr;
    
    
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
-(NSArray*)judgeGuessRightandWrong:(NSArray*)listArray allGuessArray:(NSArray*)allGuessArray
{
    
    NSInteger guessNo=0;//猜错的总数
    NSInteger guessYes=0;//猜对的总数
    NSInteger goGuessYes=0;//连续猜对的次数
    float totalMoney=0;
    NSInteger Tcount=0;
    float reduceMoney=0.0;//抽水的钱
    float backMoney=0.0;//返利的钱
    float nextMoney=[[Utils sharedInstance].moneySelectedArray[0] floatValue];//下一次下注的钱
    // yxy add 2017-08-23
    NSInteger winonecount = 0;
    NSInteger wintwocount = 0;
    NSInteger winthreecount = 0;
    NSInteger winforthcount = 0;
    NSInteger winfivecount = 0;
    
    NSInteger failonecount = 0;
    NSInteger failtwocount = 0;
    NSInteger failthreecount = 0;
    NSInteger failforthcount = 0;
    NSInteger failfivecount = 0;
    
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
                    NSArray*countArr = [guessStr componentsSeparatedByString:@"_"];
                    NSInteger thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    nextMoney = [[Utils sharedInstance].moneySelectedArray[thd] floatValue];
                    
                    backMoney=backMoney+nextMoney*([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_BackMoney] intValue]/1000.0);
                    
                    if ([str isEqualToString:guessStr])
                    {
                        totalMoney=[guessStr isEqualToString:@"R"]?totalMoney+(1-Reduce_Money)*nextMoney:totalMoney+nextMoney ;
                        guessYes++;
                        goGuessYes++;
                        
                        reduceMoney+=[guessStr isEqualToString:@"R"]?Reduce_Money*nextMoney:0;
                        [changeDic setObject:[guessStr isEqualToString:@"R"]?[NSString stringWithFormat:@"+%0.3f",(1-Reduce_Money)*nextMoney]:[NSString stringWithFormat:@"+%0.3f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                        //yxy add 2017-08-23
                        if (countArr.count>1) {
                            switch ([countArr[1] intValue]) {
                                case 1:
                                    winonecount++;
                                    break;
                                case 2:
                                    wintwocount++;
                                    break;
                                case 3:
                                    winthreecount++;
                                    break;
                                case 4:
                                    winforthcount++;
                                    break;
                                case 5:
                                    winfivecount++;
                                    break;
                                    
                                default:
                                    break;
                            }
                            
                        }
                        else{
                            winonecount++;
                        }
                        
                    }
                    else
                    {
                        goGuessYes=0;
                        totalMoney=totalMoney-nextMoney;
                        guessNo++;
                        [changeDic setObject:[NSString stringWithFormat:@"-%0.3f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                        //yxy add 2017-08-23
                        if (countArr.count>1) {
                            switch ([countArr[1] intValue]) {
                                case 1:
                                    failonecount++;
                                    break;
                                case 2:
                                    failtwocount++;
                                    break;
                                case 3:
                                    failthreecount++;
                                    break;
                                case 4:
                                    failforthcount++;
                                    break;
                                case 5:
                                    failfivecount++;
                                    break;
                                    
                                default:
                                    break;
                            }
                        }else{
                            failonecount++;
                        }
                        
                    }
                    thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    nextMoney=[[Utils sharedInstance].moneySelectedArray[thd] floatValue];
                    [changeTotalDic setObject:[NSString stringWithFormat:@"%0.3f",totalMoney] forKey:[NSString stringWithFormat:@"%d",i]];
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
    NSArray * winArr=@[ [NSString stringWithFormat:@"%ld",winonecount],
                        [NSString stringWithFormat:@"%ld",wintwocount],
                        [NSString stringWithFormat:@"%ld",winthreecount],
                        [NSString stringWithFormat:@"%ld",winforthcount],
                        [NSString stringWithFormat:@"%ld",winfivecount]];
    NSArray *failArr=@[ [NSString stringWithFormat:@"%ld",failonecount],
                        [NSString stringWithFormat:@"%ld",failtwocount],
                        [NSString stringWithFormat:@"%ld",failthreecount],
                        [NSString stringWithFormat:@"%ld",failforthcount],
                        [NSString stringWithFormat:@"%ld",failfivecount]];
    return @[[NSString stringWithFormat:@"%ld",guessNo],
             [NSString stringWithFormat:@"%ld",guessYes],
             [NSString stringWithFormat:@"%0.3f",totalMoney],
             changeDic,
             changeTotalDic,
             [NSString stringWithFormat:@"%0.3f",nextMoney],
             [NSString stringWithFormat:@"%0.3f",reduceMoney],
             [NSString stringWithFormat:@"%0.3f",backMoney],
             [NSString stringWithFormat:@"%ld",goGuessYes],
             winArr,
             failArr
             ];
    
}
#pragma mark--------------B R 转成 庄 闲
-(NSString*)changeChina:(NSString*)memoStr isWu:(BOOL)isWu
{
    NSString*str=@"";
    if ([memoStr length]>0)
    {
        str=[memoStr containsString:@"B"]?@"闲":@"庄";
    }
    else
    {
        if (isWu)
        {
            str=@"无";
        }
    }
    return str;
    
}


#pragma mark------搜索（一 三 四 五）区域  个数的趋势
-(NSString*)seacherRule:(NSArray*)fristPartArray listStr:(NSString*)listStr myTag:(NSInteger)myTag
{
    if (listStr.length>0)
    {
        listStr=[NSString stringWithFormat:@"%@%@",[self backString:[listStr substringToIndex:1]],listStr];
    }
    [[Utils sharedInstance] getSelectedRuleArr:[NSString stringWithFormat:@"%ld",myTag]];
    NSString* totalGuessStr=@"";//所有规则猜出的字段
    for (int i=0; i<[Utils sharedInstance].ruleSelectedKeyArr.count; i++)
    {
        NSString*guessStr=@"";
        NSString*keyStr=[Utils sharedInstance].ruleSelectedKeyArr[i];
        NSString*valueStr=[Utils sharedInstance].ruleSelectedValueArr[i];
        NSString*isCycle=[Utils sharedInstance].ruleSelectedCycleArr[i];
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
                if (lastStr.length>=valueStr.length) {
                    guessStr=@"";
                }
            }
            /*************/
            if (guessStr.length>0)
            {
                //////////出lengthCount
                NSInteger lengthCount=lastStr.length+1;
                for (NSInteger j=valueArray.count-2; j>0; j--)
                {
                    NSString*lastStr=valueArray[j];
                    if (lastStr.length<=0)
                    {
                        lengthCount=lengthCount+valueStr.length;
                    }
                    else
                    {
                        break;
                    }
                }
                ////////////
                if (totalGuessStr.length<=0)
                {
                    for (int q=0; q<lengthCount; q++)
                    {
                        totalGuessStr=[NSString stringWithFormat:@"%@%@",totalGuessStr,guessStr];
                    }
                    
                }
                else
                {
                    if ([totalGuessStr containsString:guessStr])
                    {
                        if (totalGuessStr.length<lengthCount)
                        {
                            for (int q=0; q<lengthCount-totalGuessStr.length; q++)
                            {
                                totalGuessStr=[NSString stringWithFormat:@"%@%@",totalGuessStr,guessStr];
                            }
                        }
                    }
                    else
                    {
                        return @"";
                    }
                }
                
            }
            /*************/
            
        }
    }
    if ([Utils sharedInstance].selectedTrendCode==TBAreaTrend)
    {
        totalGuessStr=totalGuessStr.length>0?[totalGuessStr substringToIndex:1]:@"";
    }
    if (myTag>0&&totalGuessStr.length>0)
    {
        totalGuessStr=[self backRuleSeacher:fristPartArray ruleStr:totalGuessStr myTag:myTag];
    }
    return totalGuessStr;
    
}
//取反
-(NSString*)backString:(NSString*)str
{
    return [str isEqualToString:@"B"]?@"R":@"B";
}
#pragma mark--------------根据有规律 猜出来的值 反推猜出来的值
-(NSString*)backRuleSeacher:(NSArray*)fristPartArray ruleStr:(NSString*)ruleStr myTag:(NSInteger)myTag
{
    if (ruleStr.length<=0)
    {
        return @"";
    }
    NSInteger mycount=fristPartArray.count-1;
    NSArray*tempArr1=fristPartArray[mycount];
    NSArray*tempArr2=fristPartArray[mycount-myTag];
    NSString*guessStr=[tempArr1 lastObject];
    if ([ruleStr containsString:@"B"])
    {
        if (tempArr1.count!=tempArr2.count)
        {
            guessStr=[fristPartArray[mycount-1] lastObject];
        }
    }
    else if ([ruleStr containsString:@"R"])
    {
        if (tempArr1.count==tempArr2.count)
        {
            guessStr=[fristPartArray[mycount-1] lastObject];
        }
    }
    NSString*str=@"";
    for (int i=0; i<ruleStr.length; i++)
    {
        str=[NSString stringWithFormat:@"%@%@",str,guessStr];
    }
    return str;
}
#pragma mark------四个区域得出的趋势 相同趋势长度相加 得出最终猜出的结果
-(NSString*)setGuessValue:(NSArray*)resultArray isLength:(BOOL)isLength
{
    NSString*guessStr=@"";
    NSInteger countR=0;
    NSInteger countB=0;
    
    
    ///
    //    for (int i=0;i<resultArray.count-1;i++)//天使给的算法
    for (int i=0;i<resultArray.count;i++)
    {
        NSString*str=[NSString stringWithFormat:@"%@",resultArray[i]];
        if ([str containsString:@"R"])
        {
            countR=countR+str.length;
        }
        if ([str containsString:@"B"])
        {
            countB=countB+str.length;
        }
    }
    if (isLength)
    {
        if (countB<countR)///R
        {
            guessStr = @"R";
        }
        else if(countB>countR)////B
        {
            guessStr = @"B";
        }
    }
    else
    {
        if (countB>0&&countR==0)
        {
            guessStr = @"B";
        }
        else if (countR>0&&countB==0)
        {
            guessStr = @"R";
        }
    }
    guessStr=[self getReverseStr:guessStr];//反向
    guessStr=[self getRBSelected:guessStr];//庄闲选择
    //yxy 2017-08-23 计算相同趋势的个数
    if (!isLength&&guessStr.length>0) {
        if (countB>0) {
            guessStr = [NSString stringWithFormat:@"%@_%ld",guessStr,countB];
        }
        else {
            guessStr = [NSString stringWithFormat:@"%@_%ld",guessStr,countR];
        }
    }
    return guessStr;
}

//反向
-(NSString*)getReverseStr:(NSString*)resultStr
{
    ////反向
    NSString*reverseStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_REVERSESELECT];
    if ([reverseStr isEqualToString:@"YES"]&&resultStr.length>0)
    {
        resultStr=[resultStr isEqualToString:@"R"]?@"B":@"R";
    }
    return resultStr;
    
}
/*****庄闲选择******/
-(NSString*)getRBSelected:(NSString*)resultStr
{
    NSString*rbStr=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RBSELECT];
    if (![rbStr containsString:resultStr])
    {
        resultStr = @"";
    }
    return resultStr;
}
#pragma mark------将得到的（一 三 四 五）区域 一个个长的数组  塞到对应的坐标上
-(NSMutableArray*)ThirdPartData:(NSMutableArray*)dataArray
{
    //chushihua
    NSMutableArray*yxyArray=[[NSMutableArray alloc]init];
    for (int i=0; i<100; i++)
    {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int j=0; j<6; j++)
        {
            [array addObject:@""];
        }
        [yxyArray addObject:array];
    }
    
    //////
    int y=0;
    BOOL isTop=NO;//是否到顶部了
    for (int i=0; i<dataArray.count; i++)
    {
        NSMutableArray*array=dataArray[i];
        if (!isTop)
        {
            y=i;
        }
        int x=0;
        BOOL isZhuan = NO;//是否转弯了
        
        for (int j=0; j<array.count; j++)
        {
            NSString*str=array[j];//要比较的数
            NSMutableArray*tempArray=yxyArray[y];
            NSString*answerStr=tempArray[x>5?5:x];
            
            if (answerStr.length>0)
            {
                y=y+1;
                isZhuan=YES;
                if (x==1)
                {
                    isTop=YES;
                }
                NSMutableArray*tempArray=[[NSMutableArray alloc] initWithArray:yxyArray[y]];
                [tempArray replaceObjectAtIndex:x-1<0?0:x-1 withObject:str];
                [yxyArray replaceObjectAtIndex:y withObject:tempArray];
                
            }
            else
            {
                if (!isZhuan)
                {
                    if (x<6)
                    {
                        x=x+1;
                    }
                }
                else
                {
                    y=y+1;
                }
                NSMutableArray*tempArray=[[NSMutableArray alloc] initWithArray:yxyArray[y]];
                [tempArray replaceObjectAtIndex:x-1 withObject:str];
                [yxyArray replaceObjectAtIndex:y withObject:tempArray];
            }
        }
    }
    return yxyArray;
}
@end
