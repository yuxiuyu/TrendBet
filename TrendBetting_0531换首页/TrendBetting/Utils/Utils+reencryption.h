//
//  Utils+resecurity.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/16.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (encryption)
- (NSString*)rebase64String:(NSString*)signStr;
- (NSString*)resha1:(NSString*)string;
@end
