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
    if (arrGuessPartArray&&arrGuessPartArray.count>=2)
    {
        NSString*lastStr=[arrGuessPartArray lastObject];
        NSString*nextStr=arrGuessPartArray[arrGuessPartArray.count-2];
        
        NSArray*lastStrArr=[lastStr componentsSeparatedByString:@"|"];
        NSArray*nextStrArr=[nextStr componentsSeparatedByString:@"|"];
        
        if ([[lastStrArr firstObject] intValue]==[[nextStrArr lastObject] intValue]+1)//形成闭环了
        {
            if ([lastStrArr containsObject:[NSString stringWithFormat:@"%ld",partArray.count-1]])
            {
                if ([[partArray lastObject] count]<=[partArray[[nextStrArr[lastStrArr.count-1] intValue]] count])
                {
                    return [self removeNotSameArr:resultArr partArray:partArray];
                }
                
            }
            else
            {
                NSInteger b=lastStrArr.count==nextStrArr.count?0:lastStrArr.count;
                NSInteger a=[nextStrArr[b] intValue];
                NSInteger c=[nextStrArr[lastStrArr.count-1] intValue];
                if ([[partArray[a] firstObject] isEqualToString:[[partArray lastObject] firstObject]]&&[partArray[partArray.count-2] count]==[partArray[c] count]) {
                    
                    
                    if ( lastStrArr.count==nextStrArr.count)
                    {
                        [resultArr addObject:[NSString stringWithFormat:@"%ld",partArray.count-1]];
                    }
                    else
                    {
                    
                        lastStr=[NSString stringWithFormat:@"%@|%ld",lastStr,partArray.count-1];
                        [resultArr replaceObjectAtIndex:resultArr.count-1 withObject:lastStr];
                       
                    }
                     return [self removeNotSameArr:resultArr partArray:partArray];
                }
            }
        }
        
        
    }
    
        
    
    
    
    
    
    
    
    
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
//            if (position>=0&&![str containsString:[NSString stringWithFormat:@"%ld",begin]])
            if (position>=0)
            {
                NSArray*array1=partArray[position];
                NSArray*array2=partArray[begin];
                if (array1.count==array2.count)
                {
//                    if (resultArr.count>0)
//                    {
//                        NSString*lastStr=[resultArr lastObject];
//                        if ([lastStr containsString:[NSString stringWithFormat:@"%d",position]])
//                        {
//                            continue;
//                        }
//                    }
                   
                   [resultArr addObject:[NSString stringWithFormat:@"%d|%@",position,str]];
                    
                }
            }
        }
        if (resultArr.count>1)
        {
             allcount=allcount+[partArray[begin] count];
        }
        
    }
    /////////清
    if (tempResultArr.count>0)
    {
        NSInteger a=partArray.count-1;
        if (![tempResultArr[0] containsString:@"|"])
        {
            if([partArray[a] count]==1)
            {
              return @[];
            }
            if([partArray[a] count]==2)
            {
                return tempResultArr;
            }
        }
      
    }
    if (allcount<3)
    {
        return @[];
    }
   
    return tempResultArr;
}

-(NSArray*)removeNotSameArr:(NSArray*)guessArr partArray:(NSArray*)PartArray
{
    NSMutableArray*resArr=[[NSMutableArray alloc]init];
    NSArray*lastArr=[[guessArr lastObject] componentsSeparatedByString:@"|"];
    NSArray*lastSecArr=[guessArr[guessArr.count-2] componentsSeparatedByString:@"|"];
    for (int i=0; i<guessArr.count-1; i++)
    {
        NSArray*array2=[guessArr[i] componentsSeparatedByString:@"|"];
        BOOL isAdd=YES;
        for (int j=0; j<lastSecArr.count; j++)
        {
            
            if (j<lastArr.count&&[PartArray[[lastArr[j] intValue]] count]>[PartArray[[array2[j] intValue]] count])
            {
                isAdd=NO;
                break;
            }
            if(guessArr.count>3)
            {
                if ([PartArray[[lastSecArr[j] intValue]] count]!=[PartArray[[array2[j] intValue]] count]&&lastArr.count==1)
                {
                    isAdd=NO;
                    break;
                }
            }
//            else if([PartArray[[array1[j] intValue]] count]<[PartArray[[array2[j] intValue]] count])
//            {
//                if(guessArr.count>3)
//                {
//                    
//                }
//            }
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
                  如果partArray最后一列7>=下最后一列3   提示下最后一列 4 的最后一个
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
                    guessStr=@"confix";
                    break ;
                }
            }
            //排除当只有一列，有向下的提示，不提示,但向右的图形是提示的

            if([tempResultArr[0] componentsSeparatedByString:@"|"].count==1)
            {
                if(array.count!=lastCount)
                {
                    guessStr=@"";
                    break ;
                }
            }
        }
    }
    if (myTag>0&&guessStr.length>0&&[guessStr isEqualToString:@"confix"])
    {
        guessStr=[self backRuleSeacher:fristPartArray ruleStr:guessStr myTag:myTag];
    }
    
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
    int compareSum=-1;
    NSArray*speArr;
    NSInteger yxyLastCount=-1;
    NSArray*lastspecArray1;
   
    if (specArray.count>0)
    {
        lastspecArray1=[specArray[specArray.count-2] componentsSeparatedByString:@"|"];
        if (specArray.count>=3)
        {
            
            int lastspe1=[[[specArray[specArray.count-2] componentsSeparatedByString:@"|"] lastObject] intValue];
            int lastspe2=[[[specArray[specArray.count-3] componentsSeparatedByString:@"|"] lastObject] intValue];
            if ([dataArray[lastspe1] count]==[dataArray[lastspe2] count])
            {
                yxyLastCount=[dataArray[lastspe1] count];
            }
            
        }
        
         speArr=[specArray[beginSpe] componentsSeparatedByString:@"|"];
         compareSum=[speArr[compare] intValue];
    }
    
    //////
    int y=0;
    BOOL isTop=NO;//是否到顶部了
   
    
    for (int i=0; i<dataArray.count; i++)
    {
        BOOL isChange=NO;
        NSInteger repeatCount=0;
        NSArray*array=dataArray[i];
        NSInteger lastCount=array.count;
        /////
        if (i==compareSum)
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
            if (compare==lastspecArray1.count-1&&repeatCount==0)
            {
                lastCount=yxyLastCount>0?yxyLastCount:[[dataArray lastObject] count];
            }
            if (compare<speArr.count-1)
            {
                compare++;
                
                compareSum=[speArr[compare] intValue];
                
            }
            else
            {
                if (beginSpe<specArray.count-1)
                {
                    beginSpe++;
                    speArr=[specArray[beginSpe] componentsSeparatedByString:@"|"];
                    compare=0;
                    repeatCount=0;
                    compareSum=[speArr[compare] intValue];
                    while (compareSum<=i) {
                        compare++;
                        compareSum=[speArr[compare] intValue];

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
