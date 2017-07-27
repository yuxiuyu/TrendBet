//
//  Utils+newRules.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/5/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+newRules.h"

@implementation Utils (newRules)
#pragma mark------搜索（一 三 四 五）区域  个数 区域的趋势
-(NSArray*)seacherNewsRule:(NSArray*)partArray arrGuessPartArray:(NSArray*)arrGuessPartArray
{
   
     NSMutableArray*resultArr=[[NSMutableArray alloc]initWithArray:arrGuessPartArray];
    if (resultArr&&resultArr.count>1)
    {
        NSArray*lastStrArr=[[arrGuessPartArray lastObject] componentsSeparatedByString:@"|"];

            if ([lastStrArr containsObject:[NSString stringWithFormat:@"%ld",partArray.count-1]])
            {
                NSArray*resArr=[self removeNotSameArr:resultArr partArray:partArray];
                if(resArr.count>1){
                    return resArr;
                }
               
            }
            else
            {
                for(int i=0;i<resultArr.count;i++)
                {
                    NSArray*arr=[resultArr[i] componentsSeparatedByString:@"|"];
                    NSString*str=[NSString stringWithFormat:@"%@|%d",resultArr[i],[[arr lastObject] intValue]+1];
                    [resultArr replaceObjectAtIndex:i withObject:str];
                }
                NSArray*resArr=[self removeNotSameArr:resultArr partArray:partArray];
                if(resArr.count>1){
                    return resArr;
                }

            }
    }
    
        
    
    
    
    
    
    
    
    //找
    resultArr=[[NSMutableArray alloc]init];
    NSInteger allcount=0;
    NSInteger begin=partArray.count-1;
    int position=(begin)%2;
    
    for (int i=2; i<partArray.count; i++)
    {
        if ((i-2)%2==position)
        {
            NSArray*array1=partArray[i-2];
            NSArray*array2=partArray[begin];
           
            if (array1.count>=array2.count)
            {
                [resultArr addObject:[NSString stringWithFormat:@"%d",i-2]];
            }
        }
    }
    if (resultArr.count>0)
    {
         allcount=[[partArray lastObject] count];
        [resultArr addObject:[NSString stringWithFormat:@"%ld",begin]];
    }
    NSMutableArray*stainArr=[[NSMutableArray alloc]initWithArray:resultArr];
    NSArray*tempResultArr;
    while (resultArr.count>1&&begin>=(partArray.count+1)/2)
    {
        ///////
        tempResultArr=[NSArray arrayWithArray:resultArr];
        [resultArr removeAllObjects];
         begin=begin-1;
        for (NSString*str in tempResultArr)
        {
           
            NSArray*tepArr=[str componentsSeparatedByString:@"|"];
            position=[[tepArr firstObject] intValue]-1;
            if (position>=0)
            {
                NSArray*array1=partArray[position];
                NSArray*array2=partArray[begin];
                if (array1.count==array2.count)
                {
                   [resultArr addObject:[NSString stringWithFormat:@"%d|%@",position,str]];
                    
                }
            }
        }
        if (resultArr.count>1)
        {
             allcount=allcount+[partArray[begin] count];
             tempResultArr=[NSArray arrayWithArray:resultArr];
        }
        
    }
    /////////清

    if (allcount<3)
    {
        return @[];
    }
    //去掉长跳 和单列的
    NSArray*tArr=[[tempResultArr lastObject] componentsSeparatedByString:@"|"];
    if(tArr.count==allcount||tArr.count==1){
        return @[];
    }
    /// 两列的修改
    NSMutableArray*cutArr=[[NSMutableArray alloc]initWithArray:tempResultArr];
    NSArray*cArr=[[cutArr lastObject] componentsSeparatedByString:@"|"];
    int thd0=[cArr[0] intValue];
    int thd1=[cArr[1] intValue];
    while ([partArray[thd0] count]==1&&[partArray[thd1] count]==1) {
        for (int k=0; k<cutArr.count; k++)
        {
            NSString*res=cutArr[k];
            NSArray*aArr=[res componentsSeparatedByString:@"|"];
            res=[res substringFromIndex:[aArr[0] length]+1];
            [cutArr replaceObjectAtIndex:k withObject:res];
        }
        cArr=[[cutArr lastObject] componentsSeparatedByString:@"|"];
         thd0=[cArr[0] intValue];
         thd1=[cArr[1] intValue];
    }
    
    return  [self findLou:cArr.count resultArr:stainArr partArray:partArray];
    
   ////
    
    
    
    //yxy add 2017/07/17 排除长跳的情况（必须三个一摸一样之后才有其他的提示）
//    if(allcount==3)
//    {
//        NSArray*tArr=[[tempResultArr lastObject] componentsSeparatedByString:@"|"];
//        if(tArr.count==3)
//        {
//            NSMutableArray*tMArr=[[NSMutableArray alloc]init];
//            for (int i=0; i<tempResultArr.count; i++) {
//                 NSArray*arr=[tempResultArr[i] componentsSeparatedByString:@"|"];
//                if ([partArray[[[arr lastObject] intValue]] count]==1)
//                {
//                    [tMArr addObject:tempResultArr[i]];
//                }
//            }
//            if(tMArr.count>1)
//            {
//                tempResultArr=[NSArray arrayWithArray:tMArr];
//            }
//            else
//            {
//                return @[];
//            }
//        }
//    }
    //yxy add 2017/07/17
   
//    return cutArr;
}
-(NSArray*)findLou:(NSInteger)allcount resultArr:(NSMutableArray*)resultArr partArray:(NSArray*)partArray{
    NSInteger begin=partArray.count-1;
    NSInteger a=begin;
    NSArray*tempResultArr;

    while (a-begin<allcount-1)
    {
        ///////
        tempResultArr=[NSArray arrayWithArray:resultArr];
        [resultArr removeAllObjects];
        begin=begin-1;
        for (NSString*str in tempResultArr)
        {
            
            NSArray*tepArr=[str componentsSeparatedByString:@"|"];
           int position=[[tepArr firstObject] intValue]-1;
            if (position>=0)
            {
                NSArray*array1=partArray[position];
                NSArray*array2=partArray[begin];
                if (array1.count==array2.count)
                {
                    [resultArr addObject:[NSString stringWithFormat:@"%d|%@",position,str]];
                    
                }
            }
        }
        if (resultArr.count>1)
        {
    
            tempResultArr=[NSArray arrayWithArray:resultArr];
        }
        
    }
    return tempResultArr;
}
/*
 比较 最后一列小于等于其他规律的最后一列
 其他的要相等
 */
-(NSArray*)removeNotSameArr:(NSArray*)guessArr partArray:(NSArray*)PartArray
{
    NSMutableArray*resArr=[[NSMutableArray alloc]init];
    NSArray*lastArr=[[guessArr lastObject] componentsSeparatedByString:@"|"];
    for (int i=0; i<guessArr.count-1; i++)
    {
        NSArray*array=[guessArr[i] componentsSeparatedByString:@"|"];
        BOOL isAdd=YES;
        for (int j=0; j<array.count; j++)
        {
            
            if (j<array.count-1&&[PartArray[[lastArr[j] intValue]] count]!=[PartArray[[array[j] intValue]] count])
            {
                isAdd=NO;
                break;
            }
            else if (j==array.count-1&&[PartArray[[lastArr[j] intValue]] count]>[PartArray[[array[j] intValue]] count])
            {
                isAdd=NO;
                break;
            }

        }
        if (isAdd)
        {
            [resArr addObject:guessArr[i]];
        }
    }
    [resArr addObject:[guessArr lastObject]];
    return resArr ;
}
-(NSString*)getGuessValue:(NSArray*)tempResultArr partArray:(NSArray*)partArray fristPartArray:(NSArray*)fristPartArray myTag:(int)myTag
{
    /*
     原理：
     如1|2|3   5|6|7
     只比较最后一列，如果partArray最后一列7<下最后一列3    提示下最后一列 7 的最后一个
                  如果partArray最后一列7==下最后一列3   提示下最后一列 4 的最后一个
    */
     NSString*guessStr=@"";
    
    if (tempResultArr&&tempResultArr.count>0)
    {
        NSInteger lastCount=[[partArray lastObject] count];
        NSInteger thd=[[[tempResultArr lastObject] componentsSeparatedByString:@"|"] count]-1;
        for (int i=0; i<tempResultArr.count-1; i++)
        {
            NSArray*sparray=[tempResultArr[i] componentsSeparatedByString:@"|"];
            NSString* str=sparray[thd];
            NSArray*array=partArray[[str intValue]];
            NSString*tempStr=array.count>lastCount?[array lastObject]:[partArray[[str intValue]+1] lastObject];
            
            if (guessStr.length<=0)
            {
                guessStr=tempStr;
            }
            else
            {
                if (![guessStr containsString:tempStr])
                {
                    guessStr=@"";
//                    guessStr=[partArray[[str intValue]+1] lastObject];
                    break ;
                }
            }
            //排除当只有一列，有向下的提示，不提示,但向右的图形是提示的

            if([tempResultArr[0] componentsSeparatedByString:@"|"].count==1)
            {
                if(array.count!=lastCount)
                {
                    guessStr=@"";
                    continue ;
                }
            }
        }
    }
//    if (myTag>0&&guessStr.length>0)
//    {
//        guessStr=[self backRuleSeacher:fristPartArray ruleStr:guessStr myTag:myTag];
//    }
    
       return guessStr;
    
}
#pragma mark------将得到的（一 三 四 五）区域 一个个长的数组  塞到对应的坐标上
-(NSMutableArray*)newPartData:(NSMutableArray*)dataArray specArray:(NSArray*)specArray
{
    //初始化数据
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
    ////
    int beginSpe=0;
    int compare=0;
    int compareI=-1;
    NSInteger repeatCount=0;
    NSArray*speArr;

    if (specArray.count>0)
    {
         speArr=[specArray[beginSpe] componentsSeparatedByString:@"|"];
         compareI=[speArr[compare] intValue];
    }
    
    //////
    int y=0;
    BOOL isTop=NO;//是否到顶部了
   
    
    for (int i=0; i<dataArray.count; i++)
    {
        BOOL isChange=NO;
       
        NSArray*array=dataArray[i];
        NSInteger lastCount=array.count;
        /////
        if (i==compareI)
        {
            isChange=YES;
            if (beginSpe<specArray.count-1)
            {
                NSArray*repeatArr=[specArray[beginSpe+1] componentsSeparatedByString:@"|"];
                NSInteger repeat=[repeatArr[repeatCount] intValue];
                if (i==repeat)
                {
                    if (lastCount<[dataArray[repeat] count]) {
                        lastCount=[dataArray[repeat] count];
                    }
                    repeatCount++;
                }
            }
            if (compare==speArr.count-1&&repeatCount==0)//到最后一个，没有重复的的，
            {
                lastCount=[[dataArray lastObject] count];
            }
            if (compare<speArr.count-1)
            {
                compare++;
                compareI=[speArr[compare] intValue];
                
            }
            else
            {
                if (beginSpe<specArray.count-1)
                {
                    beginSpe++;
                    speArr=[specArray[beginSpe] componentsSeparatedByString:@"|"];
                    compare=0;
                    repeatCount=0;
                    compareI=[speArr[compare] intValue];
                    while (compareI<=i) {
                        compare++;
                        compareI=[speArr[compare] intValue];

                    }
                   
                }
            }
        }
        ///////
        if (!isTop)
        {
            y=i;
        }
        int x=0;
        BOOL isZhuan = NO;//是否转弯了
        
        for (int j=0; j<array.count; j++)
        {
            NSString*str=array[j];//要比较的数
           
            str=(isChange&&j<lastCount)?[NSString stringWithFormat:@"%@1",str]:str;
            
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
