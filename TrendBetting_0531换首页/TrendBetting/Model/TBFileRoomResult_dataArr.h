//
//  TBFileRoomResult_dataArr.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/13.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBFileRoomResult_dataArr : NSObject
@property(copy,nonatomic)NSString*starttime;
@property(copy,nonatomic)NSString*endtime;
@property(copy,nonatomic)NSString*number;
@property(copy,nonatomic)NSArray*result;//结果 庄  闲 和 RBT
@property(copy,nonatomic)NSArray*countResult;//结果count  庄、闲、和、输、赢、输赢、总局数
@property(copy,nonatomic)NSArray*banker;
@property(copy,nonatomic)NSArray*play;

@end
