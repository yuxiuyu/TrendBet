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

@end
