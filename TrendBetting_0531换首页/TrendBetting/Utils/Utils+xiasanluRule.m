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
-(NSArray*)seacherSpecRule:(NSArray*)fristPartArray  resultArray:(NSArray*)resultArray myTag:(NSInteger)myTag
{
    NSInteger thdCount=0;
    NSString*guessStr=@"";
    NSString*nameStr=@"";
    NSInteger allcount = fristPartArray.count;
    NSArray*lastArray=[fristPartArray lastObject];
    if (resultArray&&[resultArray[1] intValue]>0)
    {
        if ([[resultArray lastObject] isEqualToString:[fristPartArray lastObject]])
        {
            
        }
    }
    else
    {
//        NSInteger thdCount=0;
//        NSString*guessStr=@"";
//        NSString*nameStr=@"";
//        NSInteger allcount = fristPartArray.count;
//        NSArray*lastArray=[fristPartArray lastObject];
        if (lastArray.count==1&&fristPartArray.count>=4)//最后一个等于1
        {
            NSInteger yxyTag=0;//0 长跳 1多带
            bool isLast=YES;
            for (NSInteger i=allcount-2; i<allcount-4; i--)
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
                nameStr=yxyTag==0?@"跳":@"多带";
                thdCount=4;
                guessStr=[fristPartArray[allcount-2] lastObject];
                if (yxyTag==1&&fristPartArray.count>4&&[fristPartArray[allcount-5] count]==1)
                {
                    nameStr=@"一带";
                    thdCount=5;
                }
                
            }
        }
        else if(lastArray.count==2&&fristPartArray.count>=2)//最后一个等于2
        {
            NSArray*lastSecArray=fristPartArray[allcount-2];
            if (lastSecArray.count==2)
            {
                guessStr=[lastSecArray lastObject];
                nameStr=@"小";
                thdCount=2;

            }
            
        }
        else if(lastArray.count>2)
        {
            if (lastArray.count>3)
            {
                 guessStr=[lastArray lastObject];
                 nameStr=@"连";
                 thdCount=1;
            }
            
            
            if(fristPartArray.count>1)
            {
                NSArray*lastSecArray=fristPartArray[allcount-2];
                if (lastSecArray.count==lastArray.count)
                {
                    guessStr=[lastSecArray lastObject];
                    nameStr=@"小";
                    thdCount=2;
                }

            }
        }
    }

    
    
//        if (myTag>0&&guessStr.length>0)
//        {
//            guessStr=[self backRuleSeacher:jiafristPartArray ruleStr:guessStr myTag:myTag];
//        }
        NSInteger a=0;
        if (guessStr.length>0)
        {
           
            for (NSInteger i=allcount-thdCount; i<allcount; i++)
            {
                a=a+[fristPartArray[i] count];
            }
            nameStr=[NSString stringWithFormat:@"%@%ld",nameStr,a];
        }
    

    return @[nameStr,[NSString stringWithFormat:@"%ld",a],guessStr];
}

@end
