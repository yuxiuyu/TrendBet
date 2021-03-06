//
//  Utils+resecurity.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/16.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+reencryption.h"
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
@implementation Utils (encryption)
-(NSString*)rebase64String:(NSString*)signStr
{
    NSString*str=[NSString stringWithFormat:@"%@%@",signStr,[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    NSData*data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSString*baseStr=[data base64EncodedStringWithOptions:0];
    return [self resha1:baseStr];
}
- (NSString*) resha1:(NSString*)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}
@end
