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
-(NSArray*)seacherGroupRule:(NSArray*)fristPartArray  resultArray:(NSArray*)resultArray myTag:(NSInteger)myTag
{
    
        NSString*guessStr=@"";
        NSString*nameStr=@"";
        NSInteger allcount = fristPartArray.count;
        NSArray*lastArray=[fristPartArray lastObject];
        if (lastArray.count==1&&fristPartArray.count>=4)//最后一个等于1
        {
            NSInteger yxyTag=0;//0 长跳 1
            bool isLast=YES;
            for (NSInteger i=allcount-2; i<=0; i--)
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
            }
        }
        else if(lastArray.count==2&&fristPartArray.count>=2)//最后一个等于2
        {
            NSArray*lastSecArray=fristPartArray[allcount-2];
            if (lastSecArray.count==2)
            {
                guessStr=[lastSecArray lastObject];
            }
            else if (lastSecArray.count==1&&fristPartArray
                     .count>=4)
            {
                bool isLast=YES;
                for (NSInteger i=allcount-2; i<=0; i--)
                {
                    NSArray*array=fristPartArray[i];
                    if ((i==allcount-3&&array.count<2)||(i==allcount-4&&array.count!=1))
                    {
                        isLast=NO;
                    }
                }
                if (isLast)
                {
                    guessStr=[lastSecArray lastObject];
                }
            }
        }
        else
        {
            guessStr=[lastArray lastObject];
            
            if(fristPartArray.count>1)
            {
                NSArray*lastSecArray=fristPartArray[allcount-2];
                if (lastSecArray.count==lastArray.count)
                {
                    guessStr=[lastSecArray lastObject];
                }
                else if (fristPartArray.count>=4&&lastSecArray.count==1)
                {
                    bool isLast=YES;
                    for (NSInteger i=allcount-2; i<=0; i--)
                    {
                        NSArray*array=fristPartArray[i];
                        if ((i==allcount-3&&array.count<2)||(i==allcount-4&&array.count!=1))
                        {
                            isLast=NO;
                        }
                    }
                    if (isLast)
                    {
                        guessStr=[lastSecArray lastObject];
                    }

                }
            }
        }

    
    
        if (myTag>0&&guessStr.length>0)
        {
            guessStr=[self backRuleSeacher:fristPartArray ruleStr:guessStr myTag:myTag];
        }

    return @[];
}

@end
