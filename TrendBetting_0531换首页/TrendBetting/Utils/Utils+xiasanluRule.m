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
    [[Utils sharedInstance] initSetTenModel];
    int TSumCount=0;
    int RSumCount=0;
    int BSumCount=0;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
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
        if ([[userDefault objectForKey:SAVE_isOnlyRBSelect] intValue]==1) {
            str=@"R";
            [allGuessArray addObject:str];
        }
        else if ([[userDefault objectForKey:SAVE_isOnlyRBSelect] intValue]==2) {
            str=@"B";
            [allGuessArray addObject:str];
        }
        else if([Utils sharedInstance].selectArbitrageRuleName.length>0)
        {
            int a = (i-TSumCount)%[Utils sharedInstance].selectArbitrageRuleName.length;
            str=[[Utils sharedInstance].selectArbitrageRuleName substringWithRange:NSMakeRange(a, 1)];
            [allGuessArray addObject:[NSString stringWithFormat:@"%@_0",str]];
        }
        //yxy add 2017/07/17
        else
        {
            
            NSString*secGuessLastStr=[guessSecondPartArray lastObject];
            if([[newListArray lastObject] isEqualToString:@"T"]&&secGuessLastStr.length>0&&[self.tenModel.tRule isEqualToString:@"YES"]){
                [guessSecondPartArray replaceObjectAtIndex:guessSecondPartArray.count-1 withObject:@"stop"];
            }
            //            else{
            
            int mainType = [[userDefault objectForKey:SAVE_mainSelect] intValue];
            NSString*mainGuessStr;
            switch (mainType) {
                case 1:
                    mainGuessStr = [[guessThirdPartArray lastObject] lastObject];
                    break;
                case 2:
                    mainGuessStr = [[guessForthPartArray lastObject] lastObject];
                    break;
                case 4:
                    mainGuessStr = [[guessFivePartArray lastObject] lastObject];
                    break;
                default:
                    mainGuessStr = secGuessLastStr;
                    break;
            }
            if (mainGuessStr.length>0&&![mainGuessStr isEqualToString:@"stop"])
            {
                NSString*guessStr2=[[guessThirdPartArray lastObject] lastObject];
                NSString*guessStr3=[[guessForthPartArray lastObject] lastObject];
                NSString*guessStr4=[[guessFivePartArray lastObject] lastObject];
                
                NSMutableArray*guessArr=[[NSMutableArray alloc]initWithArray:@[[[guessFristPartArray lastObject] lastObject],secGuessLastStr,guessStr2,guessStr3,guessStr4]];
                if ([self.tenModel.wordRule isEqualToString:@"NO"]) {
                    [guessArr removeObjectAtIndex:0];
                }
                str=[[Utils sharedInstance] setGuessValue:guessArr isLength:NO];
            }
            //            }
            [allGuessArray addObject:str];
        }
        
        
    }
    
    ///////判断猜对猜错的个数  和收益
    NSArray*deleteArr=[self getDeleteBlodArray:listArray];
    allGuessArray=[self compareDeleteSameArr:allGuessArray deleteArr:deleteArr];
    NSArray* resultArray;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isbigRoad] intValue]==1)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect] intValue]==0)
        {
            NSMutableArray*tepguessSecondPartArray=[[NSMutableArray alloc]initWithArray:guessSecondPartArray];
            if ([self.tenModel.tRule isEqualToString:@"YES"])
            {
                for (int i=0; i<tepguessSecondPartArray.count; i++) {
                    if ([tepguessSecondPartArray[i] isEqualToString:@"stop"])
                    {
                        [tepguessSecondPartArray replaceObjectAtIndex:i withObject:@""];
                    }
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
                     resultArray[4],//每一局总的钱的变动
                     resultArray[9],//赢的
                     resultArray[10],//
                     resultArray[11]//
                     ];
    
    return array;
}
-(NSMutableArray*)compareDeleteSameArr:(NSMutableArray*)allGuessArray deleteArr:(NSArray*)deleteArr{
    if (deleteArr&&deleteArr.count>0)
    {
        for (int i=0; i<allGuessArray.count; i++) {
            NSString*str1=allGuessArray[i];
            if ([str1 containsString:@"1"]&&[str1 isEqualToString:deleteArr[i]]) {
                [allGuessArray replaceObjectAtIndex:i withObject:@""];
            }
        }
    }
    return allGuessArray;
}
-(NSArray*)getDeleteBlodArray:(NSArray*)listArray{
    NSUserDefaults*def=[NSUserDefaults standardUserDefaults];
    NSData*data=[def objectForKey:SAVE_TenDeleteBlodRule];
    if (data) {
        tenRuleModel*tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [Utils sharedInstance].tenModel=tenM;
        
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
                if([[newListArray lastObject] isEqualToString:@"T"]&&secGuessLastStr.length>0&&[self.tenModel.tRule isEqualToString:@"YES"]){
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
                        if ([self.tenModel.wordRule isEqualToString:@"NO"]) {
                            [guessArr removeObjectAtIndex:0];
                        }
                        str=[[Utils sharedInstance] setGuessValue:guessArr isLength:NO];
                    }
                }
                [allGuessArray addObject:str];
            }
            
            
        }
        return allGuessArray;
    }
    return @[];
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
                NSInteger a=[[nameStr substringFromIndex:4] intValue]+1;
                NSInteger b=[fristPartArray[allcount-1] count]+[fristPartArray[allcount-2] count]+[fristPartArray[allcount-3] count]+[fristPartArray[allcount-4] count];
                if (a>b) {
                    ///yxy add
                    NSArray*lastSecArray=fristPartArray[allcount-2];
                    NSArray*lastThirdArray=fristPartArray[allcount-3];
                    
                    
                    if (lastArray.count==lastThirdArray.count)
                    {
                        nameStr=[NSString stringWithFormat:@"%@%ld",[nameStr substringToIndex:4],a];
                        guessStr=[lastSecArray lastObject];
                        backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                        return @[nameStr,guessStr,backguessStr];
                    }
                    else if (lastArray.count>[fristPartArray[allcount-3] count])
                    {
                        if ((([self.tenModel.oneNORule isEqualToString:@"YES"]||[self.tenModel.trueOneNORule isEqualToString:@"YES"])&&[nameStr containsString:@"一带规则"])||([self.tenModel.noRuleOne isEqualToString:@"YES"]&&[nameStr containsString:@"规则带一"]))
                        {
                            nameStr=[nameStr stringByReplacingOccurrencesOfString:@"规则" withString:@"不规则"];
                            guessStr=[lastArray lastObject];
                            backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                            return @[nameStr,guessStr,backguessStr];
                            
                        }
                    }
                    else{
                        guessStr=resultArray[1];
                        nameStr=[NSString stringWithFormat:@"%@%ld",[nameStr substringToIndex:4],a];
                        backguessStr=[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:guessStr myTag:myTag];
                        return @[nameStr,guessStr,backguessStr];
                    }
                    
                    
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
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
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
        if (lastArray.count==1&&same>=[[defaults objectForKey:SAVE_GotwoCount] intValue])
        {
            if ([self.tenModel.gotwoLu isEqualToString:@"YES"]) {
                guessStr=[lastSecArray lastObject];
                nameStr=[NSString stringWithFormat:@"长跳%ld",sumcount];
            }
        }
        else if(lastArray.count>=2&&same>=2)
        {
            if (lastArray.count==2)
            {
                if ([self.tenModel.goXiaoLu isEqualToString:@"YES"]) {
                    if (same>=[[defaults objectForKey:SAVE_GoXiaoCount] intValue]) {
                        guessStr=[lastSecArray lastObject];
                        nameStr=[NSString stringWithFormat:@"小%ld路%ld",lastArray.count,sumcount];
                    }
                }
            }
            else
            {
                if ([self.tenModel.sameRule isEqualToString:@"YES"]) {
                    guessStr=[lastSecArray lastObject];
                    nameStr=[NSString stringWithFormat:@"小%ld路%ld",lastArray.count,sumcount];
                }
            }
        }
    }
    if (fristPartArray.count>=1&&nameStr.length<=0&&lastArray.count>=[[defaults objectForKey:SAVE_GoCount] intValue])
    {
        if ([self.tenModel.goLu isEqualToString:@"YES"]) {
            nameStr=[NSString stringWithFormat:@"长连%ld",lastArray.count];
            guessStr=[lastArray lastObject];
        }
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
        if ([self.tenModel.oneRule isEqualToString:@"YES"]||[self.tenModel.trueOneRule isEqualToString:@"YES"]) {
            if ([fristPartArray[allCount] count]==[fristPartArray[allCount-2] count])
            {
                nameStr=@"一带规则";
                if ([self.tenModel.trueOneRule isEqualToString:@"YES"]) {
                    guessStr=[fristPartArray[allCount-1] lastObject];
                } else {
                    guessStr=[fristPartArray[allCount] lastObject];
                }
                
                nameStr=[NSString stringWithFormat:@"%@%ld",nameStr,a];
                return @[nameStr,guessStr];
            }
        }
        
    }
    else if ([fristPartArray[allCount] count]==1&&[fristPartArray[allCount-1] count]>=2&&[fristPartArray[allCount-2] count]==1&&[fristPartArray[allCount-3] count]>=2)
    {
        if ([self.tenModel.noRuleOne isEqualToString:@"YES"]) {
            nameStr=@"不规则带一";
            guessStr=[fristPartArray[allCount-1] lastObject];
            
        }
        if ([fristPartArray[allCount-1] count]==[fristPartArray[allCount-3] count])
        {
            if ([self.tenModel.ruleOne isEqualToString:@"YES"]) {
                nameStr=@"规则带一";
                guessStr=[fristPartArray[allCount-1] lastObject];
            }
        }
        // yxy add
        if (fristPartArray.count>4&&[fristPartArray[allCount-4] count]==1)
        {
            if ([self.tenModel.oneNORule isEqualToString:@"YES"]||[self.tenModel.trueOneNORule isEqualToString:@"YES"]) {
                nameStr=@"一带不规则";
                if ([self.tenModel.trueOneNORule isEqualToString:@"YES"]) {
                    guessStr=[fristPartArray[allCount-1] lastObject];
                } else {
                    guessStr=[fristPartArray[allCount] lastObject];
                }
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
    
}//-(NSArray*)noRule:(NSArray*)fristPartArray  resultArray:(NSArray*)resultArray isyxy:(BOOL)isyxy
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
            if (isGO&&goCount>=[[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_wordGoCount] intValue]) {
                guessStr=secLastStr;
                nameStr=[NSString stringWithFormat:@"%@%ld",@"长连",goCount];
            }
            else if (!isGO&&goCount>=[[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_wordGotwoCount] intValue])
            {
                guessStr=secLastStr;
                nameStr=[NSString stringWithFormat:@"%@%ld",@"长跳",goCount];
            }
            
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
    
    NSInteger guessNo=0;//猜错的总数
    NSInteger guessYes=0;//猜对的总数
    NSInteger goGuessYes=0;//连续猜对的次数
    NSInteger goGuessNO=0;//连续猜错的次数
    float totalMoney=0;
    NSInteger Tcount=0;
    float reduceMoney=0.0;//抽水的钱
    float backMoney=0.0;//返利的钱
    float nextMoney=[[Utils sharedInstance].moneySelectedArray[0] floatValue];//下一次下注的钱
    // yyx add 2018-4-21
    float beginPrice = 0.0;
    float maxPrice = 0;
    float minPrice = 0;
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
    int intcompare =1;
    if ([Utils sharedInstance].selectArbitrageRuleName.length>0) {
        intcompare =0;
    }
    for (int i=0; i<listArray.count; i++)
    {
        NSString*str=listArray[i];
        if (![str isEqualToString:@"T"])
        {
            //            if (i-Tcount>2) //yxy add 2017/07/17 新加把把下庄闲
            if (i-Tcount>=intcompare)
            {
                NSString*guessStr=allGuessArray[i-intcompare];
                if (guessStr.length>0)
                {
                    NSArray*countArr = [guessStr componentsSeparatedByString:@"_"];
                    
                    NSInteger thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    if ([[Utils sharedInstance].moneyDirection isEqualToString:@"反追"]) {
                        thd=goGuessNO%[Utils sharedInstance].moneySelectedArray.count;
                    }
                    nextMoney = [[Utils sharedInstance].moneySelectedArray[thd] floatValue];
                    backMoney=backMoney+nextMoney*([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_BackMoney] intValue]/1000.0);
                    if ([guessStr containsString:str])  //猜对了
                    {
                        totalMoney=[guessStr containsString:@"R"]?totalMoney+(1-Reduce_Money)*nextMoney:totalMoney+nextMoney ;
                        goGuessNO=0;
                        guessYes++;
                        goGuessYes++;
                        
                        reduceMoney+=[guessStr containsString:@"R"]?Reduce_Money*nextMoney:0;
                        [changeDic setObject:[guessStr containsString:@"R"]?[NSString stringWithFormat:@"+%0.3f",(1-Reduce_Money)*nextMoney]:[NSString stringWithFormat:@"+%0.3f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                        //yxy add 2017-08-23
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
                    else  //猜错了
                    {
                        goGuessYes=0;
                        goGuessNO++;
                        totalMoney=totalMoney-nextMoney;
                        guessNo++;
                        
                        [changeDic setObject:[NSString stringWithFormat:@"-%0.3f",nextMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                        
                        //yxy add 2017-08-23
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
                    }
                    thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    if ([[Utils sharedInstance].moneyDirection isEqualToString:@"反追"]) {
                        thd=goGuessNO%[Utils sharedInstance].moneySelectedArray.count;
                    }
                    nextMoney=[[Utils sharedInstance].moneySelectedArray[thd] floatValue];
                    // yay add 2018-04-21
                    if (beginPrice==0.0) {
                        beginPrice = totalMoney;
                        maxPrice = totalMoney;
                        minPrice = totalMoney;
                    }
                    if (maxPrice<totalMoney) {
                        maxPrice = totalMoney;
                    }
                    if (minPrice>totalMoney) {
                        minPrice = totalMoney;
                    }
                    [changeTotalDic setObject:[NSString stringWithFormat:@"%0.3f",totalMoney] forKey:[NSString stringWithFormat:@"%d",i]];
                }
                else
                {
                    goGuessYes=0;//连续猜对的次数
                    goGuessNO=0;//连续猜对的次数
                    //                    NSInteger thd=goGuessYes%[Utils sharedInstance].moneySelectedArray.count;
                    nextMoney=[[Utils sharedInstance].moneySelectedArray[0] floatValue];
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
    NSArray*kArr = @[[NSString stringWithFormat:@"%0.3f",totalMoney],//收盘价
                     [NSString stringWithFormat:@"%0.3f",beginPrice],//开盘价
                     [NSString stringWithFormat:@"%0.3f",maxPrice],//最高价
                     [NSString stringWithFormat:@"%0.3f",minPrice]//最低价
                     ];
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
             failArr,
             kArr
             ];
    
}

@end
