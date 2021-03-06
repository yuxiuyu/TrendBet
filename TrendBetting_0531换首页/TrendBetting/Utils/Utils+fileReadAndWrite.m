//
//  Utils+fileReadAndWrite.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/16.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+fileReadAndWrite.h"
#import "TBFileRoomResult_entry.h"
#import "Utils+xiasanluRule.h"
#import "Utils+klineRule.h"
@implementation Utils (fileReadAndWrite)
/////保存我的数据
-(BOOL)saveData:(NSDictionary*)dic  saveArray:(NSArray*)saveArray filePathStr:(NSString*)filePathStr
{
    NSFileManager*fileManager=[[NSFileManager alloc]init];
    NSString*documentDictionary=[self getHomePath];
    NSString*createPath=@"";
    NSData *fileData;
    NSString*filePath;
    if (filePathStr)
    {
        createPath=[NSString stringWithFormat:@"%@/%@",documentDictionary,SAVE_RULE_FILENAME];
        fileData = [[self arrayToJson:saveArray] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString*nameStr=[NSString stringWithFormat:@"%@.txt",filePathStr];
        filePath=[createPath stringByAppendingPathComponent:nameStr];
    }
    else
    {
        NSArray*arr=[self getNowDate];
        createPath=[NSString stringWithFormat:@"%@/%@/%@-%@",documentDictionary,SAVE_DATA_FILENAME,arr[0],arr[1]];
        fileData = [[self dictionaryToJson:dic] dataUsingEncoding:NSUTF8StringEncoding];
        NSString*nameStr=[NSString stringWithFormat:@"%d.txt",[arr[2] intValue]];
        filePath=[createPath stringByAppendingPathComponent:nameStr];
        
    }
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL isScuess=[fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    return isScuess;
    
}
-(BOOL)saveServerData:(NSString*)dataStr houseStr:(NSString*)houseStr monthStr:(NSString*)monthStr dayStr:(NSString*)dayStr{
    NSFileManager*fileManager=[[NSFileManager alloc]init];
    NSString*documentDictionary=[self getHomePath];
    NSString*createPath=[NSString stringWithFormat:@"%@/%@号/%@",documentDictionary,houseStr,monthStr];
    NSString*nameStr=[NSString stringWithFormat:@"%d.txt",[dayStr intValue]];
    NSString* filePath=[createPath stringByAppendingPathComponent:nameStr];
    NSData*fileData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL isScuess=[fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    return isScuess;
    //    NSString*nameStr=[NSString stringWithFormat:@"%@.txt",dayStr];
    //    filePath=[createPath stringByAppendingPathComponent:createPath];
    
}
/////保存我的ten数据
-(BOOL)saveTenData:(NSArray*)arr name:(NSString*)name
{
    NSFileManager*fileManager=[[NSFileManager alloc]init];
    NSString*documentDictionary=[self getHomePath];
    NSString*createPath=@"";
    NSData *fileData;
    NSString*filePath;
    createPath=[NSString stringWithFormat:@"%@/%@",documentDictionary,SAVE_RULE_FILENAME];
    fileData =  [[self arrayToJson:arr] dataUsingEncoding:NSUTF8StringEncoding];
    NSString*nameStr=[NSString stringWithFormat:@"%@.txt",name];
    filePath=[createPath stringByAppendingPathComponent:nameStr];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL isScuess=[fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    return isScuess;
    
}
////读取我的数据
-(NSDictionary*)readData:(NSString*)str
{
    
    NSString*documentDictionary=[self getHomePath];
    if (str)
    {
        documentDictionary=[NSString stringWithFormat:@"%@/%@.txt",documentDictionary,str];
    }
    else
    {
        NSArray*arr=[self getNowDate];
        //
        documentDictionary=[NSString stringWithFormat:@"%@/%@/%@-%@/%d.txt",documentDictionary,SAVE_DATA_FILENAME,arr[0],arr[1],[arr[2] intValue]];
    }
    
    NSDictionary*dic;
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentDictionary])
    {
        NSString*dataStr=[[NSString alloc]initWithContentsOfFile:documentDictionary encoding:NSUTF8StringEncoding error:nil];
        NSString *responseString = [dataStr stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        dic=[responseString objectFromJSONString];
    }
    return dic;
    
}
////读取我的Ten数据
-(NSArray*)readTenData:(NSString*)str
{
    
    NSString*documentDictionary=[self getHomePath];
    if (str)
    {
        documentDictionary=[NSString stringWithFormat:@"%@/%@.txt",documentDictionary,str];
    }
    
    
    //    NSDictionary*dic;
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentDictionary])
    {
        //        NSString*dataStr=[[NSString alloc]initWithContentsOfFile:documentDictionary encoding:NSUTF8StringEncoding error:nil];
        //        NSString *responseString = [dataStr stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        //        dic=[responseString objectFromJSONString];
        NSData*data=[NSData dataWithContentsOfFile:documentDictionary];
        if (data)
        {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
            return  [NSArray arrayWithArray:jsonObject];
        }
        
    }
    return @[];
    
}
/////读取数据类数据 如资金策略
-(NSArray*)readMoneyData:(NSString*)str
{
    NSString*documentDictionary=[self getHomePath];
    documentDictionary=[NSString stringWithFormat:@"%@/%@/%@.txt",documentDictionary,SAVE_RULE_FILENAME,str];
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentDictionary])
    {
        NSData*data=[NSData dataWithContentsOfFile:documentDictionary];
        if (data)
        {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
            return  [NSArray arrayWithArray:jsonObject];
        }
    }
    return @[];
}
-(NSArray*)getAllFileName:(NSString*)str
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString*pathStr=[self getHomePath];
    if (str)
    {
        pathStr=[NSString stringWithFormat:@"%@/%@",pathStr,str];
    }
    
    NSMutableArray * tempFileList = [[NSMutableArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:pathStr error:nil]];
    for (int i=0; i<tempFileList.count; i++)
    {
        NSString*str=tempFileList[i];
        
        if ([str containsString:@"Store" ])
        {
            [tempFileList removeObjectAtIndex:i];
            i--;
        }
        else
        {
            
        }
        
    }
    
    return tempFileList;
}

-(NSString*)dictionaryToJson:(NSDictionary*)dic
{
    NSError*error=nil;
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(NSString*)arrayToJson:(NSArray*)arr
{
    NSError*error=nil;
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(NSString*)getHomePath
{
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return  [paths objectAtIndex:0];
}
-(NSArray*)getNowDate
{
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
}

#pragma mark------
#pragma mark-----
/////////对读取到的数据进行处理

-(NSDictionary*)getDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr
{
    TBFileRoomResult_entry*roomEntry=[TBFileRoomResult_entry mj_objectWithKeyValues:[[Utils sharedInstance] readData:[NSString stringWithFormat:@"%@/%@",monthStr,dayNameStr]]];
    NSMutableArray*daySumWinCountArray=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    NSMutableDictionary*timeDic=[[NSMutableDictionary alloc]init];
    if (roomEntry.roomArr.count>0)
    {
        
        TBFileRoomResult_roomArr*room=roomEntry.roomArr[0];
        TBFileRoomResult_timeArr*time=room.timeArr[0];
        
        for (int i=0; i<time.dataArr.count; i++)
        {
            TBFileRoomResult_dataArr*tempDataArr=time.dataArr[i];
            NSArray*array=[[Utils sharedInstance] getFristArray:tempDataArr.result];
            [timeDic setObject:array forKey:[NSString stringWithFormat:@"%d",i+1]];
            for (int j=0; j<daySumWinCountArray.count; j++)
            {
                NSString*str=[NSString stringWithFormat:@"%d",[daySumWinCountArray[j] intValue]+[array[j] intValue]];
                if (j==5||j==7)
                {
                    str=[NSString stringWithFormat:@"%0.3f",[daySumWinCountArray[j] floatValue]+[array[j] floatValue]];
                }
                if (j==8)
                {
                    str=[NSString stringWithFormat:@"%0.3f",[daySumWinCountArray[j] floatValue]+[array[j] floatValue]];
                }
                
                [daySumWinCountArray replaceObjectAtIndex:j withObject:str];
                
            }
            
        }
        
        
    }
    [timeDic setObject:daySumWinCountArray forKey:@"daycount"];
    
    return timeDic;
    
}
/////////对读取到的组数据进行处理
-(NSDictionary*)getGroupDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr isContinue:(BOOL)isContinue
{
    TBFileRoomResult_entry*roomEntry=[TBFileRoomResult_entry mj_objectWithKeyValues:[[Utils sharedInstance] readData:[NSString stringWithFormat:@"%@/%@",monthStr,dayNameStr]]];
    NSMutableDictionary*timeDic=[[NSMutableDictionary alloc]init];
    if (roomEntry.roomArr.count>0)
    {
        
        TBFileRoomResult_roomArr*room=roomEntry.roomArr[0];
        TBFileRoomResult_timeArr*time=room.timeArr[0];
        NSMutableArray*allArr=[[NSMutableArray alloc]init];
        for (int i=0; i<time.dataArr.count; i++)
        {
            TBFileRoomResult_dataArr*tempDataArr=time.dataArr[i];
            if (isContinue)
            {
                [allArr addObjectsFromArray:tempDataArr.result];
            }
            else
            {
                NSArray*array=[[Utils sharedInstance] getGroupFristArray:tempDataArr.result];
                [timeDic setObject:array forKey:[NSString stringWithFormat:@"%d",i+1]];
            }
        }
        if (isContinue)
        {
            NSArray*array=[[Utils sharedInstance] getGroupFristArray:allArr];
            [timeDic setObject:array forKey:dayNameStr];
        }
    }
    
    
    return timeDic;
    
}
/////////对读取到的新的规则数据进行处理

-(NSDictionary*)getNewRuleDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr
{
    NSArray*temarr = [monthStr componentsSeparatedByString:@"/"];
    NSString*dateStr = [NSString stringWithFormat:@"%@-%@",temarr[1],dayNameStr];
    TBFileRoomResult_entry*roomEntry=[TBFileRoomResult_entry mj_objectWithKeyValues:[[Utils sharedInstance] readData:[NSString stringWithFormat:@"%@/%@",monthStr,dayNameStr]]];
    float beginPrice = 0.0;
    float maxPrice = 0.0;
    float minPrice = 0.0;
    float total = 0.0;
    NSMutableArray*winArr= [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
    NSMutableArray*failArr=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
    NSMutableArray*daySumWinCountArray=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",winArr,failArr,]];
    NSMutableDictionary*timeDic=[[NSMutableDictionary alloc]init];
    if (roomEntry.roomArr.count>0)
    {
        
        TBFileRoomResult_roomArr*room=roomEntry.roomArr[0];
        TBFileRoomResult_timeArr*time=room.timeArr[0];
        NSDateFormatter*dayformatter =[[NSDateFormatter alloc]init];
        [dayformatter setDateFormat:@"yyyy-MM-dd HH"];
        
        for (int i=0; i<time.dataArr.count; i++)
        {
            TBFileRoomResult_dataArr*tempDataArr=time.dataArr[i];
            NSMutableArray*array=[NSMutableArray arrayWithArray:[[Utils sharedInstance] getNewFristArray:tempDataArr.result]];
            //
            NSString*daydateStr = [NSString stringWithFormat:@"%@ %d",dateStr,i];
            NSDate*date = [dayformatter dateFromString:daydateStr];
            NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
            NSString*resStr = [NSString stringWithFormat:@"%@,%@",@(timeSp),[array[14] componentsJoinedByString:@","]];
            [array replaceObjectAtIndex:14 withObject:[resStr componentsSeparatedByString:@","]];
            [timeDic setObject:array forKey:[NSString stringWithFormat:@"%d",i+1]];
            
            total+=[array[14][1] floatValue];
            if (i==0) {
                beginPrice = total;
                maxPrice = total;
                minPrice = total;
            }
            if (maxPrice<total) {
                maxPrice = total;
            }
            if (minPrice>total) {
                minPrice = total;
            }
            
            for (int j=0; j<daySumWinCountArray.count; j++)
            {
                if (j<=8) {
                    NSString*str=[NSString stringWithFormat:@"%d",[daySumWinCountArray[j] intValue]+[array[j] intValue]];
                    if (j==5||j==7)
                    {
                        str=[NSString stringWithFormat:@"%0.3f",[daySumWinCountArray[j] floatValue]+[array[j] floatValue]];
                    }
                    if (j==8)
                    {
                        str=[NSString stringWithFormat:@"%0.3f",[daySumWinCountArray[j] floatValue]+[array[j] floatValue]];
                    }
                    [daySumWinCountArray replaceObjectAtIndex:j withObject:str];
                }
                else
                {
                    NSMutableArray*wArr=[[NSMutableArray alloc]initWithArray:daySumWinCountArray[j]];
                   
                        for (int k=0; k<wArr.count; k++) {
                            
                            NSString*s=[NSString stringWithFormat:@"%d",[wArr[k] intValue]+[array[j+3][k] intValue]];
                            [wArr replaceObjectAtIndex:k withObject:s];
                        }
                        [daySumWinCountArray replaceObjectAtIndex:j withObject:wArr];
                
                    
                    
                }
            }
           
            
        }
        
        
    }
    NSDateFormatter*formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*date = [formatter dateFromString:dateStr];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    NSArray*totalArr = @[@(timeSp),@(total),@(beginPrice),@(maxPrice),@(minPrice)];
    [daySumWinCountArray addObject:totalArr];
    
    [timeDic setObject:daySumWinCountArray forKey:@"daycount"];
    
    return timeDic;
    
}
// K线里获取数据
-(NSDictionary*)getKlineData:(NSString*)monthStr dayStr:(NSString*)dayNameStr isNeedTotal:(BOOL)isNeedTotal
{
    NSArray*temarr = [monthStr componentsSeparatedByString:@"/"];
    NSString*dateStr = [NSString stringWithFormat:@"%@-%@",temarr[1],dayNameStr];
    TBFileRoomResult_entry*roomEntry=[TBFileRoomResult_entry mj_objectWithKeyValues:[[Utils sharedInstance] readData:[NSString stringWithFormat:@"%@/%@",monthStr,dayNameStr]]];
    int beginPrice = 0;
    int maxPrice = 0;
    int minPrice = 0;
    int total = 0;
    int rb_count = 0;
    NSMutableArray*totalDayArr=[[NSMutableArray alloc]init];
    NSMutableDictionary*timeDic=[[NSMutableDictionary alloc]init];
    if (roomEntry.roomArr.count>0)
    {
        
        TBFileRoomResult_roomArr*room=roomEntry.roomArr[0];
        TBFileRoomResult_timeArr*time=room.timeArr[0];
        
        NSDateFormatter*dayformatter =[[NSDateFormatter alloc]init];
        [dayformatter setDateFormat:@"yyyy-MM-dd HH"];
        for (int i=0; i<time.dataArr.count; i++)
        {
            TBFileRoomResult_dataArr*tempDataArr=time.dataArr[i];
            NSArray*array=[[Utils sharedInstance] getKlineArray:tempDataArr.result]; //1、收盘价 2、开盘价 3、最高价 4、最低价
            if (isNeedTotal) { //是否需要汇总
                total+=[array[0] intValue];
                rb_count+=[array[4] intValue];
                if (i==0) {
                    beginPrice = total;
                    maxPrice = total;
                    minPrice = total;
                }
                if (maxPrice<total) {
                    maxPrice = total;
                }
                if (minPrice>total) {
                    minPrice = total;
                }
            }
            NSString*daydateStr = [NSString stringWithFormat:@"%@ %d",dateStr,i];
            NSDate*date = [dayformatter dateFromString:daydateStr];
            NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
            NSString*resStr = [NSString stringWithFormat:@"%@,%@",@(timeSp),[array componentsJoinedByString:@","]];
            [totalDayArr addObject:[resStr componentsSeparatedByString:@","]];
        }
    }
    if (isNeedTotal) { //是否需要汇总
        NSDateFormatter*formatter =[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate*date = [formatter dateFromString:dateStr];
        NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
        NSArray*totalArr = @[@(timeSp),@(total),@(beginPrice),@(maxPrice),@(minPrice),@(rb_count)];
        [timeDic setObject:totalArr forKey:@"daycount"];
    }
    [timeDic setObject:totalDayArr forKey:@"totalDayArr"];
    return timeDic;
}

// 需要的B 的个数
-(int)getStopKlineData:(NSString*)dayNameStr needValue:(int)needValue indexp:(int)indexp
{
    TBFileRoomResult_entry*roomEntry=[TBFileRoomResult_entry mj_objectWithKeyValues:[[Utils sharedInstance] readData:dayNameStr]];
    int b_count = 0;
    if (roomEntry.roomArr.count>0)
    {
        TBFileRoomResult_roomArr*room=roomEntry.roomArr[0];
        TBFileRoomResult_timeArr*time=room.timeArr[0];
        for (int i=indexp>0?indexp:0; i<time.dataArr.count; i++)
        {
            TBFileRoomResult_dataArr*tempDataArr=time.dataArr[i];
            NSArray*array=[[Utils sharedInstance] getStopBKlineArray:tempDataArr.result needValue:needValue];  //no 没有结束 yes 结束 b_count 闲的个数
            b_count+=[array[1] intValue];
            if ([array[0] isEqualToString:@"YES"]) {
                return b_count;
            }
        }
    }
    return b_count;
    
}
@end
