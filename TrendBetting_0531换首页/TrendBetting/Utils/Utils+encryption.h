//
//  Utils+security.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/14.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (encryption)
- (NSString *)base64String:(NSString*)signStr;
- (NSString *)sha1:(NSString*)string;
- (NSString *)stringFromMD5:(NSString *)string;
- (NSString *)getNowTimeTimestamp;
@end
