//
//  TBWebService+Login&Register.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/8/6.
//  Copyright © 2017年 yxy. All rights reserved.

#import "TBWebService+Login&Register.h"


#define PASSWORD_PREFIX @"Yh+YearHua#2o一六"

@implementation TBWebService (Login_Register)


#pragma mark 注册登录

-(void)login:(NSString*)phoneNumber password:(NSString*)password success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
  NSDictionary* postDict = @{@"phone":phoneNumber,@"pwd":password};
  [self bascRequest:@"api/login" postData:postDict success:success failure:failure];
}

#pragma mark 获取salt码

-(void)getSalt:(NSDictionary *)d success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure
{
    [self bascRequest:@"api/Uservalidate/getsalt" postData:d success:success failure:failure];
}
#pragma mark 获取用户信息

-(void)getUserInfo:(NSDictionary *)d success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure
{
    [self bascRequest:@"api/Uservalidate/getuserinfo" postData:d success:success failure:failure];
}
#pragma mark 修改用户标识

-(void)editUserInfo:(NSDictionary *)d success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure
{
    [self bascRequest:@"api/Uservalidate/setuniquestr" postData:d success:success failure:failure];
}
#pragma mark 获取记录json串
-(void)getServerData:(NSDictionary *)d success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSString * error))failure
{
    [self bascRequest:@"api/Game/jsonstr" postData:d success:success failure:failure];
}
@end
