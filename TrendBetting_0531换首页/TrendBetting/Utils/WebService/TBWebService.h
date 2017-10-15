//
//  TBWebService.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/8/6.
//  Copyright © 2017年 yxy. All rights reserved.

#import <Foundation/Foundation.h>

#define SERVER_URL @"http://usermanage.gc.to3.cc/" // test
//#define SERVER_URL  @"http://www.yhjnh.com.cn:8080/as/"    //  这个是线上环境的地址

//#define IMAGESERVER_URL @"http://120.27.41.82:8080/asupload/"
@interface TBWebService : NSObject

+ (instancetype)sharedInstance;

- (void)bascRequest:(NSString*)api postData:(id)postData success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

- (void)bascRequestGet:(NSString*)api postData:(id)postData success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

- (void)bascRequestGet:(NSString*)api postString:(NSString*)postString success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

- (void)bascRequestGetNOTCheckResult:(NSString*)api postString:(NSString*)postString success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

@end
