//
//  TBWebService+Login&Register.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/8/6.
//  Copyright © 2017年 yxy. All rights reserved.

#import "TBWebService.h"

@interface TBWebService (Login_Register)

#pragma mark 注册登录

-(void)login:(NSString*)userName password:(NSString*)password success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;


#pragma mark 获取salt码

-(void)getSalt:(NSDictionary *)d success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure;
#pragma mark 获取用户信息

-(void)getUserInfo:(NSDictionary *)d success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure;
#pragma mark 修改用户标识

-(void)editUserInfo:(NSDictionary *)d success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure;
#pragma mark 获取记录json串
-(void)getServerData:(NSDictionary *)d isanimated:(BOOL)isanimated success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure;
@end
